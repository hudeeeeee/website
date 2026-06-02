# ElectroShop — Nền Tảng Thương Mại Điện Tử

---

## 🤖 Toàn Bộ Codebase Được Viết Bởi AI Agent

> **Không có dòng code nào được viết tay.**
>
> Dự án này là kết quả của một thí nghiệm thực tế: thiết kế toàn bộ hệ thống e-commerce dưới dạng đặc tả kỹ thuật có cấu trúc, sau đó dùng **Claude Code (AI Agent)** để sinh ra toàn bộ codebase — từ schema database, business logic, đến UI templates và payment integration.
>
> **13 skill files** định nghĩa từng module cần build.  
> **10 hook scripts** tự động kiểm tra bảo mật, invariant nghiệp vụ, và chất lượng code trước/sau mỗi bước.  
> AI Agent chạy qua pipeline theo thứ tự cố định, không skip, không tự ý thêm gì ngoài spec.
>
> Repo đặc tả (skills + hooks + scraper): [`datn`](../datn)  
> Repo này (`website`): **output hoàn chỉnh sau khi AI Agent chạy xong** · [github.com/hudeeeeee/website](https://github.com/hudeeeeee/website)

---

## Tổng Quan

ElectroShop là nền tảng mua sắm điện tử full-stack phục vụ thị trường Việt Nam — điện thoại, laptop, máy tính bảng, gaming gear và phụ kiện. Xử lý toàn bộ vòng đời: tìm kiếm → giỏ hàng → đặt hàng → thanh toán → giao hàng → hậu mãi.

Tích hợp chatbot tư vấn sản phẩm chạy **Gemini 2.5 Flash** với RAG từ database thật.

**Dữ liệu sản phẩm là dữ liệu thật** — crawl trực tiếp từ cellphones.com.vn bằng Scrapy, không phải dữ liệu bịa đặt hay placeholder.

**Stack:** Node.js · Express · EJS · MySQL · Docker · Gemini AI · VNPay

---

## Chi Tiết: AI Agent Build Pipeline

### Cơ chế hoạt động

Quy trình build không phải "prompt → nhận code". Nó là một **pipeline có kỷ luật** gồm 3 thành phần:

```
┌─────────────────────────────────────────────────────────┐
│                   REPO ĐẶC TẢ (datn)                    │
│                                                         │
│  skills/skill-XX.md          hooks/hook-XX.sh           │
│  ─────────────────           ──────────────────         │
│  Đặc tả kỹ thuật:            Bash script kiểm tra:      │
│  • File cần tạo              • File có tồn tại không    │
│  • Code mẫu cho agent        • SQL injection            │
│  • Business rule cụ thể      • Plain password           │
│  • Acceptance criteria       • Missing middleware        │
│  • Edge case cần xử lý       • Transaction coverage     │
│                              • State machine hợp lệ     │
└────────────────────┬────────────────────────────────────┘
                     │ feed vào
                     ▼
          ┌─────────────────────┐
          │   Claude Code       │
          │   (AI Agent)        │
          │                     │
          │  Đọc skill file →   │
          │  Sinh code →        │
          │  Chạy hook →        │
          │  Sửa nếu fail →     │
          │  Sang skill tiếp    │
          └─────────────────────┘
                     │ output
                     ▼
          ┌─────────────────────┐
          │   REPO NÀY          │
          │   (website)         │
          │   Codebase hoàn     │
          │   chỉnh             │
          └─────────────────────┘
```

### Skill file là gì?

Mỗi skill file không phải mô tả mơ hồ — nó là **đặc tả kỹ thuật chính xác**. Ví dụ `skill-03-auth.md` chứa:

- Danh sách file cần tạo (`src/controllers/auth.controller.js`, `src/services/auth.service.js`...)
- Code mẫu cho từng hàm: `register()`, `login()` với logic validate đầy đủ
- Quy tắc cứng: không trả `password_hash` ra ngoài, bcrypt bắt buộc, email lowercase
- Acceptance criteria: đăng ký trùng email → lỗi cụ thể, tài khoản bị block → thông báo đúng

Agent đọc spec → sinh code → không cần "tự nghĩ" về cấu trúc hay business rule.

### Hook script là gì?

Mỗi hook là bash script chạy thực trên codebase sau khi agent viết xong. Ví dụ `hook-02-security.sh`:

```bash
# Kiểm tra SQL injection — tìm string concatenation trong query
SQLI=$(grep -rn "query\s*(\s*[\`'\"].*\+" src --include="*.js")
[ -n "$SQLI" ] && warn "Nối string trong SQL" || ok "Prepared statements OK"

# Kiểm tra plain password
grep -rn "INSERT.*password\b" src --include="*.js" | grep -v "hash\|bcrypt"
# → fail nếu tìm thấy

# Kiểm tra admin route có middleware chưa
grep -rn "requireAdmin" src/routes/admin.routes.js | wc -l
# → fail nếu = 0
```

`hook-10-qa.sh` (chạy sau mỗi skill) kiểm tra **60+ điều kiện**: từng route file có tồn tại không, từng controller có đúng tên không, transaction trong `order.service.js` có không, `.env` có trong `.gitignore` không, upload có `fileFilter` không...

**Nếu hook fail → agent bị chặn, phải sửa code, chạy lại hook cho đến khi pass — rồi mới được sang skill tiếp theo.**

### Thứ tự thực thi mỗi skill

```
hook-01-prebuild.sh          ← kiểm tra môi trường, cấu trúc thư mục, DB
        ↓ pass
Agent đọc skill-XX.md        ← sinh code theo spec
        ↓
hook-02-security.sh          ← quét SQL injection, XSS, hardcoded secret
hook-03-transaction.sh       ← kiểm tra transaction coverage
hook-05-order-state.sh       ← kiểm tra state machine đơn hàng (nếu liên quan)
hook-06-inventory.sh         ← kiểm tra stock không bao giờ âm
hook-10-qa.sh                ← QA tổng: route, controller, service, view, security
        ↓ tất cả pass
Chuyển sang skill tiếp theo
```

### 13 skills theo thứ tự

```
Skill 00 → Cài môi trường, packages, khởi tạo DB
Skill 01 → Scaffold dự án, cấu trúc MVC, EJS layout
Skill 02 → Schema 12 bảng + seed data
Skill 03 → Auth: đăng ký, đăng nhập, session, middleware
Skill 04 → Catalog: tìm kiếm fulltext, lọc, trang chi tiết
Skill 05 → Giỏ hàng CRUD + kiểm tra tồn kho
Skill 06 → Checkout, tạo đơn, lịch sử, hủy đơn
Skill 07 → Thanh toán: COD, chuyển khoản, VNPay
Skill 08 → Đánh giá có xác minh mua hàng
Skill 09 → Bảo hành: yêu cầu + quy trình admin
Skill 10 → Admin dashboard, quản lý sản phẩm/đơn/user
Skill 11 → UI/UX nhất quán, responsive, empty states
Skill 12 → Audit route, hoàn thiện endpoint
```

Mỗi hook chạy trước và sau mỗi skill — kiểm tra SQL injection, auth bypass, transaction coverage, state machine đơn hàng, invariant tồn kho, và QA checklist — **trước khi** bước tiếp theo bắt đầu.

---

## Pipeline Dữ Liệu Thật

```
cellphones.com.vn
       │
       ▼
  crawler.py          Scrapy spider
  ─────────────────────────────────────────────
  • Thu thập: /dien-thoai + /laptop
  • Mỗi sản phẩm: tên, brand, giá, giá KM, mô tả HTML đầy đủ,
    specs JSON (CPU/GPU/RAM/SSD/màn hình/cổng kết nối),
    ảnh (nhiều ảnh/sản phẩm), thời hạn bảo hành
  • Nhận diện brand qua alias: iPhone→Apple, Redmi→Xiaomi...
  • Chuẩn hóa dấu tiếng Việt khi tạo slug
  • Output: products_raw.json
       │
       ▼
  import_crawled.py   Transform + load
  ─────────────────────────────────────────────
  • Deduplicate slug với DB hiện tại
  • Bulk INSERT qua mysql CLI
  • Tái tạo database/seed.sql
  • Kết quả: 65 sản phẩm · 307 ảnh · 17.800+ dòng seed SQL
```

---

## Tính Năng

### Khách Hàng

| Nhóm | Chức năng |
|------|-----------|
| Tài khoản | Đăng ký, đăng nhập, cập nhật hồ sơ, đổi mật khẩu, quản lý địa chỉ giao hàng |
| Sản phẩm | Duyệt danh mục 2 cấp, tìm kiếm fulltext, lọc brand/giá/danh mục, xem chi tiết + ảnh |
| Mua hàng | Giỏ hàng, đặt hàng, chọn địa chỉ, theo dõi trạng thái, lịch sử mua |
| Thanh toán | COD · Chuyển khoản · VNPay (sandbox) |
| Hậu mãi | Gửi yêu cầu bảo hành, đánh giá + ảnh sản phẩm (chỉ sau khi đã mua) |
| Chatbot AI | Tư vấn sản phẩm realtime bằng Gemini 2.5 Flash |

### Chatbot AI — Huy Đạt

Chatbot tư vấn tích hợp **Gemini 2.5 Flash** với RAG đơn giản từ database:

- **Intent detection** (regex): tìm sản phẩm, lọc giá, theo danh mục, xếp hạng cao, rẻ nhất
- **Keyword extraction**: brand (Apple, Samsung, Sony...), giá tối đa (`dưới 10 triệu`), danh mục (`laptop`, `tai nghe`...)
- **Dynamic SQL**: query realtime từ DB dựa trên intent + keyword, inject kết quả vào system prompt
- **Conversation history**: giữ 10 lượt hội thoại gần nhất
- **Tính cách**: nhân vật "Huy Đạt" — tư vấn viên bựa, tự phong giỏi nhất, vẫn tư vấn đúng việc

### Admin

**Dashboard**
- Doanh thu tháng hiện tại + tổng tích lũy (chỉ tính đơn `completed` + `paid`)
- Biểu đồ doanh thu 12 tháng (line chart số đơn + doanh số)
- Biểu đồ 7 ngày gần nhất
- Thống kê đơn theo trạng thái
- Top 5 sản phẩm bán chạy
- Cảnh báo tồn kho thấp (`stock_quantity ≤ 5`)
- 10 đơn hàng mới nhất

**Quản lý sản phẩm**
- CRUD đầy đủ: tên, brand, SKU, danh mục, giá gốc/sale, tồn kho, mô tả, thông số, bảo hành
- Upload nhiều ảnh cùng lúc, tự chỉ định ảnh đại diện
- Slug tự động (slugify + timestamp tránh trùng)
- Lọc theo danh mục/trạng thái/keyword, phân trang 20/trang

**Quản lý đơn hàng**

Luồng trạng thái có kiểm soát:

```
pending → confirmed → processing → shipping → completed
   ↓           ↓            ↓           ↓
cancelled  cancelled   cancelled  cancelled
```

Xác nhận đơn: tự động trừ tồn kho, chuyển `out_of_stock` nếu hết.  
Hủy đơn: tự động hoàn lại tồn kho.

**Quản lý khác**
- Danh mục 2 cấp (self-referencing FK), ảnh + mô tả + thứ tự
- Block/unblock tài khoản user
- Tiếp nhận + cập nhật trạng thái bảo hành
- Duyệt/ẩn đánh giá kèm ảnh

---

## Kiến Trúc Kỹ Thuật

### Cấu trúc MVC

```
Request → routes → controllers → services → MySQL
                              ↘ middlewares
```

```
src/
├── config/       database pool
├── controllers/  xử lý request, gọi service
├── services/     business logic, query DB
├── middlewares/  auth, upload, error handler
├── routes/       định nghĩa endpoint
├── utils/        hash password, validate
└── views/        EJS templates
    ├── layouts/
    ├── pages/
    └── partials/
```

### Database — 12 Bảng

```
users ──────────────→ addresses
  │                → orders ──→ order_items ──→ products
  │                         └→ payments
  │                → carts ──→ cart_items ──→ products
  │                → reviews ──→ products
  └────────────────→ warranty_requests ──→ order_items

products ──→ categories  (cây 2 cấp, self-ref FK)
         └→ product_images
```

FULLTEXT index trên `products(name, description)` cho tìm kiếm nhanh.

### Bảo Mật

| Vấn đề | Giải pháp |
|--------|-----------|
| Mật khẩu | bcrypt, không bao giờ plaintext |
| SQL injection | Prepared statements toàn bộ |
| Atomic operations | Transaction khi tạo/hủy đơn + điều chỉnh kho |
| Phân quyền | `/admin/*` — `requireAdmin` middleware toàn bộ |
| Tài nguyên | User chỉ truy cập đơn/giỏ/review của chính mình |
| Tồn kho | `stock_quantity ≥ 0` — enforce ở cả DB lẫn app layer |
| Thanh toán | `payment_status = 'paid'` chỉ set sau xác minh callback |

### Infrastructure

- **Docker Compose**: 3 service — `db` (MySQL 8), `app` (Node.js), `ngrok` (tunnel public URL)
- **Ngrok**: expose localhost ra internet cho VNPay IPN callback

### Dependencies

| Package | Mục đích |
|---------|----------|
| `express` | HTTP framework |
| `ejs` | Template engine |
| `mysql2` | MySQL driver (promise API) |
| `express-session` | Session management |
| `bcrypt` | Hash mật khẩu |
| `multer` | Upload ảnh sản phẩm |
| `connect-flash` | Flash message |
| `slugify` | Tạo slug URL |
| `dotenv` | Đọc biến môi trường |

---

## Cài Đặt

**Yêu cầu:** Docker + Docker Compose

```bash
git clone https://github.com/hudeeeeee/website.git
cd website
cp .env.example .env
# Điền GEMINI_API_KEY, VNPAY_*, NGROK_AUTHTOKEN vào .env
./start.sh
```

App chạy tại: `http://localhost:3000`

### Biến môi trường

| Biến | Mô tả |
|------|-------|
| `DB_HOST` / `DB_PORT` / `DB_USER` / `DB_PASS` / `DB_NAME` | Kết nối MySQL |
| `SESSION_SECRET` | Secret key express-session |
| `GEMINI_API_KEY` | API key Google AI Studio |
| `VNPAY_TMN_CODE` | Mã merchant VNPay |
| `VNPAY_HASH_SECRET` | Secret hash VNPay |
| `VNPAY_URL` | URL cổng VNPay |
| `VNPAY_RETURN_URL` | URL redirect sau thanh toán |
| `VNPAY_IPN_URL` | URL nhận IPN (cần domain public — dùng ngrok) |
| `NGROK_AUTHTOKEN` | Token ngrok |
| `BANK_ACCOUNT_NUMBER` / `BANK_ACCOUNT_NAME` / `BANK_NAME` | Thông tin chuyển khoản |

### Chạy lại scraper (tùy chọn)

```bash
pip install scrapy
python ../datn/crawler.py           # output products_raw.json
python ../datn/import_crawled.py    # load vào DB + tái tạo seed.sql
```

---

## Tài Khoản Demo

| Role | Email | Mật khẩu |
|------|-------|----------|
| Admin | admin@electroshop.com | admin123 |
| Khách | customer@electroshop.com | customer123 |

---

## Quy Tắc Nghiệp Vụ

| Quy tắc | Giá trị |
|---------|---------|
| Miễn phí vận chuyển | ≥ 2.000.000đ |
| Phí vận chuyển mặc định | 50.000đ |
| Bảo hành mặc định | 12 tháng |
| Điều kiện đánh giá | Phải có đơn `completed` cho sản phẩm đó |
| Cửa sổ hủy đơn | Chỉ khi `pending` hoặc `confirmed` |
| Tồn kho thấp | Cảnh báo khi `stock_quantity ≤ 5` |

---

## Liên Hệ

hude · sonhai0803@gmail.com
