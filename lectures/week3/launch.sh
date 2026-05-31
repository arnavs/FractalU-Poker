#!/bin/bash

# -----------------------------
# Kill any leftover ngrok sessions
# -----------------------------
echo "Stopping any old ngrok sessions..."
pkill -f ngrok 2>/dev/null || true

# -----------------------------
# Start Genie in a new terminal (foreground)
# -----------------------------
echo "Starting Genie server..."
# gnome-terminal -- bash -c "julia app.jl; exec bash" &  # Linux (adjust for your terminal)
# For macOS, you can use:
osascript -e 'tell application "Terminal" to do script "julia -i ~/Desktop/FractalU/lectures/week3/app.jl"'

# -----------------------------
# Wait until Genie is listening on port 8000
# -----------------------------
echo "Waiting for Genie to start on port 8000..."
while ! nc -z localhost 8000; do
  sleep 1
done
echo "Genie is up!"

# -----------------------------
# Start ngrok
# -----------------------------
echo "Starting ngrok..."
ngrok http 8000 &

# -----------------------------
# Wait for ngrok to initialize
# -----------------------------
sleep 2

# Fetch public URL from ngrok API
URL=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')

echo "Your public game URL is: $URL"

# -----------------------------
# Open browser (optional)
# -----------------------------
# macOS:
# open $URL
# Linux (if xdg-open exists):
if command -v xdg-open &>/dev/null; then
    xdg-open $URL
fi
