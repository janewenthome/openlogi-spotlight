#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DIR="$ROOT_DIR/outputs/OpenLogiSpotlight.app"
swift build --configuration release
BIN_DIR="$(swift build --configuration release --show-bin-path)"

mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
command ditto "$ROOT_DIR/Resources/Info.plist" "$APP_DIR/Contents/Info.plist"
command ditto "$BIN_DIR/OpenLogiSpotlight" "$APP_DIR/Contents/MacOS/OpenLogiSpotlight"

# An ad-hoc signature makes the local bundle launchable as an app. A future
# release workflow should replace this with a Developer ID signature/notarization.
codesign --force --deep --sign - "$APP_DIR" >/dev/null

echo "Built $APP_DIR"
