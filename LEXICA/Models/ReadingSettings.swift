import Foundation

struct ReadingSettings: Codable, Equatable {
    let letterSpacing: Double
    let lineSpacing: Double
    let backgroundOpacity: Double
    let fontName: String
    let focusModeEnabled: Bool
    let speechRate: Float

    static let `default` = ReadingSettings(
        letterSpacing: 0.0,
        lineSpacing: 4.0,
        backgroundOpacity: 0.9,
        fontName: "System",
        focusModeEnabled: false,
        speechRate: 0.5
    )
}
