#!/bin/bash

echo "=== VNPay Sandbox Setup với Ngrok ==="
echo ""

# Check if NGROK_AUTHTOKEN exists in .env
if ! grep -q "NGROK_AUTHTOKEN" .env 2>/dev/null; then
    echo "⚠️  Chưa có NGROK_AUTHTOKEN trong .env"
    echo ""
    echo "Bước 1: Đăng ký Ngrok miễn phí"
    echo "  → https://dashboard.ngrok.com/signup"
    echo ""
    echo "Bước 2: Lấy authtoken"
    echo "  → https://dashboard.ngrok.com/get-started/your-authtoken"
    echo ""
    read -p "Nhập ngrok authtoken: " AUTHTOKEN

    if [ -z "$AUTHTOKEN" ]; then
        echo "❌ Authtoken không được để trống"
        exit 1
    fi

    echo "" >> .env
    echo "# Ngrok for VNPay Sandbox" >> .env
    echo "NGROK_AUTHTOKEN=$AUTHTOKEN" >> .env
    echo "✅ Đã thêm NGROK_AUTHTOKEN vào .env"
    echo ""
fi

echo "Khởi động lại Docker containers..."
docker compose down
docker compose up -d

echo ""
echo "Đợi ngrok khởi động..."
sleep 8

echo ""
echo "Lấy ngrok public URL..."
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | head -1 | cut -d'"' -f4)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Không lấy được ngrok URL"
    echo "Check logs: docker logs electroshop_ngrok"
    exit 1
fi

echo ""
echo "✅ Setup hoàn tất!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Ngrok Public URL: $NGROK_URL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "VNPay callback URLs (tự động sử dụng):"
echo "  • Return: $NGROK_URL/payment/vnpay/return"
echo "  • IPN:    $NGROK_URL/payment/vnpay/ipn"
echo ""
echo "Truy cập website:"
echo "  • Local:  http://localhost:3000"
echo "  • Public: $NGROK_URL"
echo ""
echo "Test VNPay với thẻ sandbox:"
echo "  • Số thẻ: 9704198526191432198"
echo "  • Tên:    NGUYEN VAN A"
echo "  • Hạn:    07/15"
echo "  • OTP:    123456"
echo ""
