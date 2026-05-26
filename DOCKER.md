# Docker Commands

## Push (từ máy dev)

```bash
# Login Docker Hub (1 lần duy nhất)
docker login

# Build & push
bash push-docker.sh
```

Hoặc manual:
```bash
docker build -t haiptjits/electroshop:latest .
docker push haiptjits/electroshop:latest
```

---

## Pull & Run (bất kỳ máy nào)

**1 lệnh duy nhất:**
```bash
docker compose -f docker-compose.prod.yml up -d
```

Docker tự động:
- Pull image từ Docker Hub
- Pull MySQL 8.0
- Tạo database + seed data
- Start app + ngrok

**Truy cập:** http://localhost:3000

**Login:** admin@test.com / admin123

---

## Lệnh thường dùng

```bash
# Stop
docker compose down

# Stop + xóa data
docker compose down -v

# Xem logs
docker logs electroshop_app
docker logs electroshop_db

# Rebuild local
docker compose up -d --build

# Restart 1 service
docker compose restart app
```

---

## VNPay với Ngrok

Tạo file `.env` với:
```
NGROK_AUTHTOKEN=your_token_here
```

Hoặc:
```bash
export NGROK_AUTHTOKEN=your_token_here
docker compose -f docker-compose.prod.yml up -d
```

Lấy ngrok URL:
```bash
curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | head -1 | cut -d'"' -f4
```
