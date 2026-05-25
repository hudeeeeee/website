USE electronics_shop;

-- ============================================================
-- USERS (admin + 2 customers)
-- Admin password: Admin@123456
-- Customer password: Customer@123
-- ============================================================
INSERT INTO users (full_name, email, phone, password_hash, role, status) VALUES
('Admin Hệ Thống', 'admin@electroshop.com', '0901234567',
 '$2b$10$X8PaFcSZ5hdEBDzarAkXp.K5Ydz5edxh85hL2amGcDaXPXkMLEXK.', 'admin', 'active'),
('Nguyễn Văn An', 'an@example.com', '0912345678',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active'),
('Trần Thị Bình', 'binh@example.com', '0923456789',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active');

-- ============================================================
-- ADDRESSES
-- ============================================================
INSERT INTO addresses (user_id, recipient_name, phone, province, district, ward, address_line, is_default) VALUES
(2, 'Nguyễn Văn An', '0912345678', 'TP. Hồ Chí Minh', 'Quận 1', 'Phường Bến Nghé', '123 Lê Lợi', 1),
(3, 'Trần Thị Bình', '0923456789', 'Hà Nội', 'Quận Cầu Giấy', 'Phường Dịch Vọng', '456 Cầu Giấy', 1);

-- ============================================================
-- CATEGORIES (8 danh mục điện tử)
-- ============================================================
INSERT INTO categories (name, slug, description, status, sort_order) VALUES
('Điện thoại & Phụ kiện', 'dien-thoai-phu-kien', 'Smartphone, case, sạc, cáp', 'active', 1),
('Laptop & Máy tính bảng', 'laptop-may-tinh-bang', 'Laptop, tablet, máy tính xách tay', 'active', 2),
('Âm thanh & Tai nghe', 'am-thanh-tai-nghe', 'Tai nghe, loa bluetooth, soundbar', 'active', 3),
('TV & Màn hình', 'tv-man-hinh', 'Smart TV, màn hình máy tính, máy chiếu', 'active', 4),
('Gaming & Console', 'gaming-console', 'Console, tay cầm, gaming gear, PC gaming', 'active', 5),
('Thiết bị đeo thông minh', 'thiet-bi-deo-thong-minh', 'Smartwatch, vòng tay thông minh', 'active', 6),
('Máy ảnh & Quay phim', 'may-anh-quay-phim', 'Máy ảnh mirrorless, DSLR, action cam', 'active', 7),
('Thiết bị mạng & Lưu trữ', 'thiet-bi-mang-luu-tru', 'Router, switch, ổ cứng, USB', 'active', 8);

-- ============================================================
-- PRODUCTS (10 sản phẩm điện tử)
-- ============================================================
INSERT INTO products (category_id, name, slug, brand, sku, price, sale_price, stock_quantity, description, specifications, warranty_months, status)
VALUES
(1, 'Apple iPhone 15 Pro Max 256GB', 'apple-iphone-15-pro-max-256gb', 'Apple', 'SP001', 34990000, 32990000, 30,
 'Chip A17 Pro, màn hình Super Retina XDR 6.7", camera 48MP, Dynamic Island',
 '{"cpu":"A17 Pro","ram":"8GB","storage":"256GB","display":"6.7 inch OLED","camera":"48MP Main + 12MP Ultra-wide + 12MP Tele"}',
 12, 'active'),

(1, 'Samsung Galaxy S24 Ultra 512GB', 'samsung-galaxy-s24-ultra-512gb', 'Samsung', 'SP002', 31990000, NULL, 25,
 'Snapdragon 8 Gen 3, 6.8" Dynamic AMOLED 2X, 200MP, S Pen tích hợp',
 '{"cpu":"Snapdragon 8 Gen 3","ram":"12GB","storage":"512GB","display":"6.8 inch AMOLED 120Hz","camera":"200MP Main"}',
 12, 'active'),

(2, 'Apple MacBook Air 13 M2 8GB 256GB', 'apple-macbook-air-13-m2', 'Apple', 'SP003', 27990000, 25990000, 20,
 'Apple M2 chip, màn hình 13.6" Liquid Retina, thời lượng pin lên đến 18 giờ',
 '{"cpu":"Apple M2","ram":"8GB Unified Memory","storage":"256GB SSD","display":"13.6 inch Liquid Retina","battery":"18h"}',
 12, 'active'),

(2, 'ASUS ROG Strix G16 RTX 4060', 'asus-rog-strix-g16-rtx4060', 'ASUS', 'SP004', 32990000, 29990000, 15,
 'Intel Core i7-13650HX, RTX 4060 8GB GDDR6, 16GB DDR5, màn hình QHD 165Hz',
 '{"cpu":"Intel Core i7-13650HX","gpu":"RTX 4060 8GB","ram":"16GB DDR5","display":"16 inch QHD 165Hz"}',
 24, 'active'),

(3, 'Sony WH-1000XM5 Wireless Headphones', 'sony-wh-1000xm5', 'Sony', 'SP005', 8490000, 7490000, 40,
 'Chống ồn hàng đầu ANC, thời lượng pin 30h, LDAC Hi-Res Audio, kết nối multipoint',
 '{"type":"Over-ear","anc":"Adaptive ANC","battery":"30h","codec":"LDAC, AAC, SBC","multipoint":"Yes"}',
 12, 'active'),

(4, 'Samsung 55 inch Neo QLED 4K QN90C', 'samsung-55-neo-qled-4k-qn90c', 'Samsung', 'SP006', 22990000, 19990000, 10,
 'Neo QLED 4K, tần số quét 144Hz, Gaming Hub, Dolby Atmos, Object Tracking Sound',
 '{"size":"55 inch","resolution":"4K UHD","panel":"Neo QLED","refresh":"144Hz","hdr":"HDR10+"}',
 24, 'active'),

(5, 'Sony PlayStation 5 Slim Disc Edition', 'sony-ps5-slim-disc', 'Sony', 'SP007', 13990000, NULL, 12,
 'PS5 Slim với ổ đĩa, SSD tốc độ cao 1TB, hỗ trợ 120fps, ray tracing, DualSense',
 '{"storage":"1TB Custom SSD","fps":"120fps","features":"Ray Tracing, 3D Audio, DualSense Haptics"}',
 12, 'active'),

(6, 'Apple Watch Series 9 GPS 45mm', 'apple-watch-series-9-gps-45mm', 'Apple', 'SP008', 10990000, 9990000, 35,
 'Chip S9 SiP, màn hình Always-On Retina, đo SpO2, ECG, WatchOS 10',
 '{"chip":"S9 SiP","display":"45mm Always-On Retina","health":"SpO2, ECG, Crash Detection","battery":"18h"}',
 12, 'active'),

(7, 'Sony Alpha A7 IV Mirrorless Body', 'sony-alpha-a7-iv-body', 'Sony', 'SP009', 65990000, 61990000, 5,
 'Cảm biến Full-frame BSI CMOS 33MP, Eye AF thế hệ mới, quay 4K 60fps, IBIS 5.5 stops',
 '{"sensor":"33MP Full-frame BSI CMOS","autofocus":"Real-time Eye AF","video":"4K 60fps","stabilization":"5.5-stop IBIS"}',
 12, 'active'),

(8, 'TP-Link Deco XE75 WiFi 6E Mesh 2-pack', 'tp-link-deco-xe75-wifi6e-2pack', 'TP-Link', 'SP010', 5990000, 5490000, 20,
 'WiFi 6E Tri-band AXE5400, phủ sóng lên đến 557m², AI Mesh tự động tối ưu',
 '{"standard":"WiFi 6E (802.11ax)","speed":"5400Mbps Tri-band","coverage":"557m2","ports":"2.5G WAN + 1G LAN"}',
 24, 'active');

-- ============================================================
-- PRODUCT IMAGES (main image cho mỗi sản phẩm)
-- ============================================================
INSERT INTO product_images (product_id, image_url, is_main, sort_order) VALUES
(1, '/images/no-image.png', 1, 0),
(2, '/images/no-image.png', 1, 0),
(3, '/images/no-image.png', 1, 0),
(4, '/images/no-image.png', 1, 0),
(5, '/images/no-image.png', 1, 0),
(6, '/images/no-image.png', 1, 0),
(7, '/images/no-image.png', 1, 0),
(8, '/images/no-image.png', 1, 0),
(9, '/images/no-image.png', 1, 0),
(10, '/images/no-image.png', 1, 0);
