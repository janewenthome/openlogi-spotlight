#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_BIN="$ROOT_DIR/.build/openlogi-spotlight-config-tests"

mkdir -p "$ROOT_DIR/.build"
swiftc \
    -parse-as-library \
    -framework AppKit \
    "$ROOT_DIR/Sources/OpenLogiSpotlight/Configuration.swift" \
    "$ROOT_DIR/Tests/OpenLogiSpotlightTests/TestHarness.swift" \
    -o "$TEST_BIN"

"$TEST_BIN"
