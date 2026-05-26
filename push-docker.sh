#!/bin/bash
# Build và push image lên Docker Hub

echo "Building image..."
docker build -t haiptjits/electroshop:latest .

echo "Pushing to Docker Hub..."
docker push haiptjits/electroshop:latest

echo "✅ Done: haiptjits/electroshop:latest"
