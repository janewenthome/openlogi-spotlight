#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_SOURCE="$ROOT_DIR/outputs/OpenLogiSpotlight.app"
USER_APPS_DIR="$HOME/Applications"
APP_DEST="$USER_APPS_DIR/OpenLogiSpotlight.app"

"$ROOT_DIR/scripts/build-app.sh"
mkdir -p "$USER_APPS_DIR"
command ditto --rsrc --extattr --qtn "$APP_SOURCE" "$APP_DEST"
open "$APP_DEST"

echo "Installed $APP_DEST"
echo "If the shortcut does not respond, allow this app under System Settings > Privacy & Security > Accessibility."
