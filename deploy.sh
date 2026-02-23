#!/bin/bash
set -e

ENV_NAME=$1
BUILD_NO=$2

if [ -z "$ENV_NAME" ] || [ -z "$BUILD_NO" ]; then
  echo "Usage: ./deploy.sh <ENV> <BUILD_NO>"
  exit 1
fi

TARGET_DIR="/var/www/${ENV_NAME}"
sudo mkdir -p "$TARGET_DIR"

sed "s/__ENV__/${ENV_NAME}/g; s/__BUILD__/${BUILD_NO}/g" index.html | sudo tee "${TARGET_DIR}/index.html" >/dev/null

echo "Deployed to ${TARGET_DIR}/index.html"

chmod +x deploy.sh