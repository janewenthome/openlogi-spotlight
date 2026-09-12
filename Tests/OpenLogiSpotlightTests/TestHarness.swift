import AppKit

@main
struct ConfigurationTestHarness {
    static func main() {
        testDefaultHotKeyMatchesOnlyF13()
        testDisplayNameUsesF13()
        testConfigurationDecodingUsesDefaultsForOmittedValues()
        testConfigurationNormalizationClampsRefreshRate()
        print("OpenLogi Spotlight configuration tests passed")
    }

    private static func testDefaultHotKeyMatchesOnlyF13() {
        let hotKey = HotKey.default
        let noModifiers = NSEvent.ModifierFlags().rawValue

        precondition(hotKey.matches(keyCode: 105, modifierFlagsRawValue: noModifiers))
        precondition(!hotKey.matches(keyCode: 105, modifierFlagsRawValue: NSEvent.ModifierFlags.command.rawValue))
        precondition(!hotKey.matches(keyCode: 104, modifierFlagsRawValue: noModifiers))
    }

    private static func testDisplayNameUsesF13() {
        precondition(HotKey.default.displayName == "F13")
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
