-- ElectroShop Database Schema
-- Chạy theo thứ tự để tránh lỗi FK

CREATE DATABASE IF NOT EXISTS electronics_shop
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE electronics_shop;

-- 1. users
CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(15),
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('customer','admin') NOT NULL DEFAULT 'customer',
  status ENUM('active','blocked') NOT NULL DEFAULT 'active',
  avatar_url VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- 2. addresses (FK -> users)
CREATE TABLE IF NOT EXISTS addresses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  recipient_name VARCHAR(100) NOT NULL,
  phone VARCHAR(15) NOT NULL,
  province VARCHAR(100) NOT NULL,
  district VARCHAR(100) NOT NULL,
  ward VARCHAR(100) NOT NULL,
  address_line VARCHAR(255) NOT NULL,
  is_default TINYINT(1) DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. categories (self-ref FK)
CREATE TABLE IF NOT EXISTS categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(120) NOT NULL UNIQUE,
  description TEXT,
  parent_id INT UNSIGNED,
  image_url VARCHAR(255),
  status ENUM('active','inactive') DEFAULT 'active',
  sort_order INT DEFAULT 0,
  FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- 4. products (FK -> categories)
CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED NOT NULL,
  name VARCHAR(200) NOT NULL,
  slug VARCHAR(220) NOT NULL UNIQUE,
  brand VARCHAR(100),
  sku VARCHAR(50) UNIQUE,
  price DECIMAL(15,0) NOT NULL,
  sale_price DECIMAL(15,0),
  stock_quantity INT NOT NULL DEFAULT 0,
  description MEDIUMTEXT,
  specifications TEXT,
  warranty_months INT DEFAULT 0,
  avg_rating DECIMAL(3,2) DEFAULT 0.00,
  review_count INT DEFAULT 0,
  status ENUM('active','inactive','out_of_stock') DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  INDEX idx_category (category_id),
  INDEX idx_status (status),
  INDEX idx_brand (brand),
  FULLTEXT INDEX ft_search (name, description)
);

-- 5. product_images (FK -> products)
CREATE TABLE IF NOT EXISTS product_images (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  product_id INT UNSIGNED NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  is_main TINYINT(1) DEFAULT 0,
  sort_order INT DEFAULT 0,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 6. carts (FK -> users)
CREATE TABLE IF NOT EXISTS carts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 7. cart_items (FK -> carts, products)
CREATE TABLE IF NOT EXISTS cart_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cart_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  price_at_time DECIMAL(15,0) NOT NULL,
  UNIQUE KEY uq_cart_product (cart_id, product_id),
  FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 8. orders (FK -> users)
CREATE TABLE IF NOT EXISTS orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  order_code VARCHAR(20) NOT NULL UNIQUE,
  subtotal DECIMAL(15,0) NOT NULL,
  shipping_fee DECIMAL(15,0) DEFAULT 0,
  discount_amount DECIMAL(15,0) DEFAULT 0,
  total_amount DECIMAL(15,0) NOT NULL,
  order_status ENUM('pending','confirmed','processing','shipping','completed','cancelled') DEFAULT 'pending',
  payment_status ENUM('unpaid','pending','paid','failed','refunded') DEFAULT 'unpaid',
  payment_method ENUM('cod','bank_transfer','vnpay','momo') NOT NULL DEFAULT 'cod',
  shipping_name VARCHAR(100) NOT NULL,
  shipping_phone VARCHAR(15) NOT NULL,
  shipping_address TEXT NOT NULL,
  note TEXT,
  cancelled_reason VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_order_status (order_status),
  INDEX idx_user_orders (user_id)
);

-- 9. order_items (FK -> orders, products)
CREATE TABLE IF NOT EXISTS order_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  product_name VARCHAR(200) NOT NULL,
  product_image VARCHAR(255),
  price DECIMAL(15,0) NOT NULL,
  quantity INT NOT NULL,
  total_price DECIMAL(15,0) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 10. payments (FK -> orders)
CREATE TABLE IF NOT EXISTS payments (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL UNIQUE,
  payment_method ENUM('cod','bank_transfer','vnpay','momo') NOT NULL,
  payment_status ENUM('unpaid','pending','paid','failed','refunded') DEFAULT 'unpaid',
  transaction_code VARCHAR(100),
  amount DECIMAL(15,0) NOT NULL,
  paid_at DATETIME,
  gateway_response TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 11. reviews (FK -> users, products, orders)
CREATE TABLE IF NOT EXISTS reviews (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  order_id INT UNSIGNED NOT NULL,
  rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  status ENUM('visible','hidden','pending') DEFAULT 'visible',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_product_order (user_id, product_id, order_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 12. warranty_requests (FK -> users, products, orders)
CREATE TABLE IF NOT EXISTS warranty_requests (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  order_id INT UNSIGNED NOT NULL,
  issue_description TEXT NOT NULL,
  status ENUM('pending','approved','rejected','processing','completed') DEFAULT 'pending',
  admin_note TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (order_id) REFERENCES orders(id)
);
