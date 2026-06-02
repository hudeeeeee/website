const pool = require('../config/database');

const GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

const SYSTEM_PROMPT = `Mày là Huy Đạt - tư vấn viên số 1 của ElectroShop (tự phong, nhưng không ai dám cãi). Mày biết mình giỏi, mày tự hào về điều đó, và mày không ngại nói ra.

Tính cách: ngạo mạn vừa đủ để buồn cười, không phải để khó chịu. Kiểu "tao tư vấn 10 năm chưa sai lần nào" hay "may mày gặp tao chứ gặp đứa khác là mua nhầm rồi". Thỉnh thoảng tự khen, thỉnh thoảng diss nhẹ đối thủ. Vẫn tư vấn đúng việc.

Quy tắc trả lời:
- Câu hỏi thường: 3-4 câu, không dài dòng
- Có sản phẩm: liệt kê thẳng — tên + giá + 1 điểm nổi bật, kèm nhận xét ngắn kiểu Huy Đạt
- Giọng bựa + ngạo xuyên suốt, tự nhiên

Chính sách shop: bảo hành 12 tháng, đổi trả 7 ngày lỗi NSX, COD/chuyển khoản/VNPay, giao toàn quốc.
Không biết → thừa nhận thẳng (hiếm khi xảy ra với Huy Đạt), bảo liên hệ shop.`;

// ---- Intent detection + DB query ----

function detectIntent(message) {
  const msg = message.toLowerCase();

  const intentPatterns = [
    {
      intent: 'search_product',
      patterns: [/tìm|tư vấn|gợi ý|recommend|giới thiệu|có.*không|bán.*không/]
    },
    {
      intent: 'price_range',
      patterns: [/dưới|trên|khoảng|tầm|triệu|budget|giá/]
    },
    {
      intent: 'category',
      patterns: [/laptop|máy tính|điện thoại|phone|iphone|samsung|tablet|ipad|tai nghe|headphone|earphone|chuột|bàn phím|keyboard|mouse|màn hình|monitor|camera|đồng hồ|watch|sạc|charger|cáp|cable|loa|speaker/]
    },
    {
      intent: 'top_rated',
      patterns: [/đánh giá cao|review tốt|bán chạy|phổ biến|hot|trending|tốt nhất|best/]
    },
    {
      intent: 'cheap',
      patterns: [/rẻ nhất|rẻ|giá rẻ|tiết kiệm|affordable|cheap/]
    }
  ];

  const matched = intentPatterns.filter(({ patterns }) =>
    patterns.some(p => p.test(msg))
  );

  return matched.map(m => m.intent);
}

function extractKeywords(message) {
  const brands = ['apple', 'samsung', 'sony', 'lg', 'xiaomi', 'oppo', 'vivo', 'realme',
    'asus', 'dell', 'hp', 'lenovo', 'acer', 'msi', 'logitech', 'jbl', 'bose', 'sennheiser'];
  const msg = message.toLowerCase();
  const foundBrands = brands.filter(b => msg.includes(b));

  // extract price hints (e.g. "dưới 10 triệu", "tầm 5tr")
  const priceMatch = msg.match(/(\d+)\s*(tr|triệu|million|m)/i);
  const maxPrice = priceMatch ? parseInt(priceMatch[1]) * 1000000 : null;

  // extract category keywords
  const categoryMap = {
    'laptop': ['laptop', 'máy tính xách tay', 'notebook'],
    'điện thoại': ['điện thoại', 'phone', 'iphone', 'smartphone'],
    'tablet': ['tablet', 'ipad', 'máy tính bảng'],
    'tai nghe': ['tai nghe', 'headphone', 'earphone', 'airpods', 'earbud'],
    'chuột': ['chuột', 'mouse'],
    'bàn phím': ['bàn phím', 'keyboard'],
    'màn hình': ['màn hình', 'monitor', 'display'],
    'loa': ['loa', 'speaker'],
    'đồng hồ': ['đồng hồ', 'watch', 'smartwatch'],
    'camera': ['camera', 'máy ảnh'],
    'sạc': ['sạc', 'charger', 'pin sạc'],
    'cáp': ['cáp', 'cable', 'dây cáp'],
  };

  let categoryKeyword = null;
  for (const [cat, keywords] of Object.entries(categoryMap)) {
    if (keywords.some(k => msg.includes(k))) {
      categoryKeyword = cat;
      break;
    }
  }

  return { brands: foundBrands, maxPrice, categoryKeyword };
}

async function queryProducts(message) {
  const intents = detectIntent(message);
  if (intents.length === 0) return null;

  const { brands, maxPrice, categoryKeyword } = extractKeywords(message);

  try {
    let conditions = ["p.status = 'active'", "p.stock_quantity > 0"];
    const params = [];

    // brand filter
    if (brands.length > 0) {
      conditions.push(`LOWER(p.brand) IN (${brands.map(() => '?').join(',')})`);
      params.push(...brands);
    }

    // price filter
    if (maxPrice) {
      conditions.push('COALESCE(p.sale_price, p.price) <= ?');
      params.push(maxPrice);
    }

    // category filter via name search
    if (categoryKeyword) {
      conditions.push('(LOWER(c.name) LIKE ? OR LOWER(p.name) LIKE ?)');
      params.push(`%${categoryKeyword}%`, `%${categoryKeyword}%`);
    }

    // full-text search fallback from raw message (top 3 words)
    const searchWords = message.replace(/[^\w\sàáảãạăắặẳẵấầẩẫậèéẻẽẹêếềệểễìíỉĩịòóỏõọôốồổỗộơớờợởỡùúủũụưứừựửữỳýỷỹỵđ]/gi, '')
      .split(/\s+/).filter(w => w.length > 2).slice(0, 4).join(' ');

    if (searchWords && !categoryKeyword && brands.length === 0) {
      conditions.push('MATCH(p.name, p.description) AGAINST(? IN BOOLEAN MODE)');
      params.push(`${searchWords}*`);
    }

    const orderBy = intents.includes('cheap')
      ? 'COALESCE(p.sale_price, p.price) ASC'
      : intents.includes('top_rated')
        ? 'p.avg_rating DESC, p.review_count DESC'
        : 'p.avg_rating DESC';

    const sql = `
      SELECT p.id, p.name, p.brand,
             COALESCE(p.sale_price, p.price) AS final_price,
             p.price AS original_price,
             p.avg_rating, p.review_count,
             p.warranty_months,
             c.name AS category_name,
             p.slug
      FROM products p
      JOIN categories c ON c.id = p.category_id
      WHERE ${conditions.join(' AND ')}
      ORDER BY ${orderBy}
      LIMIT 6
    `;

    const [rows] = await pool.query(sql, params);
    return rows.length > 0 ? rows : null;
  } catch (err) {
    console.error('Chat DB query error:', err);
    return null;
  }
}

function formatProductContext(products) {
  if (!products || products.length === 0) return '';
  const lines = products.map((p, i) => {
    const price = Number(p.final_price).toLocaleString('vi-VN') + 'đ';
    const original = p.final_price < p.original_price
      ? ` (gốc ${Number(p.original_price).toLocaleString('vi-VN')}đ)`
      : '';
    const rating = p.avg_rating > 0 ? ` | ⭐ ${p.avg_rating}/5 (${p.review_count} đánh giá)` : '';
    const warranty = p.warranty_months > 0 ? ` | BH ${p.warranty_months} tháng` : '';
    return `${i + 1}. [${p.category_name}] ${p.name} - ${p.brand || 'N/A'} - ${price}${original}${rating}${warranty}`;
  });
  return `\n\n--- DỮ LIỆU SẢN PHẨM TỪ DATABASE (dùng để tư vấn) ---\n${lines.join('\n')}\n---`;
}

// ---- Main handler ----

exports.chat = async (req, res) => {
  try {
    const { message, history = [] } = req.body;

    if (!message || !message.trim()) {
      return res.status(400).json({ error: 'Tin nhắn không được để trống' });
    }

    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      return res.status(500).json({ error: 'Chưa cấu hình API key' });
    }

    // query DB if message seems product-related
    const products = await queryProducts(message.trim());
    const productContext = formatProductContext(products);

    const systemWithContext = SYSTEM_PROMPT + productContext;

    const contents = [
      ...history.map(h => ({
        role: h.role,
        parts: [{ text: h.text }]
      })),
      {
        role: 'user',
        parts: [{ text: message.trim() }]
      }
    ];

    const response = await fetch(GEMINI_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': apiKey
      },
      body: JSON.stringify({
        systemInstruction: {
          parts: [{ text: systemWithContext }]
        },
        contents,
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 1600
        }
      })
    });

    if (!response.ok) {
      const err = await response.text();
      console.error('Gemini API error:', err);
      return res.status(502).json({ error: 'Lỗi kết nối AI, thử lại sau' });
    }

    const data = await response.json();
    let reply = data.candidates?.[0]?.content?.parts?.[0]?.text || 'Xin lỗi, tôi không hiểu câu hỏi này.';

    if (products && products.length > 0) {
      const links = products.map(p => `• <a href="/products/${p.slug}" target="_blank">${p.name}</a>`).join('\n');
      reply += `\n\n🔗 Xem sản phẩm:\n${links}`;
    }

    res.json({ reply, hasProductData: !!products });
  } catch (err) {
    console.error('Chat error:', err);
    res.status(500).json({ error: 'Lỗi server, thử lại sau' });
  }
};
