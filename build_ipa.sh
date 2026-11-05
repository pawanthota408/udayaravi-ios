#!/bin/bash
# Shell script to automatically build and export UdayaraviCreations.ipa on macOS
set -e

echo "=========================================================="
echo "  Building UdayaRavi Creations iOS (.ipa) Package         "
echo "=========================================================="

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXPORT_PATH="$PROJECT_DIR/build/ipa_output"
DERIVED_DATA="$PROJECT_DIR/build/DerivedData"

mkdir -p "$PROJECT_DIR/build"

# List project schemes & targets
echo "Listing schemes..."
xcodebuild -list -project "$PROJECT_DIR/UdayaraviCreations.xcodeproj"

# 1. Compile iOS App for Device
echo "[1/2] Compiling iOS App with Xcode..."
xcodebuild build \
  -project "$PROJECT_DIR/UdayaraviCreations.xcodeproj" \
  -scheme "UdayaraviCreations" \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  AD_HOC_CODE_SIGNING_ALLOWED=YES

# Find compiled .app
APP_PATH=$(find "$DERIVED_DATA/Build/Products/Release-iphoneos" -name "UdayaraviCreations.app" -type d | head -n 1)

if [ -z "$APP_PATH" ]; then
  # Fallback search across derivedData
  APP_PATH=$(find "$DERIVED_DATA" -name "UdayaraviCreations.app" -type d | head -n 1)
fi

if [ -z "$APP_PATH" ]; then
  echo "Error: UdayaraviCreations.app not found in $DERIVED_DATA"
  exit 1
fi

echo "Found compiled app at: $APP_PATH"

# 2. Package into .ipa
echo "[2/2] Packaging into .ipa..."
rm -rf "$EXPORT_PATH"
mkdir -p "$EXPORT_PATH/Payload"
cp -r "$APP_PATH" "$EXPORT_PATH/Payload/"

cd "$EXPORT_PATH"
zip -r "$PROJECT_DIR/UdayaraviCreations.ipa" Payload
cd "$PROJECT_DIR"

rm -rf "$EXPORT_PATH"
echo "=========================================================="
echo "  SUCCESS! .ipa file generated at:                        "
echo "  $PROJECT_DIR/UdayaraviCreations.ipa                     "
echo "=========================================================="
