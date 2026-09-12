import AppKit

@MainActor
final class SpotlightController {
    private var configuration: SpotlightConfiguration
    private var windows: [SpotlightOverlayWindow] = []
    private var refreshTimer: Timer?
    private var screenObserver: NSObjectProtocol?

    private(set) var isActive = false

    init(configuration: SpotlightConfiguration) {
        self.configuration = configuration.normalized
        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.rebuildWindows()
            }
        }
    }

    deinit {
        if let screenObserver {
            NotificationCenter.default.removeObserver(screenObserver)
        }
    }

    func update(configuration: SpotlightConfiguration) {
        self.configuration = configuration.normalized
        refresh()
    }

    func toggle() {
        isActive ? hide() : show()
    }

    func show() {
        guard !isActive else { return }
        isActive = true
        rebuildWindows()
        windows.forEach { $0.orderFrontRegardless() }
        startRefreshTimer()
        refresh()
    }

    func hide() {
        guard isActive else { return }
        isActive = false
        refreshTimer?.invalidate()
        refreshTimer = nil
        windows.forEach { $0.orderOut(nil) }
    }

    private func startRefreshTimer() {
        refreshTimer?.invalidate()
        let interval = 1 / configuration.cursorRefreshRate
        let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.refresh()
            }
        }
        refreshTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func rebuildWindows() {
        guard isActive else { return }

        windows.forEach { $0.orderOut(nil) }
        windows = NSScreen.screens.map { screen in
            let window = SpotlightOverlayWindow(
                contentRect: screen.frame,
                styleMask: .borderless,
                backing: .buffered,
                defer: false
            )
            window.level = .screenSaver
            window.backgroundColor = .clear
            window.isOpaque = false
            window.hasShadow = false
            window.ignoresMouseEvents = true
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
            window.contentView = SpotlightView(
                configuration: configuration,
                frame: NSRect(origin: .zero, size: screen.frame.size)
            )
            window.orderFrontRegardless()
            return window
        }
        refresh()
    }

    private func refresh() {
        guard isActive else { return }

        let cursor = NSEvent.mouseLocation
        for (window, screen) in zip(windows, NSScreen.screens) {
            let localPoint: NSPoint?
            if screen.frame.contains(cursor) {
                localPoint = NSPoint(
                    x: cursor.x - screen.frame.minX,
                    y: cursor.y - screen.frame.minY
                )
            } else {
                localPoint = nil
            }
            (window.contentView as? SpotlightView)?.update(
                configuration: configuration,
                cursorPosition: localPoint
            )
        }
    }
}
