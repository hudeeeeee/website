#!/bin/bash

# Download product images from GitHub repo
BASE_URL="https://raw.githubusercontent.com/phamthanhhai003/ThucTap/main/src/public/imgs/product_image"
TARGET_DIR="/mnt/c/Users/Admin/OneDrive/Attachments/website/public/img/products"

echo "Downloading product images from GitHub..."

# Read image mappings from images.txt
tail -n +2 /mnt/c/Temp/images.txt | while IFS=$'\t' read -r pid img_name display; do
  # Remove UTF-16 BOM and whitespace
  pid=$(echo "$pid" | tr -d '\000' | xargs)
  img_name=$(echo "$img_name" | tr -d '\000' | xargs)

  if [ -z "$pid" ] || [ -z "$img_name" ]; then
    continue
  fi

  # Create product folder
  mkdir -p "$TARGET_DIR/P$pid"

  # Download image
  url="$BASE_URL/P$pid/$img_name"
  target="$TARGET_DIR/P$pid/$img_name"

  if [ ! -f "$target" ]; then
    echo "Downloading P$pid/$img_name..."
    curl -sSL "$url" -o "$target" 2>/dev/null
    if [ $? -eq 0 ]; then
      echo "  ✓ P$pid/$img_name"
    else
      echo "  ✗ Failed: P$pid/$img_name"
    fi
  fi
done

echo "✓ Image download complete"
