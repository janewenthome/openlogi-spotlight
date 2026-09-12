import AppKit

final class SpotlightView: NSView {
    private var configuration: SpotlightConfiguration
    private var cursorPosition: NSPoint?

    init(configuration: SpotlightConfiguration, frame: NSRect) {
        self.configuration = configuration
        super.init(frame: frame)
        wantsLayer = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SpotlightView does not support Interface Builder")
    }

    func update(configuration: SpotlightConfiguration, cursorPosition: NSPoint?) {
        self.configuration = configuration
        self.cursorPosition = cursorPosition
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let opacity = CGFloat(configuration.dimOpacity)
        NSColor.black.withAlphaComponent(opacity).setFill()
        NSBezierPath(rect: bounds).fill()

        guard let cursorPosition else { return }

        let radius = CGFloat(configuration.spotlightRadius)
        let spotlightRect = NSRect(
            x: cursorPosition.x - radius,
            y: cursorPosition.y - radius,
            width: radius * 2,
            height: radius * 2
        )

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current?.compositingOperation = .clear
        NSBezierPath(ovalIn: spotlightRect).fill()
        NSGraphicsContext.restoreGraphicsState()

        guard configuration.ringWidth > 0,
              let ringColor = NSColor(hex: configuration.ringColorHex)
        else { return }

        ringColor.setStroke()
        let ring = NSBezierPath(ovalIn: spotlightRect)
        ring.lineWidth = CGFloat(configuration.ringWidth)
        ring.stroke()
    }
}

final class SpotlightOverlayWindow: NSWindow {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

extension NSColor {
    convenience init?(hex: String, alpha: CGFloat = 1) {
        let value = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        guard value.count == 6, let number = UInt64(value, radix: 16) else { return nil }

        let red = CGFloat((number >> 16) & 0xff) / 255
        let green = CGFloat((number >> 8) & 0xff) / 255
        let blue = CGFloat(number & 0xff) / 255
        self.init(calibratedRed: red, green: green, blue: blue, alpha: alpha)
    }
}
