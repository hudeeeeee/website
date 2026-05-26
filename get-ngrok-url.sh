#!/bin/bash
# Get ngrok public URL

echo "Fetching ngrok public URL..."
sleep 3  # Wait for ngrok to initialize

NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*\.ngrok-free\.app' | head -1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Ngrok not ready yet. Wait 5s and try again."
    exit 1
fi

echo ""
echo "✅ Ngrok public URL: $NGROK_URL"
echo ""
echo "VNPay callback URLs:"
echo "  RETURN: $NGROK_URL/payment/vnpay/return"
echo "  IPN:    $NGROK_URL/payment/vnpay/ipn"
echo ""
echo "Access website via: $NGROK_URL"
