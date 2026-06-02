#!/bin/bash
# Build và push cả app + db image lên Docker Hub

echo "Building app image..."
docker build -t haiptjits/electroshop:latest .

echo "Building db image (MySQL + seed)..."
docker build -f Dockerfile.db -t haiptjits/electroshop-db:latest .

echo "Pushing app..."
docker push haiptjits/electroshop:latest

echo "Pushing db..."
docker push haiptjits/electroshop-db:latest

echo "✅ Done:"
echo "   haiptjits/electroshop:latest"
echo "   haiptjits/electroshop-db:latest"
