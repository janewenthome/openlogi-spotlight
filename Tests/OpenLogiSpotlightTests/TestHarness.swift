import AppKit

@main
struct ConfigurationTestHarness {
    static func main() {
        testDefaultHotKeyMatchesOnlyCommandShiftNine()
        testDisplayNameUsesMacModifierSymbols()
        testConfigurationDecodingUsesDefaultsForOmittedValues()
        testConfigurationNormalizationClampsRefreshRate()
        print("OpenLogi Spotlight configuration tests passed")
    }

    private static func testDefaultHotKeyMatchesOnlyCommandShiftNine() {
        let hotKey = HotKey.default
        let commandShift = NSEvent.ModifierFlags([.command, .shift]).rawValue

        precondition(hotKey.matches(keyCode: 25, modifierFlagsRawValue: commandShift))
        precondition(!hotKey.matches(keyCode: 25, modifierFlagsRawValue: NSEvent.ModifierFlags.command.rawValue))
        precondition(!hotKey.matches(keyCode: 18, modifierFlagsRawValue: commandShift))
    }

    private static func testDisplayNameUsesMacModifierSymbols() {
        precondition(HotKey.default.displayName == "⌘⇧9")
    }

    private static func testConfigurationDecodingUsesDefaultsForOmittedValues() {
        let data = Data(#"{"dimOpacity": 2, "spotlightRadius": 8}"#.utf8)
        let configuration = try! JSONDecoder().decode(SpotlightConfiguration.self, from: data)

        precondition(configuration.hotKey == .default)
        precondition(configuration.normalized.dimOpacity == 0.95)
        precondition(configuration.normalized.spotlightRadius == 24)
        precondition(configuration.normalized.ringColorHex == "FFD400")
    }

    private static func testConfigurationNormalizationClampsRefreshRate() {
        var configuration = SpotlightConfiguration.default
        configuration.cursorRefreshRate = 500
        precondition(configuration.normalized.cursorRefreshRate == 120)

        configuration.cursorRefreshRate = 1
        precondition(configuration.normalized.cursorRefreshRate == 15)
    }
}
