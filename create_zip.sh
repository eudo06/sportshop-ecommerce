#!/bin/bash

# Create zip file

ZIP_NAME="PROJET_WEB_shareable.zip"

echo "Creating zip file: $ZIP_NAME"

cd "$(dirname "$0")"

zip -r "$ZIP_NAME" . \
  -x "$ZIP_NAME" \
  -x "node_modules/*" "frontend-vue/node_modules/*" \
  -x "dist/*" "frontend-vue/dist/*" "build/*" \
  -x "*.env" "*/.env" \
  -x ".DS_Store"

if [ $? -eq 0 ]; then
  echo "Zip created: $ZIP_NAME ($(du -h "$ZIP_NAME" | cut -f1))"
else
  echo "Error creating zip file"
  exit 1
fi
