const pool = require('../config/database');
const { paginate } = require('../utils/paginate');

async function getProducts({ keyword, category, brand, minPrice, maxPrice,
                              onSale, inStock, sort = 'newest', page = 1 }) {
  const where = ['p.status != "inactive"'];
  const params = [];

  if (keyword) {
    where.push('(p.name LIKE ? OR p.brand LIKE ?)');
    params.push(`%${keyword}%`, `%${keyword}%`);
  }
  if (category) { where.push('c.slug = ?'); params.push(category); }
  if (brand) { where.push('p.brand = ?'); params.push(brand); }
  if (minPrice) { where.push('COALESCE(p.sale_price, p.price) >= ?'); params.push(minPrice); }
  if (maxPrice) { where.push('COALESCE(p.sale_price, p.price) <= ?'); params.push(maxPrice); }
  if (onSale === '1') where.push('p.sale_price IS NOT NULL');
  if (inStock === '1') where.push('p.stock_quantity > 0');

  const sortMap = {
    newest:     'p.created_at DESC',
    price_asc:  'COALESCE(p.sale_price, p.price) ASC',
    price_desc: 'COALESCE(p.sale_price, p.price) DESC',
    rating:     'p.avg_rating DESC',
    popular:    'p.review_count DESC'
  };
  const orderBy = sortMap[sort] || sortMap.newest;
  const whereClause = `WHERE ${where.join(' AND ')}`;

  const [countRows] = await pool.query(
    `SELECT COUNT(*) AS cnt FROM products p JOIN categories c ON p.category_id = c.id ${whereClause}`,
    params
  );
  const paginInfo = paginate(countRows[0].cnt, page, 12);

  const [products] = await pool.query(
    `SELECT p.*, c.name AS category_name, c.slug AS category_slug,
            pi.image_url AS main_image
     FROM products p
     JOIN categories c ON p.category_id = c.id
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     ${whereClause}
     ORDER BY ${orderBy}
     LIMIT ? OFFSET ?`,
    [...params, paginInfo.pageSize, paginInfo.offset]
  );

  return { products, pagination: paginInfo };
}

async function getProductBySlug(slug) {
  const [rows] = await pool.query(
    `SELECT p.*, c.name AS category_name, c.slug AS category_slug
     FROM products p JOIN categories c ON p.category_id = c.id
     WHERE p.slug = ? AND p.status != 'inactive'`,
    [slug]
  );
  if (!rows.length) return null;
  const product = rows[0];

  const [images] = await pool.query(
    'SELECT * FROM product_images WHERE product_id = ? ORDER BY is_main DESC, sort_order',
    [product.id]
  );
  product.images = images;

  const [reviews] = await pool.query(
    `SELECT r.*, u.full_name FROM reviews r JOIN users u ON r.user_id = u.id
     WHERE r.product_id = ? AND r.status = 'visible'
     ORDER BY r.created_at DESC LIMIT 5`,
    [product.id]
  );
  product.reviews = reviews;

  const [related] = await pool.query(
    `SELECT p.*, pi.image_url AS main_image
     FROM products p
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     WHERE p.category_id = ? AND p.id != ? AND p.status = 'active'
     ORDER BY RAND() LIMIT 4`,
    [product.category_id, product.id]
  );
  product.related = related;

  return product;
}

async function getFeaturedProducts() {
  const [onSale] = await pool.query(
    `SELECT p.*, pi.image_url AS main_image FROM products p
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     WHERE p.sale_price IS NOT NULL AND p.status = 'active'
     ORDER BY (p.price - p.sale_price) DESC LIMIT 8`
  );
  const [newest] = await pool.query(
    `SELECT p.*, pi.image_url AS main_image FROM products p
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     WHERE p.status = 'active' ORDER BY p.created_at DESC LIMIT 8`
  );
  const [topRated] = await pool.query(
    `SELECT p.*, pi.image_url AS main_image FROM products p
     LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_main = 1
     WHERE p.status = 'active' AND p.review_count > 0
     ORDER BY p.avg_rating DESC LIMIT 8`
  );
  return { onSale, newest, topRated };
}

async function getAllCategories() {
  const [rows] = await pool.query(
    "SELECT * FROM categories WHERE status = 'active' ORDER BY sort_order"
  );
  return rows;
}

async function getAllBrands() {
  const [rows] = await pool.query(
    "SELECT DISTINCT brand FROM products WHERE brand IS NOT NULL AND status = 'active' ORDER BY brand"
  );
  return rows.map(r => r.brand);
}

module.exports = { getProducts, getProductBySlug, getFeaturedProducts, getAllCategories, getAllBrands };
