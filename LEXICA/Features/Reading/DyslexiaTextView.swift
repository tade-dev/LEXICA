import SwiftUI

struct DyslexiaTextView: View {
    let text: String
    let settings: ReadingSettings

    var body: some View {
        Text(text)
            .font(resolvedFont)
            .kerning(settings.letterSpacing)
            .lineSpacing(settings.lineSpacing)
            .padding(AppTheme.medium)
            .background(AppTheme.primaryBackground.opacity(settings.backgroundOpacity))
            .cornerRadius(AppTheme.cornerRadius)
    }

    private var resolvedFont: Font {
        if settings.fontName == "System" {
            return .system(size: 18)
        }

        return .custom(settings.fontName, size: 18)
    }
}

#Preview {
    DyslexiaTextView(
        text: "Sample text for improved readability.",
        settings: .default
    )
}
