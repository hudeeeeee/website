const fs = require('fs');

// Read products TSV
const lines = fs.readFileSync('/mnt/c/Temp/products.txt', 'utf-8').split('\n');
lines.shift(); // remove header

const products = new Map();

for (const line of lines) {
  if (!line.trim()) continue;
  const [id, catId, name, variant, price, stock] = line.split('\t');
  if (!products.has(id)) {
    const slug = name.toLowerCase()
      .replace(/[àáạảãâầấậẩẫăằắặẳẵ]/g, 'a')
      .replace(/[èéẹẻẽêềếệểễ]/g, 'e')
      .replace(/[ìíịỉĩ]/g, 'i')
      .replace(/[òóọỏõôồốộổỗơờớợởỡ]/g, 'o')
      .replace(/[ùúụủũưừứựửữ]/g, 'u')
      .replace(/[ỳýỵỷỹ]/g, 'y')
      .replace(/đ/g, 'd')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');

    const brand = name.split(' ')[name.includes('Máy') ? 2 : 0] || 'Unknown';

    products.set(id, {
      id,
      catId,
      name: name.replace(/'/g, "''"),
      slug,
      brand,
      price: parseInt(price),
      stock: parseInt(stock)
    });
  }
}

// Generate SQL
let sql = "USE electronics_shop;\n\n";
sql += "SET FOREIGN_KEY_CHECKS=0;\n";
sql += "TRUNCATE TABLE product_images;\n";
sql += "TRUNCATE TABLE products;\n";
sql += "TRUNCATE TABLE categories;\n";
sql += "TRUNCATE TABLE users;\n";
sql += "TRUNCATE TABLE addresses;\n";
sql += "SET FOREIGN_KEY_CHECKS=1;\n\n";

// Users
sql += `INSERT INTO users (full_name, email, phone, password_hash, role, status) VALUES
('Admin Hệ Thống', 'admin@electroshop.com', '0901234567',
 '$2b$10$X8PaFcSZ5hdEBDzarAkXp.K5Ydz5edxh85hL2amGcDaXPXkMLEXK.', 'admin', 'active'),
('Nguyễn Văn An', 'an@example.com', '0912345678',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active'),
('Trần Thị Bình', 'binh@example.com', '0923456789',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active');\n\n`;

// Addresses
sql += `INSERT INTO addresses (user_id, recipient_name, phone, province, district, ward, address_line, is_default) VALUES
(2, 'Nguyễn Văn An', '0912345678', 'TP. Hồ Chí Minh', 'Quận 1', 'Phường Bến Nghé', '123 Lê Lợi', 1),
(3, 'Trần Thị Bình', '0923456789', 'Hà Nội', 'Quận Cầu Giấy', 'Phường Dịch Vọng', '456 Cầu Giấy', 1);\n\n`;

// Categories
const cats = [
  { id: 1, name: 'Máy lạnh', slug: 'may-lanh', desc: 'Máy lạnh các loại' },
  { id: 2, name: 'Máy giặt', slug: 'may-giat', desc: 'Máy giặt cửa trước, cửa trên' },
  { id: 3, name: 'Tivi', slug: 'tivi', desc: 'Smart TV, Android TV' },
  { id: 4, name: 'Điện thoại', slug: 'dien-thoai', desc: 'Điện thoại thông minh' },
  { id: 5, name: 'Laptop', slug: 'laptop', desc: 'Laptop gaming, văn phòng' },
  { id: 6, name: 'Tablet', slug: 'tablet', desc: 'Máy tính bảng' },
  { id: 7, name: 'Tủ lạnh', slug: 'tu-lanh', desc: 'Tủ lạnh Inverter' },
  { id: 8, name: 'Nồi cơm điện', slug: 'noi-com-dien', desc: 'Nồi cơm điện tử' },
  { id: 9, name: 'Nồi chiên không dầu', slug: 'noi-chien', desc: 'Air fryer' },
  { id: 10, name: 'Bếp điện', slug: 'bep-dien', desc: 'Bếp từ, bếp hồng ngoại' }
];

sql += "INSERT INTO categories (id, name, slug, description, status, sort_order) VALUES\n";
sql += cats.map((c, i) => `(${c.id}, '${c.name}', '${c.slug}', '${c.desc}', 'active', ${i + 1})`).join(',\n') + ';\n\n';

// Products
sql += "INSERT INTO products (id, category_id, name, slug, brand, sku, price, sale_price, stock_quantity, description, specifications, warranty_months, status) VALUES\n";
const pValues = [];
for (const [_, p] of products) {
  pValues.push(`(${p.id}, ${p.catId}, '${p.name}', '${p.slug}', '${p.brand}', 'SP${String(p.id).padStart(3, '0')}', ${p.price}, NULL, ${p.stock}, 'Mô tả sản phẩm ${p.name}', NULL, 12, 'active')`);
}
sql += pValues.join(',\n') + ';\n\n';

// Images (placeholder - will need actual download)
sql += "-- Images will be added after download from GitHub\n";
sql += "-- INSERT INTO product_images (product_id, image_url, is_main, sort_order) VALUES ...\n";

fs.writeFileSync('/mnt/c/Temp/seed_new.sql', sql);
console.log(`✓ Generated /mnt/c/Temp/seed_new.sql`);
console.log(`  - ${products.size} products`);
console.log(`  - ${cats.length} categories`);
