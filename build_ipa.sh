#!/bin/bash
# Shell script to automatically build and export UdayaraviCreations.ipa on macOS

set -e

echo "=========================================================="
echo "  Building UdayaRavi Creations iOS (.ipa) Package         "
echo "=========================================================="

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
ARCHIVE_PATH="$PROJECT_DIR/build/UdayaraviCreations.xcarchive"
EXPORT_PATH="$PROJECT_DIR/build/ipa_output"

# 1. Clean and Archive
echo "[1/2] Creating Xcode Archive..."
xcodebuild archive \
  -project "$PROJECT_DIR/UdayaraviCreations.xcodeproj" \
  -scheme "UdayaraviCreations" \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  -destination "generic/platform=iOS" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY=""

# 2. Package into .ipa
echo "[2/2] Packaging into .ipa..."
mkdir -p "$EXPORT_PATH/Payload"
cp -r "$ARCHIVE_PATH/Products/Applications/UdayaraviCreations.app" "$EXPORT_PATH/Payload/"

cd "$EXPORT_PATH"
zip -r "$PROJECT_DIR/UdayaraviCreations.ipa" Payload
cd "$PROJECT_DIR"

rm -rf "$EXPORT_PATH"
echo "=========================================================="
echo "  SUCCESS! .ipa file generated at:                        "
echo "  $PROJECT_DIR/UdayaraviCreations.ipa                     "
echo "=========================================================="
