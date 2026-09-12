# Architecture

```text
Logitech mouse button
        │
        ▼
OpenLogi HID++ / input hook
        │  CustomShortcut = F13
        ▼
macOS global key monitor
        │
        ▼
AppDelegate ──────── menu-bar controls / Accessibility settings
        │
        ▼
SpotlightController
        │  60 Hz cursor sampling
        ▼
one click-through NSWindow per NSScreen
        │
        ▼
SpotlightView: dim layer + transparent circular hole + ring
```

## Boundaries

- `SpotlightConfiguration.swift` is pure configuration and shortcut matching. It does not know about windows.
- `SpotlightController.swift` is presentation state. It does not parse OpenLogi TOML or inspect HID devices.
- `AppDelegate.swift` is the platform integration boundary. It wires AppKit, the global monitor, the status item, and the controller.
- OpenLogi remains an external process and prerequisite. The companion app never writes a device-specific OpenLogi config because the physical device key is discovered per machine.

## Important trade-offs

- Cursor sampling with a main-run-loop timer is deliberately simple and keeps the overlay passive. It avoids adding a second event tap that could interfere with system input.
- A click-through window at `NSWindow.Level.screenSaver` stays above full-screen presentation windows while `ignoresMouseEvents` preserves normal slide interaction.
- A toggle shortcut is the MVP interaction. A future hold-to-show mode can be added without changing the OpenLogi integration boundary.
- The first version uses a JSON config file instead of a settings window so it is easy to inspect, version, and test. A settings UI is a follow-up item in `TODO.md`.
