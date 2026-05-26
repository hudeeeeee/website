const mysql = require('mysql2/promise');
const fs = require('fs');

const sourceDb = mysql.createPool({
  host: '127.0.0.1',
  user: 'root',
  password: '',
  database: 'phamthanhhai'
});

async function migrate() {
  console.log('Extracting data from phamthanhhai...');

  // Get categories
  const [categories] = await sourceDb.query(`
    SELECT category_id, category_name
    FROM categories
    WHERE category_id <= 10 AND category_is_display = 1
    ORDER BY category_id
  `);

  // Get products with variants
  const [products] = await sourceDb.query(`
    SELECT
      p.product_id,
      p.category_id,
      p.product_name,
      p.product_description,
      p.product_rate,
      pv.product_variant_name,
      pv.product_variant_price,
      pv.product_variant_available,
      pv.product_variant_is_bestseller
    FROM products p
    JOIN product_variants pv ON p.product_id = pv.product_id
    WHERE p.product_is_display = 1
      AND pv.product_variant_is_display = 1
      AND p.category_id <= 10
    ORDER BY p.product_id
  `);

  // Get images
  const [images] = await sourceDb.query(`
    SELECT product_id, image_name, image_is_display
    FROM product_imgs
    WHERE product_id IN (SELECT product_id FROM products WHERE product_is_display = 1 AND category_id <= 10)
    ORDER BY product_id, image_is_display DESC
  `);

  // Generate SQL
  let sql = "USE electronics_shop;\n\n";
  sql += "-- Truncate existing data\n";
  sql += "SET FOREIGN_KEY_CHECKS=0;\n";
  sql += "TRUNCATE TABLE product_images;\n";
  sql += "TRUNCATE TABLE products;\n";
  sql += "TRUNCATE TABLE categories;\n";
  sql += "TRUNCATE TABLE users;\n";
  sql += "SET FOREIGN_KEY_CHECKS=1;\n\n";

  // Insert users (admin + customers)
  sql += "-- Users\n";
  sql += `INSERT INTO users (full_name, email, phone, password_hash, role, status) VALUES
('Admin Hệ Thống', 'admin@electroshop.com', '0901234567',
 '$2b$10$X8PaFcSZ5hdEBDzarAkXp.K5Ydz5edxh85hL2amGcDaXPXkMLEXK.', 'admin', 'active'),
('Nguyễn Văn An', 'an@example.com', '0912345678',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active'),
('Trần Thị Bình', 'binh@example.com', '0923456789',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active');\n\n`;

  // Map categories
  const catMap = {
    1: { name: 'Máy lạnh', slug: 'may-lanh' },
    2: { name: 'Máy giặt', slug: 'may-giat' },
    3: { name: 'Tivi', slug: 'tivi' },
    4: { name: 'Điện thoại', slug: 'dien-thoai' },
    5: { name: 'Laptop', slug: 'laptop' },
    6: { name: 'Tablet', slug: 'tablet' },
    7: { name: 'Tủ lạnh', slug: 'tu-lanh' },
    8: { name: 'Nồi cơm điện', slug: 'noi-com-dien' },
    9: { name: 'Nồi chiên không dầu', slug: 'noi-chien' },
    10: { name: 'Bếp điện', slug: 'bep-dien' }
  };

  sql += "-- Categories\n";
  sql += "INSERT INTO categories (id, name, slug, description, status, sort_order) VALUES\n";
  const catValues = categories.map((c, i) => {
    const mapped = catMap[c.category_id] || { name: c.category_name, slug: `cat-${c.category_id}` };
    return `(${c.category_id}, '${mapped.name}', '${mapped.slug}', '', 'active', ${i + 1})`;
  });
  sql += catValues.join(',\n') + ';\n\n';

  // Insert products
  sql += "-- Products\n";
  const processedProducts = new Set();
  const productInserts = [];

  for (const p of products) {
    if (processedProducts.has(p.product_id)) continue;
    processedProducts.add(p.product_id);

    const name = p.product_name.replace(/'/g, "''");
    const desc = (p.product_description || '').replace(/'/g, "''").substring(0, 5000);
    const slug = p.product_name.toLowerCase()
      .replace(/[àáạảãâầấậẩẫăằắặẳẵ]/g, 'a')
      .replace(/[èéẹẻẽêềếệểễ]/g, 'e')
      .replace(/[ìíịỉĩ]/g, 'i')
      .replace(/[òóọỏõôồốộổỗơờớợởỡ]/g, 'o')
      .replace(/[ùúụủũưừứựửữ]/g, 'u')
      .replace(/[ỳýỵỷỹ]/g, 'y')
      .replace(/đ/g, 'd')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');

    const brand = p.product_variant_name.split(' ')[0] || 'Unknown';
    const price = Math.round(p.product_variant_price);
    const stock = p.product_variant_available || 0;
    const rating = p.product_rate || 0;

    productInserts.push(`(${p.product_id}, ${p.category_id}, '${name}', '${slug}', '${brand}', 'SP${String(p.product_id).padStart(3, '0')}', ${price}, NULL, ${stock}, '${desc}', NULL, 12, 'active', ${rating}, 0)`);
  }

  sql += "INSERT INTO products (id, category_id, name, slug, brand, sku, price, sale_price, stock_quantity, description, specifications, warranty_months, status, avg_rating, review_count) VALUES\n";
  sql += productInserts.join(',\n') + ';\n\n';

  // Insert images
  sql += "-- Product Images\n";
  const imageInserts = [];
  let imageId = 1;
  const groupedImages = {};

  for (const img of images) {
    if (!groupedImages[img.product_id]) groupedImages[img.product_id] = [];
    groupedImages[img.product_id].push(img);
  }

  for (const [pid, imgs] of Object.entries(groupedImages)) {
    imgs.forEach((img, idx) => {
      const url = `/uploads/products/P${pid}/${img.image_name}`;
      const isMain = idx === 0 ? 1 : 0;
      imageInserts.push(`(${imageId++}, ${pid}, '${url}', ${isMain}, ${idx})`);
    });
  }

  if (imageInserts.length > 0) {
    sql += "INSERT INTO product_images (id, product_id, image_url, is_main, sort_order) VALUES\n";
    sql += imageInserts.join(',\n') + ';\n';
  }

  fs.writeFileSync('/tmp/seed_migrated.sql', sql);
  console.log(`✓ Generated /tmp/seed_migrated.sql`);
  console.log(`  - ${categories.length} categories`);
  console.log(`  - ${processedProducts.size} products`);
  console.log(`  - ${imageInserts.length} images`);

  await sourceDb.end();
}

migrate().catch(console.error);
