# Research record

## OpenLogi integration

The repository was reviewed at commit `e846e6f4b4405e33bd6a9aaf949a482ce34cb6d8`.

- `/private/tmp/OpenLogi/README.md:52-65` documents button remapping, custom shortcuts, and the cursor-centred Actions Ring. The Actions Ring is not a presentation spotlight, so it is not reused for this MVP.
- `/private/tmp/OpenLogi/README.md:82-109` documents the macOS Homebrew installation path and warns that Logi Options+ must be closed because both applications compete for HID++ access.
- `/private/tmp/OpenLogi/docs/config.example.toml:31-40` shows device bindings and the hold/short/long binding forms.
- `/private/tmp/OpenLogi/docs/config.example.toml:52-53` shows the exact `CustomShortcut` TOML shape: `MiddleClick = { CustomShortcut = "F1" }`.
- `/private/tmp/OpenLogi/crates/openlogi-core/src/binding/action.rs:9-20` defines the serialized action contract; `CustomShortcut` is configuration data while OS event synthesis belongs to the inject layer.
- `/private/tmp/OpenLogi/crates/openlogi-core/src/binding/button.rs:118-130` confirms that middle, back, and forward are the OS-hook-remappable mouse buttons. HID++-exposed controls can also be configured through the device binding map, but the exact available controls depend on the mouse model.
- `/private/tmp/OpenLogi/crates/openlogi-hook/AGENTS.md:10-42` explains that input hooks depend on macOS privacy permissions and must avoid unsafe event-hook lifecycle behavior. This project therefore listens for the remapped shortcut and does not alter OpenLogi's hook.

## Local environment

- OS: Apple Silicon macOS 26.
- Swift: Apple Swift 6.3.3.
- OpenLogi: Homebrew cask 0.7.4, installed at `/Applications/OpenLogi.app` with the `openlogi` CLI linked into `/opt/homebrew/bin`.
- Rust/Cargo are not installed, so the companion app uses the already available native Swift/AppKit toolchain instead of modifying OpenLogi's Rust workspace.

## Decision

Build a small macOS companion app with three isolated concerns:

1. `AppDelegate` owns the menu-bar lifecycle and global shortcut monitor.
2. `SpotlightController` owns one click-through overlay window per screen and cursor tracking.
3. `SpotlightConfiguration` owns a versioned, user-editable JSON file and shortcut matching.

The default workflow is: physical Logitech button → OpenLogi `CustomShortcut` → `⌘⇧9` → companion app toggles overlay.
