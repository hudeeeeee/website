SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE electronics_shop;

-- Cleanup
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE product_images;
TRUNCATE TABLE products;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;
TRUNCATE TABLE addresses;
SET FOREIGN_KEY_CHECKS=1;

-- Users
INSERT INTO users (full_name, email, phone, password_hash, role, status) VALUES
('Admin Hệ Thống', 'admin@electroshop.com', '0901234567',
 '$2b$10$X8PaFcSZ5hdEBDzarAkXp.K5Ydz5edxh85hL2amGcDaXPXkMLEXK.', 'admin', 'active'),
('Nguyễn Văn An', 'an@example.com', '0912345678',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active'),
('Trần Thị Bình', 'binh@example.com', '0923456789',
 '$2b$10$YnfDrc1yTTgFf.xoHRvnq.gfUprYgwHH0QnWJ4J6mYmfs2u2K3Wd2', 'customer', 'active');

-- Addresses
INSERT INTO addresses (user_id, recipient_name, phone, province, district, ward, address_line, is_default) VALUES
(2, 'Nguyễn Văn An', '0912345678', 'TP. Hồ Chí Minh', 'Quận 1', 'Phường Bến Nghé', '123 Lê Lợi', 1),
(3, 'Trần Thị Bình', '0923456789', 'Hà Nội', 'Quận Cầu Giấy', 'Phường Dịch Vọng', '456 Cầu Giấy', 1);

-- Categories
INSERT INTO categories (id, name, slug, description, status, sort_order) VALUES
(1, 'Máy lạnh', 'may-lanh', 'Máy lạnh các loại', 'active', 1),
(2, 'Máy giặt', 'may-giat', 'Máy giặt cửa trước, cửa trên', 'active', 2),
(3, 'Tivi', 'tivi', 'Smart TV, Android TV', 'active', 3),
(4, 'Điện thoại', 'dien-thoai', 'Điện thoại thông minh', 'active', 4),
(5, 'Laptop', 'laptop', 'Laptop gaming, văn phòng', 'active', 5),
(6, 'Tablet', 'tablet', 'Máy tính bảng', 'active', 6),
(7, 'Tủ lạnh', 'tu-lanh', 'Tủ lạnh Inverter', 'active', 7),
(8, 'Nồi cơm điện', 'noi-com-dien', 'Nồi cơm điện tử', 'active', 8),
(9, 'Nồi chiên không dầu', 'noi-chien', 'Air fryer', 'active', 9),
(10, 'Bếp điện', 'bep-dien', 'Bếp từ, bếp hồng ngoại', 'active', 10);

-- Products
INSERT INTO products (id, category_id, name, slug, brand, sku, price, sale_price, stock_quantity, description, specifications, warranty_months, status) VALUES
(2, 1, 'Máy lạnh TCL Inverter TAC-13CSD/XAB1I', 'may-lanh-tcl-inverter-tac-13csd-xab1i', '1.5', 'SP002', 6990000, NULL, 200, '<p><strong><em>Máy lạnh TCL Inverter 2 HP\n    TAC-18CSD/XAB1I&nbsp;</em></strong><em><strong>được trang bị nhiều tính năng như bộ lọc HD hạn chế\nvi khuẩn, hạt, mùi và bụi</strong></em><em><strong>. Trang bị công nghệ Eco và AI Inverter&nbsp;giúp tiết\nkiệm điện năng hiệu quả,&nbsp;</strong></em><em><strong>chuẩn năng lượng&nbsp;5 sao (hiệu suất năng lượng4.64). Ngoài ra còn đa dạng các tiện ích khác như kiểm soát độ ẩm, cảm biến nhiệt I Feel,...</strong></em>\n</p>\n<h3>Thiết kế</h3>\n<p><strong>Dàn lạnh:</strong></p>\n<p>- Máy lạnh sở hữu kiểu thiết kế hình hộp chữ nhật nằm ngang truyền thống với các đường nét được bo tròn tinh tế.</p>\n<p>-&nbsp;Tiện quan sát và điều chỉnh khi cần thiết với&nbsp;<strong>màn hình hiển thị nhiệt độ ngay trên dàn\nlạnh.</strong></p>\n<p><strong>Dàn nóng:</strong></p>\n<p>- Dàn nóng mang vẻ ngoài cứng cáp và thiết kế tối giản. Lớp vỏ máy được làm từ chất liệu dày dặn,&nbsp;<strong>chịu\nđược các điều kiện khắc nghiệt</strong>&nbsp;bên ngoài môi trường lắp đặt<stro', NULL, 12, 'active'),
(3, 1, 'Máy lạnh Funiki HIC09TMU.ST3', 'may-lanh-funiki-hic09tmu-st3', '1', 'SP003', 6690000, NULL, 100, '<p><em><strong>Máy lạnh Funiki 1HP HIC09TMU.ST3 sở hữu công nghệ Inverter\n    giúp tiết kiệm điện năng, chế độ làm lạnh nhanh Turbo giúp tăng tốc làm lạnh, người dùng sẽ không mất quá\n    nhiều thời gian để đạt được mức nhiệt độ mình mong muốn.</strong></em></p>\n<h3>Tổng quan thiết kế</h3>\n<p><strong>Dàn lạnh:&nbsp;</strong></p>\n<p>-<strong>&nbsp;</strong><strong>Máy lạnh Funiki </strong>1HP HIC09TMU.ST3&nbsp;có vỏ bằng nhựa với tông màu\ntrắng phù hợp với nhiều kiểu thiết kế không gian, từ phòng khách đến nhà bếp hay phòng ngủ.</p>\n<p>-&nbsp;Màn hình hiển thị nhiệt độ trên dàn lạnh dễ dàng quan sát.</p>\n<p><strong>Dàn nóng: </strong></p>\n<p>- Thiết kế hình chữ nhật, vỏ bằng thép chắc chắn.</p>\n<p>-<strong>&nbsp;</strong>Có ống dẫn gas được làm bằng đồng với lá tản nhiệt bằng nhôm có lớp bảo\nvệ&nbsp;<strong>Golden Fin</strong>&nbsp;độ bền cao tăng tuổi thọ của máy, chịu được điều kiện thời tiết khắc nghiệt\nnhư sương muối, gió biển hay mưa bão.&nbsp;</p>\n<p><a class="preventdefault"\nhref', NULL, 12, 'active'),
(4, 1, 'Máy lạnh Casper Inverter TC-09IS35', 'may-lanh-casper-inverter-tc-09is35', '1', 'SP004', 6990000, NULL, 200, '<p><strong><em>Máy lạnh Casper Inverter 1 HP TC-09IS35 cho\n    khả năng làm mát hiệu quả với chế độ làm lạnh nhanh Turbo, tự động điều chỉnh nhiệt độ với cảm biến nhiệt độ\n    iFeel, sử dụng tiết kiệm điện với công nghệ&nbsp;I-saving, tăng tuổi thọ thiết bị với chức năng tự làm sạch\n    iClean.</em></strong></p>\n<h3>Tổng quan thiết kế</h3>\n<p><strong>Dàn lạnh</strong></p>\n<p>-&nbsp;Casper TC-09IS35 thiết kế bo cạnh viền, tông màu trắng thanh lịch cho tổng thể thiết kế sang trọng, tinh tế,\ntrang trí hài hòa với các món đồ nội thất khác trong gian phòng của bạn.&nbsp;</p>\n<p><strong>Dàn nóng</strong></p>\n<p>- Thiết kế hình khối đơn giản, chất liệu vỏ ngoài có độ bền chắc cao, giữ cho các linh kiện bên trong an toàn trước\ncác điều kiện thời tiết khắc nghiệt, duy trì hệ thống hoạt động&nbsp;hiệu quả trong thời gian dài.&nbsp;</p>\n<p>-&nbsp;Ống dẫn gas làm từ đồng, dàn tản nhiệt cũng bằng chất liệu đồng mạ vàng nhẹ bền, dễ dàng lắp đặt.<strong> Bề\nmặt dàn tản nhiệt được mạ vàng</strong> cho', NULL, 12, 'active'),
(5, 1, 'Máy lạnh Midea Inverter MSAGA-13CRDN8', 'may-lanh-midea-inverter-msaga-13crdn8', '1.5', 'SP005', 7990000, NULL, 100, '<p><em><strong>Máy lạnh Midea Inverter 1.5 HP MSAGA-13CRDN8 có khả năng làm lạnh nhanh nhờ công\n    nghệ</strong></em><i><strong> Boost&nbsp;</strong></i><em><strong>và cho hiệu quả tiết kiệm điện đáng kể\n    nhờ&nbsp;</strong></em><strong><i>Inverter Quattroi, Eco và Gear</i></strong><em><strong>. Hơn nữa, máy lạnh\n    còn có thể hút ẩm, thích hợp sử dụng trong những ngày trời ẩm ướt, mưa gió khó chịu.</strong></em></p>\n<h3>Thiết kế</h3>\n<p><strong>Dàn lạnh:</strong></p>\n<p>- <strong>Máy lạnh Midea Inverter 1.5 HP MSAGA-13CRDN8</strong> sở hữu <strong>gam màu trắng với chất liệu vỏ máy\nbằng nhựa cao cấp</strong>, có độ bền tốt.</p>\n<p>- Mặt trước dàn lạnh còn được <strong>thiết kế thêm màn hình hiển thị nhiệt độ</strong>, giúp người dùng quan sát\nnhanh chóng nhiệt độ của máy lạnh đang hoạt động.</p>\n<p><strong>Dàn nóng:</strong></p>\n<p>- Có kiểu <strong>hình hộp chữ nhật gọn gàng, màu trắng</strong> với phần vỏ máy cứng cáp.</p>\n<p>- Lá tản nhiệt bên trong dàn lạnh và dàn nóng làm <st', NULL, 12, 'active'),
(6, 2, 'Máy giặt Sharp ES-Y75HV-S', 'may-giat-sharp-es-y75hv-s', '7.5', 'SP006', 3790000, NULL, 100, '<p><i><strong>Máy giặt Sharp 7.5 kg ES-Y75HV-S có khối lượng giặt 7.5 kg phù hợp với gia đình có 2 - 3 thành viên, được\n    trang bị 4 chương trình giặt đáp ứng được nhu cầu giặt giũ cơ bản của gia đình.</strong></i></p>\n<h3>Tổng quan thiết kế</h3>\n<p>- Máy giặt có kiểu dáng máy giặt cửa trên - lồng đứng, gam màu xám dễ dàng kết hợp với nội thất trong gia đình.</p>\n<p>-&nbsp;Máy giặt Sharp&nbsp;có bảng điều\nkhiển <strong>tiếng Việt</strong>, nút nhấn điều khiển dễ dàng các chương trình giặt.</p>\n<p>- Nắp máy được làm bằng <strong>nhựa ABS</strong> chắc chắn, sử dụng bền lâu.</p>\n<p>- Lồng giặt được làm từ <strong>kim loại sơn tĩnh điện</strong> bền bỉ, an toàn và thân thiện với môi trường.</p>\n<p><a class="preventdefault"\nhref="https://cdn.tgdd.vn/Products/Images/1944/310181/sharp-75-kg-es-y75hv-s-120923-104430.jpg"\nonclick="return false;"><img alt="Máy giặt Sharp 7.5 Kg ES-Y75HV-S - Thiết kế"\n    src="https://cdn.tgdd.vn/Products/Images/1944/310181/sharp-75-kg-es-y75hv-s-120923-104430', NULL, 12, 'active'),
(7, 2, 'Máy giặt LG AI DD Inverter FV1410S4B', 'may-giat-lg-ai-dd-inverter-fv1410s4b', '10', 'SP007', 11590000, NULL, 100, '<p><strong><i>Máy giặt LG AI DD Inverter 10 kg FV1410S4B được tích hợp sẵn 14 chương trình giặt tiện lợi, công nghệ AI\n    DD chăm sóc thông minh giúp bảo vệ sợi vải, công nghệ giặt tiết kiệm TurboWash giặt sạch nhanh chóng, tiết\n    kiệm thời gian cùng công nghệ Inverter tiết kiệm điện năng, vận hành êm ái.</i></strong></p>\n<h3>Tổng quan thiết kế</h3>\n<p>- Kiểu dáng máy giặt cửa trước - lồng\nngang, với màu đen sang trọng kết hợp dễ dàng với nội thất trong nhà.</p>\n<p>- Máy giặt LG có bảng điều khiển <strong>song\nngữ Anh - Việt</strong>, núm xoay, nút nhấn, cảm ứng và có màn hình hiển thị giúp người dùng thuận tiện thao tác\nsử dụng.</p>\n<p>- Nắp máy giặt được làm bằng <strong>kính chịu lực</strong> dễ dàng vệ sinh và quan sát được bên trong.</p>\n<p>- Lồng giặt được làm từ <strong>thép không gỉ </strong>ngăn ngừa vi khuẩn có hại, giúp quần áo được sạch hơn, tăng độ\nbền cho máy giặt.</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/1944/310433/lg-fv1410s4b-17072', NULL, 12, 'active'),
(8, 2, 'Máy giặt LG AI DD Inverter \nFV1410S4P', 'may-giat-lg-ai-dd-inverter-nfv1410s4p', '10', 'SP008', 11490000, NULL, 100, '<h3 style="text-align: justify;">Thiết kế hiện đại, nhỏ gọn với gam màu tinh tế</h3>\n<p style="text-align: justify;">Máy giặt LG AI DD Inverter 10 kg FV1410S4P&nbsp;có kiểu dáng nhỏ gọn cùng tông màu tinh tế\n    phù hợp với mọi không gian nội thất của gia đình Việt.&nbsp;</p>\n<p style="text-align: justify;">Bảng điều khiển song ngữ Anh – Việt có nút xoay và màn hình LED hiển thị rõ ràng, giúp\n    người dùng dễ dàng thao tác và sử dụng.</p>\n<p style="text-align: justify;"><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/1944/255492/lg-inverter-10-kg-fv1410s4p-210322-034423.jpg"\n        onclick="return false;"><img\n            alt="Máy giặt LG Inverter 10 kg FV1410S4P - Thiết kế hiện đại, nhỏ gọn với gam màu tinh tế"\n            src="https://cdn.tgdd.vn/Products/Images/1944/255492/lg-inverter-10-kg-fv1410s4p-210322-034423.jpg"\n            title="Máy giặt LG Inverter 10 kg FV1410S4P - Thiết kế hiện đại, nhỏ gọn với gam màu tinh tế"></a></p>\n<p style="text-align:', NULL, 12, 'active'),
(9, 2, 'Máy giặt Whirlpool Inverter FWEB8002FW', 'may-giat-whirlpool-inverter-fweb8002fw', '8', 'SP009', 4990000, NULL, 100, '<p style="text-align: justify;"><strong><i>Máy giặt Whirlpool\n    FreshCare Inverter 8 kg FWEB8002FW</i></strong><em><strong><strong>&nbsp;</strong>sở hữu động cơ\ntruyền động gián tiếp với công nghệ Inverter giúp máy vận hành êm ái và tiết kiệm điện năng. Công nghệ cảm\nbiến thông minh 6th SENSE tự động điều chỉnh lượng nước giặt dựa trên khối lượng quần áo giúp tiết kiệm điện\nvà nước đến 45%.</strong></em></p>\n<h3 style="text-align: justify;">Tổng quan thiết kế</h3>\n<p style="text-align: justify;">- Kiểu dáng: máy giặt cửa trước – lồng ngang. Gam màu trắng tinh tế\nlàm nổi bật sự sang trọng cho không gian phòng giặt giũ.</p>\n<p style="text-align: justify;">- <strong>Bảng điều khiển cảm ứng Tiếng Anh</strong> cùng <strong>màn hình LED</strong>\nhiển thị thông số rõ ràng. Ngôn ngữ hiển thị của máy giặt Whirlpool là tiếng Anh, điều này đôi\nkhi sẽ gây bất tiện cho người sử dụng, đặc biệt là những người lớn tuổi trong nhà.&nbsp;</p>\n<p style="text-align: justify;">- Nắp máy màu đen được làm b', NULL, 12, 'active'),
(10, 2, 'Máy giặt Samsung Inverter WW10TP44DSB/SV', 'may-giat-samsung-inverter-ww10tp44dsb-sv', '10', 'SP010', 10890000, NULL, 100, '<h3>Phân tích độ bẩn, tối ưu chu trình giặt với công nghệ giặt thông minh AI Wash</h3>\n<p>Máy giặt Samsung Inverter 10kg WW10TP44DSB/SV\n    sử dụng công nghệ giặt thông minh AI Wash khi được trang bị 4 loại cảm biến bao gồm: <strong>độ bẩn</strong> và\n    <strong>khối lượng đồ</strong>, <strong>lượng nước, lượng nước giặt/xả</strong> nhờ đó tối ưu hóa được chu trình\n    giặt, giúp bạn không cần phải tính toán nhiều khi giặt nữa.\n</p>\n<p><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/1944/236508/samsung-10kg-ww10tp44dsb-sv-150823-050757.jpg"\n        onclick="return false;"><img alt="Máy giặt Samsung Inverter 10 kg WW10TP44DSB/SV - Công nghệ giặt AI Wash"\n            src="https://cdn.tgdd.vn/Products/Images/1944/236508/samsung-10kg-ww10tp44dsb-sv-150823-050757.jpg"\n            title="Máy giặt Samsung Inverter 10 kg WW10TP44DSB/SV - Công nghệ giặt AI Wash"></a></p>\n<h3>Ghi nhớ tự động, đề xuất chế độ giặt phù hợp nhờ bảng điều khiển thông minh AI Control</h3>\n', NULL, 12, 'active'),
(11, 3, 'Google Tivi TCL 4K 58P635 ', 'google-tivi-tcl-4k-58p635', '58', 'SP011', 7970000, NULL, 100, '<p style="text-align: justify;"><i><strong>Google Tivi TCL 4K 58 inch 58P635 sở hữu\n    thiết kế sang trọng, màn hình siêu mỏng kích thước 58 inch, độ phân giải 4K sắc nét, công nghệ HDR10 tối ưu\n    độ sáng, độ tương phản cho trải nghiệm xem phim tuyệt vời. Tích hợp hệ điều hành Google TV với giao diện\n    trực quan, dễ sử dụng cùng kho ứng dụng giải trí đa dạng, phong phú.&nbsp;</strong></i></p>\n<h3 style="text-align: justify;">Tổng quan thiết kế</h3>\n<p style="text-align: justify;">- Google Tivi TCL 58P635 có thiết kế liền mạch, kiểu dáng sang trọng, đường viền siêu\nmỏng. Màn hình kích thước 58 inch phù hợp cho phòng khách, phòng làm việc, phòng ngủ, phòng họp,…</p>\n<p style="text-align: justify;">- <strong>Chân đế chữ V úp ngược</strong> bằng nhựa cao cấp, được thiết kế gần 2 góc của\ntivi giúp giữ cân bằng cho sản phẩm giúp đặt để chắc chắn trên kệ tủ.&nbsp;</p>\n<p style="text-align: justify;"><a class="preventdefault"\nhref="https://cdn.tgdd.vn/Products/Images/1942/303927/google-ti', NULL, 12, 'active'),
(12, 3, 'Smart Tivi QLED 4K Samsung QA55Q65A', 'smart-tivi-qled-4k-samsung-qa55q65a', '55', 'SP012', 11990000, NULL, 100, '<p><strong>Lưu ý</strong></p>\n<p>- Khách hàng đang sử dụng sản phẩm TV Samsung có trợ lý ảo Google sẽ không thể tiếp tục sử dụng tính năng này từ ngày\n    01/03/2024.&nbsp;</p>\n<p>- Sản phẩm được trang bị trợ lý Bixby tiếng Việt sẽ được kích hoạt dự kiến tháng 03/2024.&nbsp;</p>\n<h3>Thiết kế thanh mảnh, màn hình tràn viền 4 cạnh ấn tượng</h3>\n<p>>Smart Tivi QLED 4K 55 inch Samsung QA55Q65A với thiết kế\n    với màn hình tràn viền 4 cạnh, cho người dùng trải nghiệm khung hình giải trí trên tivi chân thực như thực tế đang\n    xảy ra trước mắt.</p>\n<p>Tivi Samsung 55 inch có chân đế\n    được thiết kế gọn gàng, vững chắc. Mang lại sự thanh lịch, sang trọng cho chiếc tivi, phù hợp trưng bày ở phòng\n    khách, phòng ngủ,...</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/1942/235642/2.jpg" onclick="return false;"><img\n            alt="Thiết kế - Smart Tivi QLED 4K 55 inch Samsung QA55Q65A"\n            src="https://cdn.tgdd.vn/Products/Images/1942/235642/2.jpg"\n     ', NULL, 12, 'active'),
(13, 4, 'iPhone 15', 'iphone-15', 'Hồng', 'SP013', 22490000, NULL, 100, '<h3><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/42/299033/iphone-15-pro-131023-034959.jpg"\n    onclick="return false;"><img alt="iPhone 15 Pro Max Tổng quan"\n        src="https://cdn.tgdd.vn/Products/Images/42/299033/iphone-15-pro-131023-034959.jpg" style="font-size: 13px;"\n        title="iPhone 15 Pro Max Tổng quan"></a></h3>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/42/299033/iphone-15-pro-131023-035001.jpg"\n    onclick="return false;"><img alt="iPhone 15 Pro Max Thông số kỹ thuật và tính năng"\n        src="https://cdn.tgdd.vn/Products/Images/42/299033/iphone-15-pro-131023-035001.jpg"\n        title="iPhone 15 Pro Max Thông số kỹ thuật và tính năng"></a></p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/42/299033/iphone-15-pro-131023-035003.jpg"\n    onclick="return false;"><img alt="iPhone 15 Pro Max So sánh"\n        src="https://cdn.tgdd.vn/Products/Images/42/299033/iphone-15-pro-131023-035003.jpg"\n        ', NULL, 12, 'active'),
(14, 4, 'Điện thoại Xiaomi 13T 5G', 'dien-thoai-xiaomi-13t-5g', 'Xanh', 'SP014', 11990000, NULL, 100, '<p><strong>Tuần trước, thương hiệu phụ Redmi của Xiaomi đã tổ chức một sự kiện tại Trung Quốc để ra mắt các thiết bị Redmi. Giờ đây, công ty đã tổ chức một sự kiện toàn cầu để công bố các thiết bị dành cho thị trường quốc tế.&nbsp;</strong></p>\n\n<p>Xiaomi đã trình làng bộ đôi flagship cao cấp <a href="https://www.viettablet.com/xiaomi-13t" target="_blank">Xiaomi 13T</a> và <a href="https://www.viettablet.com/xiaomi-13t-pro" target="_blank">Xiaomi 13T Pro</a>. Chúng xuất hiện với tư cách là sản phẩm kế thừa cho Xiaomi 12T và Xiaomi 12T Pro năm ngoái. Đây cũng là 2 mẫu điện thoại tiếp theo tham gia vào dòng sản phẩm Xiaomi 13. Với Xiaomi 13T, hãng đã khéo léo chế tạo một chiếc điện thoại thông minh đạt được sự cân bằng hoàn hảo giữa sự sang trọng và hiệu năng hàng đầu, tự hào với camera vượt trội và thiết kế bên ngoài tuyệt vời. Vậy Xiaomi 13T có gì mà đỉnh vậy, cùng Viettablet đánh giá trong bài viết này nhé!</p>\n\n<p style="text-align: center;"><img alt="" src="https://cdn.viettablet.co', NULL, 12, 'active'),
(15, 5, 'Laptop Lenovo Ideapad 3 15ITL6 i3 1115G4 (82H803SGVN)', 'laptop-lenovo-ideapad-3-15itl6-i3-1115g4-82h803sgvn', 'Xám', 'SP015', 7990000, NULL, 100, '<h3>Khoác lên mình một thiết kế hiện đại, sang trọng cùng với khả năng chạy các tác vụ một cách&nbsp;mượt mà nhờ bộ xử\n    lý thế hệ 11. Laptop Lenovo Ideapad 3 15ITL6 i3 1115G4 (82H803SGVN) là một sự lựa chọn hoàn hảo dành cho học sinh, sinh viên và nhân\n    viên văn phòng.</h3>\n<p>• Mang phong cách hiện đại, tối giản với thiết kế <strong>vỏ nhựa</strong> cùng cân nặng <strong>1.65 kg</strong> và\n    dày khoảng <strong>19.9 mm</strong>&nbsp;đủ nhỏ gọn để bạn có thể dễ dàng bỏ vào balo mang đi khắp mọi nơi.</p>\n<p>• Laptop học tập - văn phòng&nbsp;với\n    tính năng<strong> bảo mật vân tay </strong>giúp&nbsp;bạn dễ dàng đăng nhập vào máy mà không cần nhập mật khẩu. Đồng\n    thời, <strong>công tắc khóa camera</strong> và <strong>TPM 2.0</strong> cung cấp những chức năng an ninh, bảo mật cơ\n    bản giúp bảo mật thông tin, hình ảnh một cách tốt hơn, tránh những phần mềm độc hại tấn công, sao chép thông tin.\n</p>\n<p>• Tuy nhiên một điều rất đáng tiếc ở chiếc laptop&nbsp;này là bàn phím khôn', NULL, 12, 'active'),
(16, 5, 'Laptop Acer Gaming Nitro 5 AN515 58 769J i7 12700H (NH.QFHSV.003)', 'laptop-acer-gaming-nitro-5-an515-58-769j-i7-12700h-nh-qfhsv-003', 'Đen', 'SP016', 25490000, NULL, 100, '<h3>Được xây dựng dựa trên tinh thần tạo ra những trải nghiệm gaming xuất sắc, laptop\n        Acer Gaming Nitro 5 AN515 58 769J i7 12700H (NH.QFHSV.003)&nbsp;luôn không ngừng khẳng định vị thế để trở\n    thành lựa chọn hàng đầu trong phân khúc. Với sự kết hợp của màn hình đẹp, sức mạnh và diện mạo mới, laptop sẵn sàng\n    đối mặt với mọi thách thức từ người dùng là game thủ đến nhà sáng tạo.</h3>\n<h3>Hiệu năng ấn tượng chinh phục các tựa game</h3>\n<p>Sức mạnh nội tại từ chip xử lý <strong>Intel Core i7 12700H </strong>với <strong>14 nhân</strong> và <strong>20\n        luồng</strong> có khả năng xử lý nhiều tác vụ đa nhiệm và ứng dụng nặng. Điều này rất hữu ích cho các công việc\n    đòi hỏi nhiều tài nguyên như chỉnh sửa video, thiết kế đồ họa, cho bạn thỏa sức chiến những trận đấu bom tấn AAA,\n    stream game, coding,...</p>\n<p>Card <strong>NVIDIA GeForce RTX 3050</strong> mang lại hiệu suất ấn tượng. Với dung lượng&nbsp;<strong>4 GB</strong>,\n    GPU cung cấp cho laptop khả năng xử lý', NULL, 12, 'active'),
(17, 6, 'iPad 9 WiFi 64GB', 'ipad-9-wifi-64gb', 'Bạc-64GB', 'SP017', 7990000, NULL, 100, '<h3>iPad 9 WiFi 64GB&nbsp;- sản phẩm thuộc phân khúc&nbsp;máy tính\n    bảng&nbsp;giá rẻ của Apple, sở hữu kiểu dáng đơn\ngiản, cấu hình mạnh mẽ cùng camera rõ nét, có thể thoải mái sử dụng trong thời gian dài và đây sẽ là lựa chọn phù\nhợp cho mọi đối tượng người dùng.&nbsp;</h3>\n<h3>Vẻ ngoài sang trọng, đẹp mắt</h3>\n<p>Sở hữu một thiết kế quen thuộc của dòng iPad 10.2 inch, vỏ máy làm từ aluminum có độ bền cao.&nbsp;Theo đó là 2 màu\nsắc cơ bản là xám và bạc để bạn có thể lựa chọn cho phù hợp với phong cách, cá tính của bạn.</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/522/247517/ipad-gen-9-2.jpg"\n    onclick="return false;"><img alt="Vỏ ngoài tối giản bền bỉ - iPad 9 WiFi 64GB "\n        src="https://cdn.tgdd.vn/Products/Images/522/247517/ipad-gen-9-2.jpg" \n        title="Vỏ ngoài tối giản bền bỉ - iPad 9 WiFi 64GB "></a></p>\n<p>Nút Home vẫn được giữ lại trên phiên bản này, cảm biến vân tay Touch ID được tích hợp ở phím Home giúp mở khóa thiết\nbị tiện lợi và', NULL, 12, 'active'),
(18, 6, 'iPad Air 5 M1 Wifi Cellular 64GB', 'ipad-air-5-m1-wifi-cellular-64gb', '256GB', 'SP018', 23390000, NULL, 100, '<h3>iPad Air 5 M1 Wifi Cellular 64GB ra mắt với một cấu hình “khủng\n    long” mang đến khả năng chiến tốt mọi tác vụ, bên cạnh đó đây còn là phiên bản được hỗ trợ kết nội mạng di động giúp\n    bạn có thể kết nối internet kể cả khi di chuyển ra bên ngoài vùng phủ sóng wifi.</h3>\n<h3>Thiết kế trẻ trung hiện đại</h3>\n<p>Được phủ lên mình một lớp áo làm từ hợp kim nhôm cao cấp cùng kiểu thiết kế vuông vức, giúp máy toát lên vẻ sang\n    trọng và cao cấp hơn, bên cạnh đó iPad Air 5 M1 còn được hoàn thiện mặt lưng nhám giúp hạn chế bám dấu vân tay và mồ\n    hôi trong quá trình sử dụng.</p>\n<p><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/522/274155/ipad-air-5-m1-wifi-cellular-64gb-290422-031628.jpg"\n        onclick="return false;"><img alt="Vẻ ngoài cao cấp - iPad Air 5 M1 Wifi Cellular 64GB"\n            src="https://cdn.tgdd.vn/Products/Images/522/274155/ipad-air-5-m1-wifi-cellular-64gb-290422-031628.jpg"\n            title="Vẻ ngoài cao cấp - iPad Air 5 M1 Wifi ', NULL, 12, 'active'),
(19, 7, 'Tủ lạnh Samsung Inverter RF48A4010M9/SV', 'tu-lanh-samsung-inverter-rf48a4010m9-sv', 'Xám', 'SP019', 17690000, NULL, 100, '<h3>Sử dụng 2 dàn lạnh độc lập Twin Cooling Plus giúp lạnh đồng đều</h3>\n<p>Tủ lạnh này sử dụng công nghệ hiện\n    đại nên trong quá trình hoạt động mọi ngóc ngách của tủ được làm lạnh nhanh chóng, nên thực phẩm được bảo quản tốt\n    hơn.</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/1943/236996/samsung-rf48a4010m9-sv1-1.jpg"\n        onclick="return false;"><img\n            alt="Tủ lạnh Samsung Inverter 488 lít RF48A4010M9/SV - 2 dàn lạnh độc lập Twin Cooling Plus"\n            src="https://cdn.tgdd.vn/Products/Images/1943/236996/samsung-rf48a4010m9-sv1-1.jpg" \n            title="Tủ lạnh Samsung Inverter 488 lít RF48A4010M9/SV - 2 dàn lạnh độc lập Twin Cooling Plus"></a></p>\n<h3>Thiết kế Multi Door hiện đại, có tiện ích lấy nước bên ngoài</h3>\n<p>Tủ lạnh Samsung Inverter 488 lít RF48A4010M9/SV được thiết kế với dạng Multi Door nhiều cửa nên có thể lấy thực phẩm ở những ngăn riêng tránh thất thoát hơi lạnh ra\n    ngoài.</p>\n<p><a class="preventdefault" href="', NULL, 12, 'active'),
(20, 7, 'Tủ lạnh Toshiba Inverter GR-RF610WE-PGV(22)-XK', 'tu-lanh-toshiba-inverter-gr-rf610we-pgv-22-xk', 'Đen', 'SP020', 19990000, NULL, 100, '<h3><a class="preventdefault"\n    href="https://cdn.tgdd.vn/Products/Images/1943/228369/toshiba-gr-rf610we-pgv-22-xk-060923-045316.jpg"\n    onclick="return false;"><img alt="Tủ lạnh Toshiba Inverter 511 lít Multi Door GR-RF610WE-PGV(22)-XK"\n        src="https://cdn.tgdd.vn/Products/Images/1943/228369/toshiba-gr-rf610we-pgv-22-xk-060923-045316.jpg"\n        title="Tủ lạnh Toshiba Inverter 511 lít Multi Door GR-RF610WE-PGV(22)-XK"></a>\n</h3>\n<p><em>Tủ lạnh Toshiba Inverter 511 lít Multi Door GR-RF610WE-PGV(22)-XK&nbsp;thiết kế tủ hiện đại với bề mặt gương sang\n    trọng cùng gam màu đen\n    ấn tượng, là điểm nhấn trong không gian sống của gia đình. Tủ lạnh trang bị công nghệ Dual Cooling hai dàn lạnh\n    độc lập làm lạnh hiệu quả cùng công nghệ Origin Inverter tiết kiệm điện năng, vận hành êm ái. Có ngăn cấp đông\n    linh hoạt Flexible Zone giúp điều chỉnh nhiệt độ phù hợp với nước uống, thực phẩm khô và rau củ, ngăn tăng cường\n    độ ẩm Moisture Zone giúp điều chỉnh độ ẩm thích hợp với c', NULL, 12, 'active'),
(21, 8, 'Nồi cơm điện tử Philips HD4515/55', 'noi-com-dien-tu-philips-hd4515-55', 'Trắng', 'SP021', 1485000, NULL, 100, '<p style="text-align: justify;"><i><strong>Nồi cơm điện\n    tử&nbsp;Philips 1.8 lít HD4515/55</strong></i><i><strong> sử dụng công nghệ nấu 3D nấu cơm chín đều\ntơi xốp, lòng nồi bằng hợp kim phủ 6 lớp đá Maifan (lớp tráng Bakuhanseki siêu bền), tích hợp nhiều chế độ\ncài sẵn tiện lợi,… giúp bạn trổ tài chế biến nhiều món ngon chỉ với 1 thiết bị.&nbsp;</strong></i></p>\n<h3 style="text-align: justify;">Công nghệ nấu, công suất - Dung tích</h3>\n<p style="text-align: justify;">- Công suất 790 - 940W kết hợp công nghệ nấu 3D cho ra cơm chín đều, hạt cơm tơi xốp,\ngiữ lại tối đa lượng dưỡng chất trong gạo.</p>\n<p style="text-align: justify;">-&nbsp;Dung tích 1.8\nlít, nấu được khoảng 8 - 10 cốc gạo, phù hợp sử dụng cho 4 - 6 người ăn.</p>\n<p style="text-align: justify;"><a class="preventdefault"\nhref="https://cdn.tgdd.vn/Products/Images/1922/299636/noi-com-dien-tu-philips-18-lit-hd4515-55-220823-042118.gif"\nonclick="return false;"><img alt="Nồi cơm điện tử Philips 1.8 lít HD4515/55 - Công nghệ ', NULL, 12, 'active'),
(22, 8, 'Nồi cơm điện nắp gài BlueStone 1.8 lít RCB-5520', 'noi-com-dien-nap-gai-bluestone-1-8-lit-rcb-5520', 'Vàng', 'SP022', 600000, NULL, 100, '<p><em><strong>Nồi cơm điện nắp gài BlueStone 1.8\n    lít RCB-5520</strong></em>&nbsp;<i><strong>trang bị công nghệ 1D nấu cơm chín nhanh, lòng\nnồi hợp kim nhôm phủ chống dính bền tốt, điều chỉnh bằng nút gạt dễ sử dụng,... là sản phẩm tiện lợi\nhỗ trợ chế biến những bữa cơm thơm ngon cho gia đình.</strong></i></p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/1922/189688/bluestone-rcb-5520-1a-1.jpg"\nonclick="return false;"><img alt="Nồi cơm điện nắp gài BlueStone 1.8 lít RCB-5520 - Tổng quan"\nsrc="https://cdn.tgdd.vn/Products/Images/1922/189688/bluestone-rcb-5520-1a-1.jpg"\n title="Nồi cơm điện nắp gài BlueStone 1.8 lít RCB-5520 - Tổng quan"></a></p>\n<h3>Công nghệ nấu, công suất - Dung tích</h3>\n<p>- Công suất 700W kết hợp công nghệ 1D giúp nấu cơm chín nhanh, rút ngắn\nthời gian nấu nướng cho người nội trợ.</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/1922/189688/bluestone-rcb-5520-2a.gif"\nonclick="return false;"><img alt="Nồi cơm đ', NULL, 12, 'active'),
(23, 9, 'Lò chiên không dầu Ferroli FAF-12M 12 lít', 'lo-chien-khong-dau-ferroli-faf-12m-12-lit', 'Đen', 'SP023', 1590000, NULL, 100, '<p><em><strong>Lò chiên không dầu&nbsp;</strong></em><i><strong>Ferroli FAF-12M 12 lít giúp bạn chiên lượng lớn thực\n    phẩm cùng lúc hoặc nướng gà nguyên con nhờ dung tích 12 lít, có nhiều phụ kiện đi kèm hỗ trợ bạn nấu nướng\n    thuận tiện, bảng điều khiển nút xoay đơn giản, dễ dàng điều chỉnh chức năng.</strong></i></p>\n<h3>Dung tích - Công suất&nbsp;</h3>\n<p>- Thiết kế&nbsp;nồi chiên không dầu&nbsp;kết hợp lò nướng, dung tích 12 lít, chế biến được gà nguyên con khoảng 1.5\nkg.</p>\n<p>- Công suất hoạt động 1800W cho khả năng chiên nướng nhanh, rút ngắn thời gian chờ đợi.</p>\n<p><a class="preventdefault"\nhref="https://cdn.tgdd.vn/Products/Images/9418/309914/lo-chien-khong-dau-ferroli-faf-12m-12-lit-060923-055222.jpg"\nonclick="return false;"><img alt="Lò chiên không dầu Ferroli FAF-12M 12 lít - Dung tích "\n    src="https://cdn.tgdd.vn/Products/Images/9418/309914/lo-chien-khong-dau-ferroli-faf-12m-12-lit-060923-055222.jpg"\n    style="height: 436px; width: 780px;" title="Lò chiên không ', NULL, 12, 'active'),
(24, 9, 'Nồi chiên không dầu Kangaroo KG42AF1', 'noi-chien-khong-dau-kangaroo-kg42af1', 'Đen', 'SP024', 1290000, NULL, 100, '<h3>Nồi chiên không dầu\n    Kangaroo&nbsp;với vỏ nhựa dày bền cách nhiệt, dễ lau chùi, dung tích tổng 4 lít và dung tích sử dụng 3.5 lít\nphục vụ thoải mái cho gia đình 3 – 5 người ăn</h3>\n<p>Nồi với màu đen hiện đại và sang trọng, kiểu dáng mềm mại, gọn gàng dễ kết hợp trong nhiều không gian bếp.</p>\n<p><a class="preventdefault"\n    href="https://cdn.tgdd.vn/Products/Images/2063/217555/noi-chien-khong-dau-kangaroo-kg42af1-1-2.jpg"\n    onclick="return false;"><img alt="Thiết kế - Nồi chiên không dầu Kangaroo KG42AF1 4 lít"\n        src="https://cdn.tgdd.vn/Products/Images/2063/217555/noi-chien-khong-dau-kangaroo-kg42af1-1-2.jpg"\n        title="Thiết kế - Nồi chiên không dầu Kangaroo KG42AF1 4 lít"></a></p>\n<h3>Chiên nướng ngon không cần dùng dầu ăn, tiết giảm đến 80% lượng chất béo dư thừa an toàn hơn cho sức khỏe</h3>\n<p>Công suất hoạt động 1400W, làm nóng nhanh bằng thanh nhiệt, nồi có chế độ bảo vệ tự ngắt khi quá nhiệt tránh hư hại\ncho thiết bị và an toàn hơn cho người sử dụng.</p>\n<', NULL, 12, 'active'),
(25, 10, 'Bếp từ hồng ngoại lắp âm Pramie 2108', 'bep-tu-hong-ngoai-lap-am-pramie-2108', 'Bếp', 'SP025', 7390000, NULL, 100, 'NULL', NULL, 12, 'active'),
(26, 10, 'Bếp hồng ngoại 3 vùng nấu lắp âm Smeg SE363ETB ', 'bep-hong-ngoai-3-vung-nau-lap-am-smeg-se363etb', 'Đen', 'SP026', 23190000, NULL, 100, '<p><i><strong>Sản phẩm bếp hồng ngoại 3 vùng nấu lắp âm Smeg SE363ETB (536.64.101) chất lượng cao thương hiệu Smeg của\n    Ý, sản xuất tại Ý với thiết kế lắp âm sang trọng, cao cấp chuẩn Châu Âu, mang đến nét đẹp cho không gian bếp\n    hiện đại.</strong></i></p>\n<h3>Công suất - Kích thước vùng nấu</h3>\n<p>- Tổng công suất đạt 5700W, nấu ăn nhanh, tiết kiệm thời gian cho việc bếp núc.</p>\n<p>- Vùng nấu trái phía trên công suất 1200W, vùng nấu trái dưới 1800W, vùng nấu phải với 3 có 3 công suất\n1050/1950/2700W hoạt động mạnh mẽ.</p>\n<p>-&nbsp;Vùng nấu trái trên đường kính Ø14.8 cm, vùng nấu trái dưới&nbsp;Ø18.4 cm, vùng nấu phải có 3 vòng nhiệt đường\nkính lần lượt Ø15.0 - Ø21.6 - Ø28.8 cm cho phép sử dụng linh hoạt với nhiều cỡ nồi chảo vô cùng tiện lợi.</p>\n<p><a class="preventdefault"\nhref="https://cdn.tgdd.vn/Products/Images/3305/252499/smeg-se363etb-53664101-230322-045913.gif"\nonclick="return false;"><img alt="Công suất lớn, vùng nấu rộng rãi"\n    src="https://cdn.tgdd.vn/Products/Im', NULL, 12, 'active'),
(27, 6, 'Máy tính bảng Samsung Galaxy Tab A7 Lite', 'may-tinh-bang-samsung-galaxy-tab-a7-lite', 'Bạc', 'SP027', 3490000, NULL, 100, '<h3 style="text-align: justify;">Với mức giá hợp lý, Galaxy\n    Tab A7 Lite là mẫu máy tính bảng\nđược Samsung tạo ra nhằm hướng\nđến đối tượng người dùng đang tìm cho mình một thiết bị giải trí cơ bản với màn hình lớn, hỗ trợ đầy đủ kết nối để\ncó thể truy cập mạng nhanh mọi lúc mọi nơi.</h3>\n<h3 style="text-align: justify;">Chip 8 nhân cho trải nghiệm mượt mà</h3>\n<p style="text-align: justify;">Với vi xử lý MediaTek MT8768T 8 nhân xung nhịp tối đa đạt 2.3 GHz, có thể thấy Galaxy\nTab A7 Lite là một chiếc máy tính bảng hướng đến những nhu cầu giải trí cơ bản, mọi tác vụ như đọc báo, lướt\nFacebook hay chơi các tựa game nhẹ đều hoạt động khá tốt và ổn định.</p>\n<p style="text-align: justify;"><a class="preventdefault"\n    href="https://cdn.tgdd.vn/Products/Images/522/237325/samsung-galaxy-tab-a7-lite-09.jpg"\n    onclick="return false;"><img alt="Galaxy Tab A7 Lite | Trang bị con chip Helio P22T đến từ MediaTek"\n        src="https://cdn.tgdd.vn/Products/Images/522/237325/samsung-galaxy-tab-', NULL, 12, 'active'),
(28, 1, 'Máy lạnh Nagakawa Inverter 1.5 HP NIS-C12R2H10', 'may-lanh-nagakawa-inverter-1-5-hp-nis-c12r2h10', '1.5', 'SP028', 6990000, NULL, 120, '<h3>Diệt khuẩn, khử mùi nhờ chức năng tự làm sạch Auto Clean</h3>\n<p>Máy lạnh Nagakawa Inverter 1.5 HP NIS-C12R2H10 nhờ chức năng tự làm sạch Auto Clean sẽ loại bỏ vi khuẩn, nấm mốc hiệu\n    quả đến 99.9% và làm khô nước còn đọng lại ở dàn tản nhiệt.</p>\n<p>Chức năng tự làm sạch có tác dụng chính là làm sạch, môi trường sinh sôi của mầm bệnh bị triệt tiêu, tạo nên bầu\n    không khí trong lành. Đồng thời, nâng cao tuổi thọ sử dụng máy lạnh, tiết kiệm chi phí vệ sinh cho gia đình.</p>\n<p><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/2002/235745/Slider/nagakawa-nis-c12r2h10-040321-03011910.jpg"\n        onclick="return false;"><img alt="Máy lạnh Nagakawa Inverter 1.5 HP NIS-C12R2H10 - Tự làm sạch"\n            src="https://cdn.tgdd.vn/Products/Images/2002/235745/Slider/nagakawa-nis-c12r2h10-040321-03011910.jpg"></a>\n</p>\n<h3>Bầu không khí trong lành với hệ thống làm sạch không khí 5 lớp</h3>\n<p>Hệ thống làm sạch không khí với màng lọc 5 lớp, màng này có tác dụn', NULL, 12, 'active'),
(29, 1, 'Máy lạnh Samsung Inverter 1.5 HP AR13CYHAAWKNSV', 'may-lanh-samsung-inverter-1-5-hp-ar13cyhaawknsv', '1', 'SP029', 9090000, NULL, 50, '<p style="text-align: justify;"><em><strong>Máy lạnh Samsung Inverter 1.5 HP\n    AR13CYHAAWKNSV là dòng máy lạnh 1 chiều sở hữu công nghệ Digital Inverter Boost tiết kiệm điện năng,\nchế độ làm lạnh nhanh Fast Cooling, làm lạnh đều với tự động đảo gió 4 hướng. Bên cạnh đó, máy lạnh còn được\ntrang bị bộ lọc Copper Anti-bacteria Filter cho hiệu quả lọc sạch bụi bẩn, vi khuẩn tối ưu.</strong></em>\n</p>\n<h3 style="text-align: justify;">Tổng quan thiết kế</h3>\n<p style="text-align: justify;">- Máy lạnh Samsung này sở hữu lớp vỏ ngoài cứng cáp, gam màu trắng thanh\nnhã, đi kèm thiết kế với <strong>các cạnh được bo tròn nhẹ nhàng</strong>, phù hợp với nhiều không gian nội thất\nkhác nhau.&nbsp;</p>\n<p style="text-align: justify;">- <strong>Ống dẫn gas bằng đồng</strong> nguyên chất bền bỉ, khả năng chịu ăn mòn tốt,\nđồng thời truyền nhiệt nhanh, ổn định trong suốt quá trình máy hoạt động. Đi kèm theo đó là <strong>lá tản nhiệt\nbằng nhôm</strong> có kích thước gọn nhẹ, thuận tiện cho việc di chuyể', NULL, 12, 'active'),
(30, 3, 'Smart Tivi QLED 4K 75 inch Samsung QA75Q80C', 'smart-tivi-qled-4k-75-inch-samsung-qa75q80c', '75', 'SP030', 29290000, NULL, 10, '<p><strong><em>Smart Tivi QLED 4K 75 inch Samsung\n    QA75Q80C&nbsp;mang đến niềm tự hào cho gia chủ với thiết kế sang trọng, màn hình 75 inch hiển thị\nhình ảnh 4K sống động nhờ trang bị&nbsp;bộ xử lý Neural Quantum 4K AI 20 nơ-ron&nbsp;mạnh mẽ,&nbsp;công nghệ\nDirect Full Array 8X hiển thị hình ảnh chi tiết,&nbsp;Real Depth Enhancer tái tạo khung hình chuẩn như mắt\nnhìn, công nghệ Dolby Atmos, OTS Lite&nbsp;mang đến âm vòm theo dõi chuyển động hình ảnh cuốn hút, trợ lý ảo\nBixby cho bạn điều khiển tivi bằng khẩu lệnh dễ dàng.</em></strong></p>\n<h3>Tổng quan thiết kế</h3>\n<p>-&nbsp;Mẫu&nbsp;Smart tivi Samsung&nbsp;này có thiết kế\ntinh giản, kết cấu gọn gàng, đường viền thanh mảnh bao bọc và tăng cường bảo vệ màn hình. Chân đế được làm từ kim\nloại<strong>&nbsp;</strong>bền chắc, chống biến dạng, đặt&nbsp;tivi&nbsp;trên bàn, kệ tủ ổn định, không lo mất thăng\nbằng.&nbsp;</p>\n<p>-&nbsp;Màn\nhình 75 inch&nbsp;là lựa chọn phù hợp cho những không gian trưng bày có diện tích rộng rãi như phòng kh', NULL, 12, 'active'),
(32, 5, 'Laptop Apple MacBook Pro 14 inch M3 Max 2023 14-core CPU/36GB/1TB/30-core GPU ', 'laptop-apple-macbook-pro-14-inch-m3-max-2023-14-core-cpu-36gb-1tb-30-core-gpu', 'Đen', 'SP032', 79990000, NULL, 10, '<h3>MacBook Pro 14 inch M3 Max\n    2023 30-core GPU một sản phẩm đỉnh cao của laptop hiện đại, đang gây tiếng vang trong thế giới máy tính với\nhiệu năng và tích hợp tài nguyên không giới hạn. Với nhiều lõi CPU và GPU mạnh mẽ hơn bất kỳ sản phẩm nào, bộ nhớ\nthống nhất rộng lớn, chip M3 Max thách thức mọi giới hạn về hiệu suất và khả năng cho các nhiệm vụ đòi hỏi cao.</h3>\n<h3>Bùng nổ cùng hiệu năng mạnh mẽ</h3>\n<p>Nối đuôi sự thành công trước, hãng Apple đã cho ra con chip <strong>Apple M3 Max </strong>trong việc sử dụng tiến\ntrình sản xuất <strong>3 nm</strong> và <strong>92 tỷ bóng bán dẫn </strong>cho thấy sự đột phá về hiệu năng và hiệu\nquả trong công nghệ sản xuất. Sử dụng công nghệ sản xuất tiến tiến giúp M3 Max tăng hiệu năng mà không tăng tiêu thụ\nnăng lượng, điều này có lợi cho thời lượng pin và hiệu quả cho thiết bị.</p>\n<p><a class="preventdefault"\n    href="https://cdn.tgdd.vn/Products/Images/44/318232/apple-macbook-pro-14-inch-m3-max-2023-14-core-hinh-6.jpg"\n    onclick="re', NULL, 12, 'active'),
(33, 5, 'Laptop Apple MacBook Air 13 inch M1 2020 8-core CPU/8GB/256GB/7-core GPU (MGN63SA/A) ', 'laptop-apple-macbook-air-13-inch-m1-2020-8-core-cpu-8gb-256gb-7-core-gpu-mgn63sa-a', 'Xám', 'SP033', 19490000, NULL, 10, '<h3>MacBook Air M1 2020&nbsp;sở hữu\n    thiết kế sang trọng nhỏ gọn có thể dễ dàng mang theo bên mình. Cấu hình máy với hiệu năng xử lý nhanh, đạt hiệu quả\n    cao với chip Apple M1 mới, sẽ là trợ thủ đắc lực hỗ trợ bạn tốt trong mọi công việc.</h3>\n<h3>Hiệu năng xử lý tốt, thao tác mượt mà</h3>\n<p>Apple MacBook Air 2020 được trang bị chip&nbsp;Apple\n        M1 hiện đại với&nbsp;<strong>CPU 8 nhân</strong> gồm 4 nhân cho hiệu năng cao và 4 nhân tiết kiệm năng\n    lượng. Đây là vi xử lý chạy trên cấu trúc&nbsp;ARM cho hiệu năng xử lý nhanh hơn <strong>3,5 lần</strong> so với thế\n    hệ trước, pin dùng được lâu dài hơn lên đến 10 giờ đồng hồ.</p>\n<p><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/44/231244/apple-macbook-air-2020-mgn63saa-280323-125154.jpg"\n        onclick="return false;"><img alt="Apple MacBook Air M1 2020 - Làm việc với hình ảnh"\n            src="https://cdn.tgdd.vn/Products/Images/44/231244/apple-macbook-air-2020-mgn63saa-280323-125154.jpg"\n', NULL, 12, 'active'),
(34, 5, 'Laptop HP 15s fq5229TU i3 1215U/8GB/512GB/Win11 (8U237PA) ', 'laptop-hp-15s-fq5229tu-i3-1215u-8gb-512gb-win11-8u237pa', 'Xám', 'SP034', 10890000, NULL, 100, '<h3>Laptop HP 15s fq5229TU i3 1215U\n        (8U237PA) với thiết kế hiện đại, hiệu năng ổn định cùng mức giá phải chăng, chắc chắn sẽ trở thành người bạn\n    đồng hành đáng tin cậy cho sinh viên và người đi làm để hoàn thành một cách hiệu quả mọi công việc và giải trí hàng\n    ngày.</h3>\n<p>• Người dùng có thể soạn thảo văn bản, làm các trang tính phức tạp, tạo các bản trình chiếu trên Word, nhập liệu trên\n    Excel hay thiết kế hình ảnh đơn giản trên Canva,... cũng như xem phim giải trí và chơi game nhẹ với hiệu suất xử lý\n    tốt từ bộ vi xử lý&nbsp;<strong>Intel Core i3 Alder Lake - 1215U </strong>và card tích hợp&nbsp;<strong>Intel UHD\n        Graphics </strong>trên chiếc laptop học tập - văn phòng này.</p>\n<p>• Bộ nhớ <strong>RAM 8 GB</strong> cho khả năng đa nhiệm mượt mà, bạn sẽ không còn lo lắng về việc laptop bị lag hay đơ khi mở đồng thời nhiều tab công\n    việc hoặc chuyển đổi qua lại giữa các tác vụ khác nhau. Ngoài ra, RAM cũng có hỗ trợ nâng cấp lên đến <strong>16\n        ', NULL, 12, 'active'),
(35, 7, 'Tủ lạnh Samsung Inverter 256 lít RT25M4032BU/SV', 'tu-lanh-samsung-inverter-256-lit-rt25m4032bu-sv', '256', 'SP035', 7190000, NULL, 100, '<h3>Bảo quản thực phẩm tươi sống, sử dụng trong ngày không cần rã đông với ngăn đông mềm -1 độ C Optimal Fresh Zone</h3>\n<p>Tủ lạnh Samsung Inverter 256 lít\n        RT25M4032BU/SV&nbsp;được trang bị ngăn đông mềm -1 độ C Optimal Fresh Zone&nbsp;có tác dụng giữ thực phẩm\n    tươi sống còn trọn dưỡng chất, hoàn toàn không đông đá ở nhiệt độ đông mềm lý tưởng -1°C. Như thế, thịt cá hoàn toàn\n    không bị đông đá giúp bạn có thể nấu ăn ngay không cần rã đông, dễ dàng cắt thái và chế biến trong ngày.</p>\n<p>Lưu ý, chỉ nên sử dụng ngăn đông mềm này với các thực phẩm muốn chế biến trong ngày, nếu muốn trữ lâu hơn, bạn nên\n    dùng ngăn đông để bảo quản tốt nhất.</p>\n<p><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/1943/220326/samsung-rt25m4032bu-sv-240823-052850.jpg"\n        onclick="return false;"><img alt="Tủ lạnh Samsung Inverter 256 lít RT25M4032BU/SV - Ngăn đông mềm"\n            src="https://cdn.tgdd.vn/Products/Images/1943/220326/samsung-rt25m4032bu-sv-2408', NULL, 12, 'active'),
(36, 7, 'Tủ lạnh Sharp Inverter 401 lít Multi Door SJ-FXP480VG-CH', 'tu-lanh-sharp-inverter-401-lit-multi-door-sj-fxp480vg-ch', '401', 'SP036', 15680000, NULL, 10, '<h3>Loại bỏ mùi hôi và vi khuẩn nhờ công nghệ&nbsp;Plasmacluster Ion&nbsp;và&nbsp;bộ lọc với các phân tử Ag+Cu Nano&nbsp;</h3>\n<p>Plasmacluster Ion sẽ giải phóng các ion âm với mật độ cao và các ion này sẽ bám vào vi khuẩn, nấm mốc làm phá hủy cấu\n    trúc của chúng giúp loại bỏ vi khuẩn một cách hiệu quả.</p>\n<p>Bên cạnh đó chiếc tủ lạnh Sharp này còn được trang bị thêm bộ lọc với các phân tử Ag+Cu Nano giúp giữ lại các vi\n    khuẩn gây mùi có kích thước nhỏ giữ tủ lạnh luôn thoáng mát, sạch khuẩn an toàn cho sức khỏe.</p>\n<p><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/1943/230652/sharp-sj-fxp480vg-ch-240620-090605.jpg"\n        onclick="return false;"><img alt="Tủ lạnh Sharp Inverter 401 lít SJ-FXP480VG-CH - công nghệ plasmacluster"\n            src="https://cdn.tgdd.vn/Products/Images/1943/230652/sharp-sj-fxp480vg-ch-240620-090605.jpg"\n             title="Tủ lạnh Sharp Inverter 401 lít SJ-FXP480VG-CH - công nghệ plasmacluster"></a></p>\n<h3>Làm đông thực', NULL, 12, 'active'),
(37, 7, 'Tủ lạnh LG Inverter 519 lít Side By Side GR-B256BL', 'tu-lanh-lg-inverter-519-lit-side-by-side-gr-b256bl', '519', 'SP037', 13990000, NULL, 10, '<p><strong><em>Tủ lạnh LG Inverter 519 lít GR-B256BL</em></strong><em><strong>&nbsp;thuộc dòng tủ lạnh Side by side, có\n    sự kết hợp giữa&nbsp;Smart Inverter và Linear Inverter&nbsp;giúp vận hành êm ái, tiết kiệm điện năng. Bên\n    cạnh đó, công nghệ làm lạnh đa chiều mang hơi lạnh lan tỏa đều và&nbsp;bộ lọc khử mùi than hoạt tính loại bỏ\n    mùi hôi hiệu quả.</strong></em></p>\n<h3>Tổng quan thiết kế</h3>\n<p>- Thuộc dòng&nbsptủ lạnh Side by side, chất liệu cửa tủ được làm từ thép không\ngỉ bền đẹp với thời gian, màu đen sang trọng phù hợp với nhiều kiểu thiết kế nội thất.</p>\n<p>- Tay nắm cửa được thiết kế âm tinh tế giúp tổng thể gọn gàng, tối giản và hiện đại.</p>\n<p>- Không gian phù hợp nhất để đặt tủ là nhà bếp, tạo sự hiện đại và tiện nghi.</p>\n<p>- Dung tích<strong>&nbsp;519 lít&nbsp;</strong>thích hợp với gia đình&nbsp;từ 4 - 5 thành viên&nbsp;hoặc ít thành\nviên hơn nhưng nhu cầu trữ thực phẩm cao.</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/1943/', NULL, 12, 'active'),
(38, 9, 'Nồi chiên không dầu Sunhouse SHD4062 6 lít', 'noi-chien-khong-dau-sunhouse-shd4062-6-lit', '6', 'SP038', 1550000, NULL, 100, '<h3>Nồi chiên không dầu Sunhouse&nbsp;với dung tích sử dụng 5.5\n    lít có thể chiên gà vịt nguyên con khoảng 1.5 kg</h3>\n<p>Dung tích sử dụng lớn, phù hợp cho các gia đình đông người tầm 4 - 6 người thường xuyên nấu nướng, chế biến đa dạng\n    món ngon.&nbsp;</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/9418/258338/sunhouse-shd4062-55-lit-8a.jpg"\n        onclick="return false;"><img alt="Nồi chiên không dầu Sunhouse SHD4062 5.5 lít - Dung tích sử dụng"\n            src="https://cdn.tgdd.vn/Products/Images/9418/258338/sunhouse-shd4062-55-lit-8a.jpg"\n             title="Nồi chiên không dầu Sunhouse SHD4062 5.5 lít - Dung tích sử dụng"></a></p>\n<h3>Hoạt động mạnh mẽ với công suất 1600W, công nghệ Rapid Air&nbsp;giúp cho thức ăn chín nhanh, giòn bên ngoài, mềm bên\n    trong</h3>\n<p>Sử dụng nồi chiên không dầu giúp chiên nướng thực phẩm giảm đến 80% chất béo, bảo vệ sức khỏe gia đình.&nbsp;</p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Ima', NULL, 12, 'active'),
(39, 9, 'Nồi chiên không dầu Sunhouse SHD4035 9 lít', 'noi-chien-khong-dau-sunhouse-shd4035-9-lit', '9', 'SP039', 1780000, NULL, 20, '<p><em><strong>Nồi chiên không dầu\n</strong></em><strong><i>Sunhouse SHD4035 9 lít</i></strong>&nbsp;<em><strong>được trang bị công nghệ\nlàm nóng Rapid Air,</strong></em><i><strong><em><strong>&nbsp;</strong></em>công suất 1800W, dung tích sử\ndụng 9 lít, bảng điều khiển nút xoay dễ sử dụng, tự ngắt khi quá nhiệt, có quạt đối lưu,... là thiết bị hữu\ních giúp bạn chế biến nhiều món chiên rán hạn chế dầu mỡ cho gia đình.</strong></i></p>\n<p><a class="preventdefault" href="https://cdn.tgdd.vn/Products/Images/9418/275125/sunhouse-shd4035-9-lit-1a.jpg"\nonclick="return false;"><img alt="Nồi chiên không dầu Sunhouse SHD4035 - Tổng quan"\nsrc="https://cdn.tgdd.vn/Products/Images/9418/275125/sunhouse-shd4035-9-lit-1a.jpg" \ntitle="Nồi chiên không dầu Sunhouse SHD4035 - Tổng quan"></a></p>\n<h3>Dung tích - Công suất</h3>\n<p>- Dung tích tổng 9.5 lít, dung tích sử dụng 9 lít, chiên được gà nguyên con khoảng 1.5 kg.</p>\n<p>- Công suất 1800W giúp chiên nướng thực phẩm nhanh chóng, tiết kiệm tối đa thời ', NULL, 12, 'active'),
(40, 9, 'Nồi chiên không dầu BlueStone AFB-5878 5.5 lít ', 'noi-chien-khong-dau-bluestone-afb-5878-5-5-lit', '6.5', 'SP040', 1790000, NULL, 30, '<h3>Nồi chiên không dầu\n    BlueStone&nbsp;mang thiết kế hiện đại, sang trọng với kiểu dáng lạ mắt</h3>\n<p>Vỏ nhựa PP nhám bền bỉ, cách nhiệt và mặt trước viền inox sáng bóng, chống trầy tốt, mới lâu.</p>\n<p><a class="preventdefault"\n    href="https://cdn.tgdd.vn/Products/Images/9418/232457/bluestone-afb-5878-55-lit-044021-054006.jpg"\n    onclick="return false;"><img alt="Sang trọng - Nồi chiên không dầu Bluestone AFB-5878 5.5 lít"\n        src="https://cdn.tgdd.vn/Products/Images/9418/232457/bluestone-afb-5878-55-lit-044021-054006.jpg"\n         title="Sang trọng - Nồi chiên không dầu Bluestone AFB-5878 5.5 lít"></a></p>\n<h3>Dung tích tổng 6.5 lít,&nbsp;dung tích sử\n    dụng 5.5 lít có thể chiên nướng dễ dàng khoảng 2 - 3 miếng sườn 0.5 kg cùng lúc</h3>\n<p>Ngoài ra, bạn còn có thể dùng nồi chiên không dầu để chế biến các món như khoai tây chiên, gà rán, làm bánh… đa dạng\nbữa ăn gia đình.</p>\n<p><a class="preventdefault"\n    href="https://cdn.tgdd.vn/Products/Images/9418/232457/bluestone', NULL, 12, 'active'),
(41, 9, 'Nồi chiên không dầu Kangaroo KG52AF1A 5 lít', 'noi-chien-khong-dau-kangaroo-kg52af1a-5-lit', '5', 'SP041', 2086000, NULL, 40, '<h3>Nồi chiên không\n    dầu Kangaroo&nbsp;thiết kế hiện đại, gọn đẹp, tăng tính thẩm mỹ cho không gian bếp</h3>\n<p>Dung tích tổng 5 lít, dung tích sử dụng 4.5 lít, phục vụ tốt trong các gia đình có từ 4 - 6 thành viên.&nbsp;Có chân\nđế chống trượt bám chặt vào mặt bàn, kệ, đảm bảo nồi không bị nghiêng hay rung lắc, nấu ăn an toàn, hiệu quả.</p>\n<p><a class="preventdefault"\n    href="https://cdn.tgdd.vn/Products/Images/2063/217569/noi-chien-khong-dau-kangaroo-kg52af1a-1-1.jpg"\n    onclick="return false;"><img alt="Thiết kế hiện đại, gọn đẹp - Nồi chiên không dầu Kangaroo KG52AF1A 5 lít"\n        src="https://cdn.tgdd.vn/Products/Images/2063/217569/noi-chien-khong-dau-kangaroo-kg52af1a-1-1.jpg"\n         title="Thiết kế hiện đại, gọn đẹp - Nồi chiên không dầu Kangaroo KG52AF1A 5 lít"></a></p>\n<h3>Sử dụng chiên, nướng thực phẩm không cần dùng dầu nên giúp giảm dầu mỡ trong thực phẩm cho món ăn chín ngon, không\nngán</h3>\n<p>Công suất lớn 2000W kết hợp công nghệ làm nóng Rapid Air giúp làm thự', NULL, 12, 'active'),
(42, 9, 'Nồi chiên không dầu Hafele AF-T5A (535.43.712) 5 lít', 'noi-chien-khong-dau-hafele-af-t5a-535-43-712-5-lit', '5.5', 'SP042', 5590000, NULL, 44, '<h3 style="text-align: justify;">Nồi chiên không dầu Hafele&nbsp;thiết\n    kế trang nhã, sang trọng với vỏ nhựa - inox bóng đẹp, tăng tính thẩm mỹ cho mọi căn bếp gia đình</h3>\n<p>Dung tích sử dụng của nồi chiên&nbsp;5 lít&nbsp;có thể\n    nướng được 4 - 5 đùi gà cùng lúc.</p>\n<p><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/9418/233494/hafele-af-t5a-5-lit-090822-112311.jpg"\n        onclick="return false;"><img alt="Nồi chiên không dầu Hafele AF-T5A (535.43.712) - Dung tích sử dụng"\n            src="https://cdn.tgdd.vn/Products/Images/9418/233494/hafele-af-t5a-5-lit-090822-112311.jpg"\n            title="Nồi chiên không dầu Hafele AF-T5A (535.43.712) - Dung tích sử dụng"></a></p>\n<h3>Điều khiển&nbsp;cảm ứng&nbsp;có chỉ\n    dẫn rõ ràng với màn hình hiển thị rõ nét, dễ thao tác</h3>\n<p>Điều chỉnh nhiệt độ từ 80 - 200 độ C, hẹn giờ lên đến 60 phút.</p>\n<p>Giữ cho&nbsp;nồi chiên không dầu&nbsp;dùng bền lâu và đảm\n    bảo an toàn cho mọi người với tính năng tự độ', NULL, 12, 'active'),
(43, 2, 'Máy giặt Toshiba 7 Kg AW-L805AV', 'may-giat-toshiba-7-kg-aw-l805av', '12Kg', 'SP043', 11900000, NULL, 100, '<h3>\n    Thiết kế tối giản, sang trọng, hiện đại với khối lượng giặt 7 kg phù hợp cho\n    gia đình 2 - 3 người\n  </h3>\n  <p>Máy giặt Toshiba 7 Kg AW-L805AV (SG) &nbsp;có màu xám bạc\n    <strong>vừa toát lên vẻ sang trọng, hiện đại vừa đảm bảo vệ sinh</strong> hơn\n    trong quá trình sử dụng.&nbsp;\n  </p>\n  <p>\n    Với thiết kế&nbsp; cửa trên, lồng đứng và có&nbsp;<strong>khối lượng giặt là 7 kg</strong>&nbsp;này sẽ\n    phù hợp với những gia đình có&nbsp;<strong>2 - 3 thành viên</strong\n    >.&nbsp;Hoặc với gia đình có đông thành viên hơn nhưng nhu cầu giặt giũ ít thì\n    vẫn là lựa chọn phù hợp cho gia đình bạn.\n  </p>\n  <p>\n    <a\n      class="preventdefault"\n      href="https://cdn.tgdd.vn/Products/Images/1944/239156/toshiba-7-kg-aw-l805av-sg-150922-023646-1.jpg"\n      onclick="return false;"\n      ><img\n        alt="Máy giặt Toshiba 7 Kg AW-L805AV (SG) - Khối lượng 7 kg"\n        src="https://cdn.tgdd.vn/Products/Images/1944/239156/toshiba-7-kg-aw-l805av-sg-150922-023646-1.jpg"\n     ', NULL, 12, 'active'),
(44, 2, 'Máy giặt Aqua Inverter 8.5 kg AQD-A852J BK', 'may-giat-aqua-inverter-8-5-kg-aqd-a852j-bk', '10Kg', 'SP044', 8900000, NULL, 100, '<p>\n    <i\n      ><strong\n        >Máy giặt Aqua Inverter 8.5 kg AQD-A852J BK được thiết kế hiện đại theo\n        kiểu dáng máy giặt lồng ngang, lồng giặt lớn 525 mm nâng cao hiệu quả giặt\n        giũ, giảm xoắn rối áo quần.&nbsp;Công nghệ cân bằng AI DBT giúp máy vận\n        hành êm ái, ổn định.&nbsp;Truyền động gián tiếp dây curoa kết hợp cùng\n        động cơ Inverter giúp tiết kiệm điện năng tiêu thụ.</strong\n      ></i\n    >\n  </p>\n  <h3>Tổng quan thiết kế</h3>\n  <p>\n    - Kiểu dáng: Thiết kế dạng máy cửa trước - lồng ngang</strong>&nbsp;phong cách hiện đại,&nbsp;tông màu đen sang trọng, tạo điểm nhấn sang\n    trọng cho không gian sống của gia đình.&nbsp;\n  </p>\n  <p>\n    - <strong>Bảng điều khiển</strong>&nbsp;<strong>song ngữ Anh - Việt</strong\n    >&nbsp;kết hợp cùng núm xoay điều khiển cùng nút nhấn có màn hình hiển thị rõ\n    ràng, dễ hiểu giúp cho việc giặt giũ trở nên dễ dàng hơn.\n  </p>\n  <p>\n    - Nắp máy được làm bằng <strong>kính chịu lực</strong>&nbsp;với khả năng giảm\n', NULL, 12, 'active'),
(45, 4, 'Điện thoại OPPO A38', 'dien-thoai-oppo-a38', 'Vàng', 'SP045', 4900000, NULL, 100, '<h3 style="text-align: justify"> OPPO A38\n    tiếp tục là sản phẩm giá rẻ được OPPO mở bán chính hãng tại thị trường Việt\n    Nam. Máy được ra mắt vào tháng 09/2023 và gây ấn tượng bởi mức giá bán phải\n    chăng, cấu hình ổn cùng camera có độ phân giải tới 50 MP.\n  </h3>\n  <h3 style="text-align: justify">Thiết kế trẻ trung hiện đại</h3>\n  <p style="text-align: justify">\n    OPPO A38 là đại diện của sự tinh tế và hiện đại trong thiết kế di động. Với\n    dáng vẻ vuông vắn, góc cạnh sắc sảo, thiết bị này tạo nên cái nhìn sang trọng\n    và cực kỳ hợp xu hướng.&nbsp;\n  </p>\n  <p style="text-align: justify">\n    Thiết kế của OPPO A38 được cấu tạo từ các chất liệu như khung nhựa và mặt lưng\n    thủy tinh hữu cơ, kết hợp với kiểu hoàn thiện bề mặt nhám nhẹ giúp cho mặt\n    lưng của máy có khả năng hạn chế bám dấu vân tay và kháng xước tốt hơn so với\n    những kiểu nhẵn bóng thông thường.\n  </p>\n  <p style="text-align: justify">\n    <a\n      class="preventdefault"\n      href="https://cdn.tgdd.v', NULL, 12, 'active'),
(46, 4, 'Điện thoại vivo Y36 128GB', 'dien-thoai-vivo-y36-128gb', 'Xanh', 'SP046', 5690000, NULL, 100, '<h3 style="text-align: justify">\n    Vivo Y36 128GB\n     là một trong những lựa chọn đáng chú ý của thương hiệu vivo trong dòng sản\n     phẩm điện thoại thông minh. Với tính năng và cấu hình kỹ thuật ưu việt, vivo\n     Y36 128GB hứa hẹn sẽ mang đến cho người dùng trải nghiệm đỉnh cao và thú vị.\n   </h3>\n   <h3 style="text-align: justify">Hoàn thiện với các chất liệu cao cấp</h3>\n   <p style="text-align: justify">\n     Với thiết kế vuông vắn, vivo Y36 tạo nên một sự hài hòa tinh tế giữa vẻ cổ\n     điển và hiện đại. Góc cạnh được thiết kế tinh xảo, tạo nên một diện mạo mạnh\n     mẽ và chắc chắn cho chiếc điện thoại.\n   </p>\n   <p style="text-align: justify">\n     vivo Y36 được kết tinh từ sự kết hợp hoàn hảo giữa khung kim loại chắc chắn và\n     mặt lưng kính cứng cáp. Khung kim loại không chỉ tạo nên độ bền và đẳng cấp,\n     mà còn mang lại cảm giác chắc chắn khi cầm nắm. Mặt lưng kính không chỉ thể\n     hiện sự sang trọng mà còn tạo nên hiệu ứng ánh sáng độc đáo, khiến vivo Y36\n     tr', NULL, 12, 'active'),
(47, 4, 'Điện thoại realme C53 (6GB/128GB)', 'dien-thoai-realme-c53-6gb-128gb', 'Vàng', 'SP047', 3890000, NULL, 100, '<h3 style="text-align: justify">\n    Với sự phát triển không ngừng của công nghệ di động, việc tìm kiếm một chiếc\n    điện thoại phù hợp với nhu cầu của học sinh - sinh viên không còn là điều khó\n    khăn. Trong số các tùy chọn trên thị trường, realme C53\n    nổi lên như một tuyệt tác hoàn hảo, mang đến sự kết hợp lý tưởng giữa giá trị\n    và chất lượng.\n  </h3>\n  <h3 style="text-align: justify">Tạo hình vuông vắn, thiết kế sang trọng</h3>\n  <p style="text-align: justify">\n    realme C53 sở hữu một thiết kế vuông vắn, làm chủ yếu từ nhựa nên mang đến cảm\n    giác cầm nắm thoải mái nhờ khối lượng không quá lớn. Điện thoại có độ hoàn\n    thiện khá cao khi các chi tiết đều được hoàn thiện tỉ mỉ, cứng cáp, máy không\n    quá ọp ẹp nên vẫn mang đến trải nghiệm cầm nắm an tâm hơn, thoải mái hơn.\n  </p>\n  <p style="text-align: justify">\n    <a\n      class="preventdefault"\n      href="https://cdn.tgdd.vn/Products/Images/42/306785/realme-c53-6.jpg"\n      onclick="return false;"\n      ><img\n     ', NULL, 12, 'active'),
(48, 6, 'Samsung Galaxy Tab A9+ 5G', 'samsung-galaxy-tab-a9-5g', 'Xám', 'SP048', 6990000, NULL, 100, '\n<h3 style="text-align: justify"> Samsung Galaxy Tab A9+ 5G\n    là một lựa chọn tuyệt vời cho những người dùng đang tìm kiếm một máy tính bảng\n    giá cả phải chăng với màn hình rộng 11 inch, hiệu năng ổn định và khả năng kết\n    nối internet 5G.\n  </h3>\n  <h3 style="text-align: justify">Thiết kế vuông vức hiện đại</h3>\n  <p style="text-align: justify">\n    Sự tươi mới và tinh tế là những ấn tượng mà bất kỳ ai cũng có thể dễ dàng nhận\n    ra đầu tiên khi nhìn thấy Galaxy Tab A9+ 5G. Máy tính bảng có thiết kế hiện\n    đại và thanh lịch với mặt lưng phẳng và khung viền kim loại, giúp tạo nên vẻ\n    ngoài sang trọng, đẳng cấp.&nbsp;\n  </p>\n  <p style="text-align: justify">\n    Vỏ ngoài của máy được làm từ kim loại nguyên khối, mang lại sự cứng cáp và bền\n    bỉ. Chất liệu kim loại cũng giúp máy có khả năng chống trầy xước và chống va\n    đập tốt. Đặc biệt, bề mặt kim loại được xử lý nhám giúp tăng độ bám tay và hạn\n    chế trơn trượt. Hơn hết, cách làm này còn tạo nên điểm nhấn riêng biệt', NULL, 12, 'active'),
(49, 6, 'Xiaomi Redmi Pad SE 4GB', 'xiaomi-redmi-pad-se-4gb', 'Xanh', 'SP049', 4490000, NULL, 100, '\n<h3>Xiaomi Redmi Pad SE 4GB\n    nổi bật trong dòng máy tính bảng tầm trung với thiết kế tinh tế, pin lớn và\n    hiệu năng ấn tượng. Máy sở hữu một loạt tính năng nổi bật, làm cho nó trở\n    thành một lựa chọn hoàn hảo cho cả giải trí, công việc và học tập.\n  </h3>\n  <h3>Thiết kế thanh mảnh sang trọng</h3>\n  <p>\n    Xiaomi Redmi Pad SE nổi bật với thiết kế vuông vắn nhờ mặt lưng cùng bộ khung\n    được làm theo kiểu phẳng. Sự kết hợp này mang lại cho máy một vẻ ngoại hình\n    thời thượng và sang trọng. Thiết kế mỏng nhẹ cùng với sự tinh tế và thanh lịch\n    đã làm nên một chiếc máy tính bảng vượt trội về thẩm mỹ.\n  </p>\n  <p>\n    Mặt lưng và bộ khung của Xiaomi Redmi Pad SE được chế tạo liền mạch với nhau,\n    sử dụng chất liệu kim loại cao cấp. Điều này không chỉ tạo ra sự hài hòa tinh\n    tế trong thiết kế mà còn giúp máy trở nên cứng cáp và bền bỉ hơn. Khả năng kết\n    hợp chất liệu kim loại và thiết kế liền mạch mang đến một ngoại hình đẳng cấp,\n    làm cho Xiaomi Redmi Pad SE nổi b', NULL, 12, 'active'),
(50, 6, 'iPad Pro M2 12.9 inch WiFi 512GB', 'ipad-pro-m2-12-9-inch-wifi-512gb', 'Trắng', 'SP050', 36490000, NULL, 100, 'NULL', NULL, 12, 'active'),
(51, 6, 'Lenovo Tab M10 (Gen 3) 3GB/32GB', 'lenovo-tab-m10-gen-3-3gb-32gb', 'Xám', 'SP051', 3490000, NULL, 100, 'NULL', NULL, 12, 'active'),
(52, 8, 'Nồi cơm điện tử Sharp 1.8 lít KS-COM183MV-WH', 'noi-com-dien-tu-sharp-1-8-lit-ks-com183mv-wh', '1', 'SP052', 690000, NULL, 100, '\n<p>\n    <em><strong>Nồi cơm điện tử Sharp 1.8 lít KS-COM183MV-WH</strong></em\n    ><em\n      ><strong\n        ><strong\n          >&nbsp;với nhiều chế độ cài sẵn,&nbsp;công nghệ nhiệt 3D nấu cơm ngon,\n          hẹn giờ đến 24 giờ, bảng điều khiển tiếng Việt dễ hiểu,... là công cụ\n          đắc lực trong căn bếp gia đình.</strong\n        ></strong\n      ></em\n    >\n  </p>\n  <p>\n    <a\n      class="preventdefault"\n      href="https://cdn.tgdd.vn/Products/Images/1922/296809/noi-com-dien-tu-sharp-18-lit-ks-com183mv-wh-140323-043120.jpg"\n      onclick="return false;"\n      ><img\n        alt="Nồi cơm điện tử Sharp 1.8 lít KS-COM183MV-WH - Tổng quan"\n        src="https://cdn.tgdd.vn/Products/Images/1922/296809/noi-com-dien-tu-sharp-18-lit-ks-com183mv-wh-140323-043120.jpg"\n        title="Nồi cơm điện tử Sharp 1.8 lít KS-COM183MV-WH - Tổng quan"></a>\n  </p>\n  <h3>Công nghệ nấu, công suất - Dung tích</h3>\n  <p>\n    - Công suất 835W kết hợp&nbsp;công nghệ nấu 3D giúp nồi nấu cơm chín đều, tơi\n   ', NULL, 12, 'active'),
(53, 8, 'Nồi cơm điện tử Sharp 1.8 lít KS-COM194EV-BK', 'noi-com-dien-tu-sharp-1-8-lit-ks-com194ev-bk', '1.8', 'SP053', 1490000, NULL, 100, '\n<p>\n    <strong\n      ><i>\n      Nồi cơm điện tử Sharp 1.8 lít KS-COM194EV-BK &nbsp;có lòng nồi phủ lớp chống dính giúp nấu cơm ngon, giữ ấm tốt, đa\n        dạng chương trình cài sẵn với nhiều loại gạo khác nhau, giữ ấm đến 24 giờ\n        tiện lợi.</i\n      ></strong\n    >\n  </p>\n  <h3>Công nghệ nấu, công suất - Dung tích</h3>\n  <p>\n    - Công suất 790W cùng công nghệ nấu 3D với bộ gia nhiệt được lắp đặt phía\n    trên, mặt bên và phía dưới tạo ra năng lượng nhiệt mạnh mẽ, đảm bảo hương vị\n    thơm ngon trong từng hạt gạo.\n  </p>\n  <p>\n    -&nbsp; Dung tích 1.8 lít &nbsp;nấu được 8 - 10 cốc gạo đi kèm theo nồi, đáp ứng tốt khẩu phần ăn cho 4\n    - 6 người.\n  </p>\n  <p>\n    <a\n      class="preventdefault"\n      href="https://cdn.tgdd.vn/Products/Images/1922/311384/noi-com-dien-tu-sharp-18-lit-ks-com194ev-bk-201023-115017.gif"\n      onclick="return false;"\n      ><img\n        alt="Nồi cơm điện tử Sharp 1.8 lít KS-COM194EV-BK - Công nghệ "\n        src="https://cdn.tgdd.vn/Products/Images/', NULL, 12, 'active'),
(54, 8, 'Nồi cơm điện Toshiba', 'noi-com-dien-toshiba', '1.8', 'SP054', 2835000, NULL, 100, 'NULL', NULL, 12, 'active'),
(55, 10, 'Bếp điện từ đôi BlueStone ICB-6818', 'bep-dien-tu-doi-bluestone-icb-6818', 'Bếp', 'SP055', 2590000, NULL, 50, '\n<h3>\n    Bếp điện từ đôi BlueStone ICB-6818\n      lắp đặt âm sang trọng, gia tăng nét đẹp cho không gian đun nấu\n    </h3>\n    <p>Bếp từ\n      với tổng công suất 4000W nấu ăn cực nhanh chóng, 2 vùng nấu hỗ trợ đun nấu\n      tiện lợi hơn. Với tổng công suất này, bếp sử dụng điện nối qua aptomat (CB).\n    </p>\n    <p>\n      <a\n        class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/1982/203699/bep-dien-tu-doi-bluestone-icb-6818-9.jpg"\n        onclick="return false;"\n        ><img\n          alt="Sang trọng, tiện dụng - Bếp điện từ đôi Bluestone ICB-6818"\n          src="https://cdn.tgdd.vn/Products/Images/1982/203699/bep-dien-tu-doi-bluestone-icb-6818-9.jpg"\n          title="Sang trọng, tiện dụng - Bếp điện từ đôi Bluestone ICB-6818"></a>\n    </p>\n    <h3>\n      Mặt bếp bằng kính Ceramic chịu nhiệt cao cấp, chống trầy hiệu quả, sáng bóng\n      lâu, dễ chùi rửa, giữ bếp luôn mới\n    </h3>\n    <p>\n      <a\n        class="preventdefault"\n        href="https://cdn.tgd', NULL, 12, 'active'),
(56, 10, 'Bếp từ đôi lắp âm Hafele HC-I2712A (536.61.716)', 'bep-tu-doi-lap-am-hafele-hc-i2712a-536-61-716', 'Bếp', 'SP056', 7490000, NULL, 50, 'NULL', NULL, 12, 'active'),
(57, 10, 'Bếp từ hồng ngoại lắp âm Kangaroo KG852i', 'bep-tu-hong-ngoai-lap-am-kangaroo-kg852i', 'Bếp', 'SP057', 5190000, NULL, 50, '<h3>\n    Thiết kế 2 vùng nấu 2 món cùng lúc: 1 vùng, 1 vùng&nbsp;bếp từ\n    giúp tiết kiệm thời gian chế biến thực phẩm\n  </h3>\n  <p>\n    Vùng từ chỉ sử dụng nồi có đáy nhiễm từ chất liệu inox 430 và gang, vùng hồng\n    ngoại không kén nồi.\n  </p>\n  <p>\n    <a\n      class="preventdefault"\n      href="https://cdn.tgdd.vn/Products/Images/1982/252062/hong-ngoai-kangaroo-kg852i-200122-035454.jpg"\n      onclick="return false;"\n      ><img\n        alt="Thiết kế 2 vùng nấu"\n        src="https://cdn.tgdd.vn/Products/Images/1982/252062/hong-ngoai-kangaroo-kg852i-200122-035454.jpg"\n        title="Thiết kế 2 vùng nấu"></a>\n  </p>\n  <h3> Bếp từ&nbsp;hồng ngoại &nbsp;Kangaroo với tổng công suất 4000W khi mở hai bếp cùng lúc\n  </h3>\n  <p>\n    Vùng từ 2000W, đạt 2400W khi sử dụng Booster&nbsp; gia nhiệt nhanh, vùng hồng ngoại 2000W.\n  </p>\n  <p>\n    <a\n      class="preventdefault"\n      href="https://cdn.tgdd.vn/Products/Images/1982/252062/hong-ngoai-kangaroo-kg852i-200122-035546.jpg"\n      onclick="', NULL, 12, 'active'),
(58, 3, 'Smart Tivi NanoCell LG 4K 75 inch 75NANO76SQA ', 'smart-tivi-nanocell-lg-4k-75-inch-75nano76sqa', '75', 'SP058', 25890000, NULL, 100, '<p><em><strong>Smart Tivi NanoCell LG 4K 75 inch\n            75NANO76SQA thể hiện khung hình 4K rực rỡ với công nghệ NanoCell, cuốn hút người dùng từ âm thanh tinh chỉnh\n            theo nội dung, thỏa mãn nhu cầu giải trí cùng kho ứng dụng phong phú webOS 22, mang đến lựa chọn tuyệt vời\n            cho gia đình bạn.</strong></em></p>\n<h3>Tổng quan thiết kế</h3>\n<p >-&nbsp;Smart Tivi\n        NanoCell LG 4K 75 inch 75NANO76SQA phù hợp cho các phòng có diện tích trung bình lớn nhờ thiết kế thanh mảnh với\n        <strong>kích thước màn hình 75 inch</strong> cùng chân đế bán nguyệt có thể tháo rời, bố trí để\n        bàn hay treo tường linh hoạt.\n</p>\n<p >- Chân đế bằng <strong>chất liệu nhựa lõi kim loại</strong> độ\n    cứng chắc cao, nâng đỡ tốt màn hình, đảm bảo thẩm mỹ cho mọi không gian bố trí.</p>\n<p ><a class="preventdefault"\n        href="https://cdn.tgdd.vn/Products/Images/1942/278572/smart-nanocell-lg-4k-75-inch-75nano76sqa-1-1.jpg"\n        onclick="return false;"><img\n           ', NULL, 12, 'active');

-- Product Images
INSERT INTO product_images (product_id, image_url, is_main, sort_order) VALUES
(2, '/img/products/P2/P2_2.jpg', 1, 0),
(2, '/img/products/P2/P2_3.jpg', 0, 1),
(2, '/img/products/P2/P2_4.jpg', 0, 2),
(2, '/img/products/P2/P2_5.jpg', 0, 3),
(2, '/img/products/P2/P2_1.jpg', 0, 4),
(3, '/img/products/P3/P3_1.jpg', 1, 0),
(3, '/img/products/P3/P3_2.jpg', 0, 1),
(3, '/img/products/P3/P3_3.jpg', 0, 2),
(3, '/img/products/P3/P3_4.jpg', 0, 3),
(3, '/img/products/P3/P3_5.jpg', 0, 4),
(4, '/img/products/P4/P4_5.jpg', 1, 0),
(4, '/img/products/P4/P4_1.jpg', 0, 1),
(4, '/img/products/P4/P4_2.jpg', 0, 2),
(4, '/img/products/P4/P4_3.jpg', 0, 3),
(4, '/img/products/P4/P4_4.jpg', 0, 4),
(5, '/img/products/P5/P5_5.jpg', 1, 0),
(5, '/img/products/P5/P5_1.jpg', 0, 1),
(5, '/img/products/P5/P5_2.jpg', 0, 2),
(5, '/img/products/P5/P5_3.jpg', 0, 3),
(5, '/img/products/P5/P5_4.jpg', 0, 4),
(6, '/img/products/P6/P6_4.jpg', 1, 0),
(6, '/img/products/P6/P6_5.jpg', 0, 1),
(6, '/img/products/P6/P6_1.jpg', 0, 2),
(6, '/img/products/P6/P6_2.jpg', 0, 3),
(6, '/img/products/P6/P6_3.jpg', 0, 4),
(7, '/img/products/P7/P7_3.jpg', 1, 0),
(7, '/img/products/P7/P7_4.jpg', 0, 1),
(7, '/img/products/P7/P7_5.jpg', 0, 2),
(7, '/img/products/P7/P7_1.jpg', 0, 3),
(7, '/img/products/P7/P7_2.jpg', 0, 4),
(8, '/img/products/P8/P8_3.jpg', 1, 0),
(8, '/img/products/P8/P8_4.jpg', 0, 1),
(8, '/img/products/P8/P8_5.jpg', 0, 2),
(8, '/img/products/P8/P8_1.jpg', 0, 3),
(8, '/img/products/P8/P8_2.jpg', 0, 4),
(9, '/img/products/P9/P9_2.jpg', 1, 0),
(9, '/img/products/P9/P9_3.jpg', 0, 1),
(9, '/img/products/P9/P9_4.jpg', 0, 2),
(9, '/img/products/P9/P9_5.jpg', 0, 3),
(9, '/img/products/P9/P9_1.jpg', 0, 4),
(10, '/img/products/P10/P10_2.jpg', 1, 0),
(10, '/img/products/P10/P10_3.jpg', 0, 1),
(10, '/img/products/P10/P10_4.jpg', 0, 2),
(10, '/img/products/P10/P10_5.jpg', 0, 3),
(10, '/img/products/P10/P10_1.jpg', 0, 4),
(11, '/img/products/P11/P11_5.jpg', 1, 0),
(11, '/img/products/P11/P11_1.jpg', 0, 1),
(11, '/img/products/P11/P11_2.jpg', 0, 2),
(11, '/img/products/P11/P11_3.jpg', 0, 3),
(11, '/img/products/P11/P11_4.jpg', 0, 4),
(12, '/img/products/P12/P12_5.jpg', 1, 0),
(12, '/img/products/P12/P12_1.jpg', 0, 1),
(12, '/img/products/P12/P12_2.jpg', 0, 2),
(12, '/img/products/P12/P12_3.jpg', 0, 3),
(12, '/img/products/P12/P12_4.jpg', 0, 4),
(13, '/img/products/P13/P13_3.jpg', 1, 0),
(13, '/img/products/P13/P13_4.jpg', 0, 1),
(13, '/img/products/P13/P13_5.jpg', 0, 2),
(13, '/img/products/P13/P13_1.jpg', 0, 3),
(13, '/img/products/P13/P13_2.jpg', 0, 4),
(14, '/img/products/P14/P14_3.jpg', 1, 0),
(14, '/img/products/P14/P14_4.jpg', 0, 1),
(14, '/img/products/P14/P14_5.jpg', 0, 2),
(14, '/img/products/P14/P14_1.jpg', 0, 3),
(14, '/img/products/P14/P14_2.jpg', 0, 4),
(15, '/img/products/P15/P15_1.jpg', 1, 0),
(15, '/img/products/P15/P15_2.jpg', 0, 1),
(15, '/img/products/P15/P15_3.jpg', 0, 2),
(15, '/img/products/P15/P15_4.jpg', 0, 3),
(15, '/img/products/P15/P15_5.jpg', 0, 4),
(16, '/img/products/P16/P16_5.jpg', 1, 0),
(16, '/img/products/P16/P16_1.jpg', 0, 1),
(16, '/img/products/P16/P16_2.jpg', 0, 2),
(16, '/img/products/P16/P16_3.jpg', 0, 3),
(16, '/img/products/P16/P16_4.jpg', 0, 4),
(17, '/img/products/P17/P17_4.jpg', 1, 0),
(17, '/img/products/P17/P17_5.jpg', 0, 1),
(17, '/img/products/P17/P17_1.jpg', 0, 2),
(17, '/img/products/P17/P17_2.jpg', 0, 3),
(17, '/img/products/P17/P17_3.jpg', 0, 4),
(18, '/img/products/P18/P18_3.jpg', 1, 0),
(18, '/img/products/P18/P18_4.jpg', 0, 1),
(18, '/img/products/P18/P18_5.jpg', 0, 2),
(18, '/img/products/P18/P18_1.jpg', 0, 3),
(18, '/img/products/P18/P18_2.jpg', 0, 4),
(19, '/img/products/P19/P19_5.png', 1, 0),
(19, '/img/products/P19/P19_1.jpg', 0, 1),
(19, '/img/products/P19/P19_2.png', 0, 2),
(19, '/img/products/P19/P19_3.png', 0, 3),
(19, '/img/products/P19/P19_4.png', 0, 4),
(20, '/img/products/P20/P20_5.jpg', 1, 0),
(20, '/img/products/P20/P20_1.jpg', 0, 1),
(20, '/img/products/P20/P20_2.jpg', 0, 2),
(20, '/img/products/P20/P20_3.jpg', 0, 3),
(20, '/img/products/P20/P20_4.jpg', 0, 4),
(21, '/img/products/P21/P21_3.jpg', 1, 0),
(21, '/img/products/P21/P21_4.jpg', 0, 1),
(21, '/img/products/P21/P21_5.jpg', 0, 2),
(21, '/img/products/P21/P21_1.jpg', 0, 3),
(21, '/img/products/P21/P21_2.gif', 0, 4),
(22, '/img/products/P22/P22_3.jpg', 1, 0),
(22, '/img/products/P22/P22_4.jpg', 0, 1),
(22, '/img/products/P22/P22_5.jpg', 0, 2),
(22, '/img/products/P22/P22_1.jpg', 0, 3),
(22, '/img/products/P22/P22_2.gif', 0, 4),
(23, '/img/products/P23/P23_1.jpg', 1, 0),
(23, '/img/products/P23/P23_2.jpg', 0, 1),
(23, '/img/products/P23/P23_3.gif', 0, 2),
(23, '/img/products/P23/P23_4.jpg', 0, 3),
(23, '/img/products/P23/P23_5.jpg', 0, 4),
(24, '/img/products/P24/P24_5.jpg', 1, 0),
(24, '/img/products/P24/P24_1.jpg', 0, 1),
(24, '/img/products/P24/P24_2.jpg', 0, 2),
(24, '/img/products/P24/P24_3.jpg', 0, 3),
(24, '/img/products/P24/P24_4.jpg', 0, 4),
(25, '/img/products/P25/P25_3.jpg', 1, 0),
(25, '/img/products/P25/P25_4.jpg', 0, 1),
(25, '/img/products/P25/P25_5.jpg', 0, 2),
(25, '/img/products/P25/P25_1.jpg', 0, 3),
(25, '/img/products/P25/P25_2.jpg', 0, 4),
(26, '/img/products/P26/P26_2.gif', 1, 0),
(26, '/img/products/P26/P26_3.jpg', 0, 1),
(26, '/img/products/P26/P26_4.jpg', 0, 2),
(26, '/img/products/P26/P26_5.jpg', 0, 3),
(26, '/img/products/P26/P26_1.jpg', 0, 4),
(27, '/img/products/P27/P27_3.jpg', 1, 0),
(27, '/img/products/P27/P27_4.jpg', 0, 1),
(27, '/img/products/P27/P27_5.jpg', 0, 2),
(27, '/img/products/P27/P27_1.jpg', 0, 3),
(27, '/img/products/P27/P27_2.jpg', 0, 4),
(28, '/img/products/P28/P28_4.jpg', 1, 0),
(28, '/img/products/P28/P28_5.jpg', 0, 1),
(28, '/img/products/P28/P28_1.jpg', 0, 2),
(28, '/img/products/P28/P28_2.jpg', 0, 3),
(28, '/img/products/P28/P28_3.jpg', 0, 4),
(29, '/img/products/P29/P29_4.jpg', 1, 0),
(29, '/img/products/P29/P29_5.jpg', 0, 1),
(29, '/img/products/P29/P29_1.jpg', 0, 2),
(29, '/img/products/P29/P29_2.jpg', 0, 3),
(29, '/img/products/P29/P29_3.jpg', 0, 4),
(30, '/img/products/P30/P30_4.jpg', 1, 0),
(30, '/img/products/P30/P30_5.jpg', 0, 1),
(30, '/img/products/P30/P30_1.jpg', 0, 2),
(30, '/img/products/P30/P30_2.jpg', 0, 3),
(30, '/img/products/P30/P30_3.jpg', 0, 4),
(32, '/img/products/P32/P32_5.jpg', 1, 0),
(32, '/img/products/P32/P32_1.jpg', 0, 1),
(32, '/img/products/P32/P32_2.jpg', 0, 2),
(32, '/img/products/P32/P32_3.jpg', 0, 3),
(32, '/img/products/P32/P32_4.jpg', 0, 4),
(33, '/img/products/P33/P33_5.jpg', 1, 0),
(33, '/img/products/P33/P33_1.jpg', 0, 1),
(33, '/img/products/P33/P33_2.jpg', 0, 2),
(33, '/img/products/P33/P33_3.jpg', 0, 3),
(33, '/img/products/P33/P33_4.jpg', 0, 4),
(34, '/img/products/P34/P34_4.jpg', 1, 0),
(34, '/img/products/P34/P34_5.jpg', 0, 1),
(34, '/img/products/P34/P34_1.jpg', 0, 2),
(34, '/img/products/P34/P34_2.jpg', 0, 3),
(34, '/img/products/P34/P34_3.jpg', 0, 4),
(35, '/img/products/P35/P35_4.jpg', 1, 0),
(35, '/img/products/P35/P35_5.jpg', 0, 1),
(35, '/img/products/P35/P35_1.jpg', 0, 2),
(35, '/img/products/P35/P35_2.jpg', 0, 3),
(35, '/img/products/P35/P35_3.jpg', 0, 4),
(36, '/img/products/P36/P36_4.png', 1, 0),
(36, '/img/products/P36/P36_5.jpg', 0, 1),
(36, '/img/products/P36/P36_1.jpg', 0, 2),
(36, '/img/products/P36/P36_2.jpg', 0, 3),
(36, '/img/products/P36/P36_3.png', 0, 4),
(37, '/img/products/P37/P37_4.jpg', 1, 0),
(37, '/img/products/P37/P37_5.jpg', 0, 1),
(37, '/img/products/P37/P37_1.jpg', 0, 2),
(37, '/img/products/P37/P37_2.jpg', 0, 3),
(37, '/img/products/P37/P37_3.jpg', 0, 4),
(38, '/img/products/P38/P38_5.jpg', 1, 0),
(38, '/img/products/P38/P38_1.jpg', 0, 1),
(38, '/img/products/P38/P38_2.jpg', 0, 2),
(38, '/img/products/P38/P38_3.jpg', 0, 3),
(38, '/img/products/P38/P38_4.jpg', 0, 4),
(39, '/img/products/P39/P39_4.jpg', 1, 0),
(39, '/img/products/P39/P39_5.jpg', 0, 1),
(39, '/img/products/P39/P39_1.jpg', 0, 2),
(39, '/img/products/P39/P39_2.jpg', 0, 3),
(39, '/img/products/P39/P39_3.jpg', 0, 4),
(40, '/img/products/P40/P40_4.jpg', 1, 0),
(40, '/img/products/P40/P40_5.jpg', 0, 1),
(40, '/img/products/P40/P40_1.jpg', 0, 2),
(40, '/img/products/P40/P40_2.jpg', 0, 3),
(40, '/img/products/P40/P40_3.jpg', 0, 4),
(41, '/img/products/P41/P41_3.jpg', 1, 0),
(41, '/img/products/P41/P41_4.jpg', 0, 1),
(41, '/img/products/P41/P41_5.jpg', 0, 2),
(41, '/img/products/P41/P41_1.jpg', 0, 3),
(41, '/img/products/P41/P41_2.jpg', 0, 4),
(42, '/img/products/P42/P42_3.jpg', 1, 0),
(42, '/img/products/P42/P42_4.jpg', 0, 1),
(42, '/img/products/P42/P42_5.jpg', 0, 2),
(42, '/img/products/P42/P42_1.jpg', 0, 3),
(42, '/img/products/P42/P42_2.jpg', 0, 4),
(43, '/img/products/P43/P43_1.jpg', 1, 0),
(43, '/img/products/P43/P43_2.jpg', 0, 1),
(43, '/img/products/P43/P43_3.jpg', 0, 2),
(43, '/img/products/P43/P43_4.jpg', 0, 3),
(43, '/img/products/P43/P43_5.jpg', 0, 4),
(44, '/img/products/P44/P44_1.jpg', 1, 0),
(44, '/img/products/P44/P44_2.jpg', 0, 1),
(44, '/img/products/P44/P44_3.jpg', 0, 2),
(44, '/img/products/P44/P44_4.jpg', 0, 3),
(44, '/img/products/P44/P44_5.jpg', 0, 4),
(45, '/img/products/P45/P45_3.jpg', 1, 0),
(45, '/img/products/P45/P45_4.jpg', 0, 1),
(45, '/img/products/P45/P45_5.jpg', 0, 2),
(45, '/img/products/P45/P45_1.jpg', 0, 3),
(45, '/img/products/P45/P45_2.jpg', 0, 4),
(46, '/img/products/P46/P46_2.jpg', 1, 0),
(46, '/img/products/P46/P46_3.jpg', 0, 1),
(46, '/img/products/P46/P46_4.jpg', 0, 2),
(46, '/img/products/P46/P46_5.jpg', 0, 3),
(46, '/img/products/P46/P46_1.jpg', 0, 4),
(47, '/img/products/P47/P47_2.jpg', 1, 0),
(47, '/img/products/P47/P47_3.jpg', 0, 1),
(47, '/img/products/P47/P47_4.jpg', 0, 2),
(47, '/img/products/P47/P47_5.jpg', 0, 3),
(47, '/img/products/P47/P47_1.jpg', 0, 4),
(48, '/img/products/P48/P48_2.jpg', 1, 0),
(48, '/img/products/P48/P48_3.jpg', 0, 1),
(48, '/img/products/P48/P48_4.jpg', 0, 2),
(48, '/img/products/P48/P48_5.jpg', 0, 3),
(48, '/img/products/P48/P48_1.jpg', 0, 4),
(49, '/img/products/P49/P49_2.jpg', 1, 0),
(49, '/img/products/P49/P49_3.jpg', 0, 1),
(49, '/img/products/P49/P49_4.jpg', 0, 2),
(49, '/img/products/P49/P49_5.jpg', 0, 3),
(49, '/img/products/P49/P49_1.jpg', 0, 4),
(50, '/img/products/P50/P50_2.jpg', 1, 0),
(50, '/img/products/P50/P50_3.jpg', 0, 1),
(50, '/img/products/P50/P50_4.jpg', 0, 2),
(50, '/img/products/P50/P50_5.jpg', 0, 3),
(50, '/img/products/P50/P50_1.jpg', 0, 4),
(51, '/img/products/P51/P51_1.jpg', 1, 0),
(51, '/img/products/P51/P51_2.jpg', 0, 1),
(51, '/img/products/P51/P51_3.jpg', 0, 2),
(51, '/img/products/P51/P51_4.jpg', 0, 3),
(51, '/img/products/P51/P51_5.jpg', 0, 4),
(52, '/img/products/P52/P52_2.jpg', 1, 0),
(52, '/img/products/P52/P52_3.jpg', 0, 1),
(52, '/img/products/P52/P52_4.jpg', 0, 2),
(52, '/img/products/P52/P52_5.jpg', 0, 3),
(52, '/img/products/P52/P52_1.jpg', 0, 4),
(53, '/img/products/P53/P53_2.jpg', 1, 0),
(53, '/img/products/P53/P53_3.jpg', 0, 1),
(53, '/img/products/P53/P53_4.jpg', 0, 2),
(53, '/img/products/P53/P53_5.jpg', 0, 3),
(53, '/img/products/P53/P53_1.jpg', 0, 4),
(54, '/img/products/P54/P54_1.jpg', 1, 0),
(54, '/img/products/P54/P54_2.jpg', 0, 1),
(54, '/img/products/P54/P54_3.jpg', 0, 2),
(54, '/img/products/P54/P54_4.jpg', 0, 3),
(54, '/img/products/P54/P54_5.jpg', 0, 4),
(55, '/img/products/P55/P55_2.jpg', 1, 0),
(55, '/img/products/P55/P55_3.jpg', 0, 1),
(55, '/img/products/P55/P55_4.jpg', 0, 2),
(55, '/img/products/P55/P55_5.jpg', 0, 3),
(55, '/img/products/P55/P55_1.jpg', 0, 4),
(56, '/img/products/P56/P56_1.jpg', 1, 0),
(56, '/img/products/P56/P56_2.jpg', 0, 1),
(56, '/img/products/P56/P56_3.jpg', 0, 2),
(56, '/img/products/P56/P56_4.jpg', 0, 3),
(56, '/img/products/P56/P56_5.jpg', 0, 4),
(57, '/img/products/P57/P57_5.jpg', 1, 0),
(57, '/img/products/P57/P57_1.jpg', 0, 1),
(57, '/img/products/P57/P57_2.jpg', 0, 2),
(57, '/img/products/P57/P57_3.jpg', 0, 3),
(57, '/img/products/P57/P57_4.jpg', 0, 4),
(58, '/img/products/P58/P58_3.gif', 1, 0),
(58, '/img/products/P58/P58_4.jpg', 0, 1),
(58, '/img/products/P58/P58_5.gif', 0, 2),
(58, '/img/products/P58/P58_1.jpg', 0, 3),
(58, '/img/products/P58/P58_2.gif', 0, 4);
