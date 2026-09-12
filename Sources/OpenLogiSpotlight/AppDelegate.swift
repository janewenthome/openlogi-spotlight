import AppKit
import ApplicationServices

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let configurationStore = ConfigurationStore()
    private var configuration = SpotlightConfiguration.default
    private var spotlightController: SpotlightController!
    private var statusItem: NSStatusItem!
    private var toggleItem: NSMenuItem!
    private var permissionItem: NSMenuItem!
    private var globalMonitor: Any?
    private var localMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        configuration = configurationStore.load()
        spotlightController = SpotlightController(configuration: configuration)
        configureStatusItem()
        installEventMonitors()
        updateMenu()
        requestAccessibilityPermissionIfNeeded()
    }

    func applicationWillTerminate(_ notification: Notification) {
        removeEventMonitors()
        spotlightController?.hide()
    }

    private func configureStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "◉"
        statusItem.button?.toolTip = "OpenLogi Spotlight"

        let menu = NSMenu()
        toggleItem = NSMenuItem(title: "Show Spotlight", action: #selector(toggleSpotlight), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)

        menu.addItem(.separator())

        permissionItem = NSMenuItem(
            title: "Open Accessibility Settings…",
            action: #selector(openAccessibilitySettings),
            keyEquivalent: ""
        )
        permissionItem.target = self
        menu.addItem(permissionItem)

        let configItem = NSMenuItem(
            title: "Copy Configuration Path",
            action: #selector(copyConfigurationPath),
            keyEquivalent: ""
        )
        configItem.target = self
        menu.addItem(configItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Quit OpenLogi Spotlight", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        statusItem.menu = menu
    }

    private func installEventMonitors() {
        let eventMask: NSEvent.EventTypeMask = [.keyDown]

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: eventMask) { [weak self] event in
            let keyCode = event.keyCode
            let flags = event.modifierFlags.rawValue
            let isRepeat = event.isARepeat
            DispatchQueue.main.async {
                self?.handleKey(keyCode: keyCode, modifierFlagsRawValue: flags, isRepeat: isRepeat)
            }
        }

        localMonitor = NSEvent.addLocalMonitorForEvents(matching: eventMask) { [weak self] event in
            guard let self else { return event }
            let handled = self.handleKey(
                keyCode: event.keyCode,
                modifierFlagsRawValue: event.modifierFlags.rawValue,
                isRepeat: event.isARepeat
            )
            return handled ? nil : event
        }
    }

    private func removeEventMonitors() {
        if let globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
        if let localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
        globalMonitor = nil
        localMonitor = nil
    }

    @discardableResult
    private func handleKey(keyCode: UInt16, modifierFlagsRawValue: UInt, isRepeat: Bool) -> Bool {
        guard !isRepeat else { return false }

        if keyCode == 53, spotlightController.isActive {
            spotlightController.hide()
            updateMenu()
            return true
        }

        guard configuration.hotKey.matches(
            keyCode: keyCode,
            modifierFlagsRawValue: modifierFlagsRawValue
        ) else { return false }

        spotlightController.toggle()
        updateMenu()
        return true
    }

    private func updateMenu() {
        statusItem?.button?.title = AXIsProcessTrusted() ? "◉" : "⚠️"
        toggleItem?.title = spotlightController.isActive
            ? "Hide Spotlight (\(configuration.hotKey.displayName))"
            : "Show Spotlight (\(configuration.hotKey.displayName))"

        permissionItem?.title = AXIsProcessTrusted()
            ? "Accessibility Permission: Granted"
            : "Open Accessibility Settings…"
    }

    private func requestAccessibilityPermissionIfNeeded() {
        guard !AXIsProcessTrusted() else { return }

        let options = [
            kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true,
        ] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    @objc private func toggleSpotlight() {
        spotlightController.toggle()
        updateMenu()
    }

    @objc private func openAccessibilitySettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
            return
        }
        NSWorkspace.shared.open(url)
    }

    @objc private func copyConfigurationPath() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(configurationStore.url.path, forType: .string)
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
