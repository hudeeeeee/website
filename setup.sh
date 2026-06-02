#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/hudeeeeee/website/main/docker-compose.pull.yml -o docker-compose.yml

if [ -z "$GEMINI_API_KEY" ]; then
  echo ""
  echo "⚠️  Chatbot AI sẽ không hoạt động nếu không có GEMINI_API_KEY."
  echo "   Lấy key tại: https://aistudio.google.com/apikey"
  echo "   Chạy lại với: GEMINI_API_KEY=your_key bash <(curl -fsSL ...)"
  echo ""
fi

docker compose pull
GEMINI_API_KEY="$GEMINI_API_KEY" docker compose up -d --force-recreate --remove-orphans

echo ""
echo "================================"
echo "ElectroShop đang chạy tại:"
echo "  http://localhost:3000"
echo ""
echo "Tài khoản demo:"
echo "  Admin : admin@electroshop.com / admin123"
echo "  Khách : customer@electroshop.com / customer123"
echo "================================"
