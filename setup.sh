#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/hudeeeeee/website/main/docker-compose.pull.yml -o docker-compose.yml

echo "GEMINI_API_KEY=${GEMINI_API_KEY:-}" > .env

docker compose pull
docker compose up -d --force-recreate --remove-orphans

echo ""
echo "================================"
echo "ElectroShop đang chạy tại:"
echo "  http://localhost:3000"
echo ""
echo "Tài khoản demo:"
echo "  Admin : admin@electroshop.com / admin123"
echo "  Khách : customer@electroshop.com / customer123"
echo "================================"
