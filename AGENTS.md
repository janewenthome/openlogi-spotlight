# OpenLogi Spotlight — Project Guide

## Scope

- This repository is a macOS 13+ Swift Package Manager companion app.
- OpenLogi is an external prerequisite. Do not copy its source, logo, icon, or proprietary brand assets into this repository.
- Keep the first-party app local-first: no account, telemetry, network request, or cloud dependency.

## Layout

- `Sources/OpenLogiSpotlight/`: application code and overlay behavior.
- `Tests/OpenLogiSpotlightTests/`: deterministic assert-based test harnesses that do not require a live display or mouse.
- `Resources/`: app bundle metadata.
- `scripts/`: build and install helpers.
- `docs/`: architecture decisions and user setup instructions.
- `materials/`, `assets/`, `outputs/`: project working folders documented in `README.md`.

## Working rules

- Target macOS 13+ and Apple Silicon first; keep platform-specific code isolated so a future Linux/Windows port can replace the overlay and global-hotkey layers.
- Do not change OpenLogi's HID configuration automatically: device keys and user bindings are device-specific. Provide explicit instructions or opt-in tooling instead.
- Any change to shortcut matching, overlay visibility, or configuration decoding must have a focused test where practical.
- Validate with `make test`, `swift build`, and `make app` before handing off a runnable change. The local test harness avoids XCTest because the lightweight Command Line Tools installation does not ship that framework.
- Do not commit `.build/`, `.DS_Store`, or generated `.app` bundles.
