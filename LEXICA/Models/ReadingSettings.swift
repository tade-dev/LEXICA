import Foundation

struct ReadingSettings: Codable, Equatable {
    var letterSpacing: Double
    var lineSpacing: Double
    var backgroundOpacity: Double
    var fontName: String
    var focusModeEnabled: Bool
    var speechRate: Float

    static let `default` = ReadingSettings(
        letterSpacing: 0.0,
        lineSpacing: 4.0,
        backgroundOpacity: 0.9,
        fontName: "System",
        focusModeEnabled: false,
        speechRate: 0.5
    )
}
