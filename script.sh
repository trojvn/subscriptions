#!/usr/bin/env bash

set -e

# ===== НАСТРОЙКИ =====
WORKDIR="$HOME/vpn-subscription"
SOURCE_URL="https://raw.githubusercontent.com/igareck/vpn-configs-for-russia/refs/heads/main/Vless-Reality-White-Lists-Rus-Mobile.txt"

RAW_FILE="nodes.txt"
ENCODED_FILE="subscription.txt"

# =====================

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Если git repo еще не клонирован
if [ ! -d ".git" ]; then
    echo "ERROR: тут должен быть git repo"
    exit 1
fi

echo "[1] Download source..."
curl -fsSL "$SOURCE_URL" -o "$RAW_FILE"

echo "[2] Encode base64..."
base64 -w0 "$RAW_FILE" > "$ENCODED_FILE"

echo "[3] Git commit..."

git add "$ENCODED_FILE"

if git diff --cached --quiet; then
    echo "No changes"
    exit 0
fi

git commit -m "auto update $(date '+%Y-%m-%d %H:%M:%S')"

echo "[4] Push..."
git push

echo "Done"
