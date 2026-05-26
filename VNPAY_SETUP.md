# VNPay Sandbox Setup với Ngrok

## Bước 1: Đăng ký Ngrok (miễn phí)

1. Truy cập: https://dashboard.ngrok.com/signup
2. Đăng ký tài khoản miễn phí (có thể dùng Google/GitHub)
3. Sau khi đăng nhập, vào: https://dashboard.ngrok.com/get-started/your-authtoken
4. Copy authtoken (dạng: `2abc...xyz`)

## Bước 2: Thêm Ngrok Authtoken vào .env

Mở file `.env` và thêm dòng:

```bash
NGROK_AUTHTOKEN=YOUR_NGROK_AUTHTOKEN_HERE
```

Thay `YOUR_NGROK_AUTHTOKEN_HERE` bằng authtoken vừa copy.

## Bước 3: Khởi động lại Docker

```bash
docker compose down
docker compose up -d
```

## Bước 4: Lấy Ngrok Public URL

Đợi 5 giây để ngrok khởi động, sau đó chạy:

```bash
bash get-ngrok-url.sh
```

Hoặc:

```bash
curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | head -1 | cut -d'"' -f4
```

Kết quả sẽ là URL dạng: `https://abc123.ngrok-free.app`

## Bước 5: Test VNPay

1. Truy cập website qua ngrok URL hoặc localhost:3000
2. Đăng nhập (admin@test.com / admin123)
3. Thêm sản phẩm vào giỏ → Thanh toán
4. Chọn phương thức: VNPay
5. Nhập thông tin thẻ test:
   - Số thẻ: `9704198526191432198`
   - Tên: `NGUYEN VAN A`
   - Ngày hết hạn: `07/15`
   - OTP: `123456`

## Cách hoạt động

- App tự động lấy ngrok URL từ ngrok API (port 4040)
- Khi tạo VNPay payment URL, app dùng ngrok URL làm return URL
- VNPay redirect về: `https://abc123.ngrok-free.app/payment/vnpay/return`
- Ngrok forward request về Docker container
- App verify callback và update trạng thái đơn hàng

## Lưu ý

- Ngrok free tier: URL thay đổi mỗi lần restart
- URL có dạng: `https://random.ngrok-free.app`
- App tự động detect ngrok URL, không cần cập nhật .env mỗi lần
- Ngrok free có giới hạn 40 requests/phút (đủ test)

## Troubleshooting

### Ngrok container restart liên tục
```bash
docker logs electroshop_ngrok
```
Nếu thấy "authentication failed" → authtoken chưa đúng, check lại .env

### Không lấy được ngrok URL
```bash
curl http://localhost:4040/api/tunnels
```
Nếu connection refused → ngrok chưa khởi động xong, đợi thêm 5s

### VNPay vẫn báo "Không tìm thấy website"
- Check ngrok URL có accessible từ bên ngoài không: mở browser truy cập ngrok URL
- Nếu thấy "ngrok gateway" warning → click "Visit Site" → verify website load được
