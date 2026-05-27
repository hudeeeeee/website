#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/hudeeeeee/website/main/docker-compose.pull.yml -o docker-compose.yml

export NGROK_AUTHTOKEN=2qcBujU5SFmJO2K2FsxgwlLJZZ3_7JXRGKYaSBuQVuwqScgun

docker compose pull
docker compose up -d

echo "Waiting for ngrok..."
for i in $(seq 1 20); do
  URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | python3 -c "import sys,json; data=json.load(sys.stdin); print(next((t['public_url'] for t in data.get('tunnels',[]) if t['public_url'].startswith('https')), ''))" 2>/dev/null)
  if [ -n "$URL" ]; then
    echo ""
    echo "================================"
    echo "Ngrok URL: $URL"
    echo "================================"
    break
  fi
  sleep 1
done

if [ -z "$URL" ]; then
  echo "Ngrok not ready — check http://localhost:4040"
fi
