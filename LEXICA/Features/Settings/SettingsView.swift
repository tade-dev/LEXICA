import SwiftUI

struct SettingsView: View {
    @Binding var settings: ReadingSettings

    var body: some View {
        Form {
            Section("Reading") {
                HStack {
                    Text("Letter Spacing")
                    Spacer()
                    Text("\(settings.letterSpacing, specifier: "%.1f")")
                        .foregroundStyle(AppTheme.mutedText)
                }
                Slider(value: $settings.letterSpacing, in: 0...6, step: 0.5)
                    .accessibilityLabel("Letter Spacing")

                HStack {
                    Text("Line Spacing")
                    Spacer()
                    Text("\(settings.lineSpacing, specifier: "%.1f")")
                        .foregroundStyle(AppTheme.mutedText)
                }
                Slider(value: $settings.lineSpacing, in: 0...12, step: 0.5)
                    .accessibilityLabel("Line Spacing")

                Toggle("Focus Mode", isOn: $settings.focusModeEnabled)
            }

            Section("Speech") {
                HStack {
                    Text("Speech Rate")
                    Spacer()
                    Text("\(settings.speechRate, specifier: "%.2f")")
                        .foregroundStyle(AppTheme.mutedText)
                }
                Slider(value: $settings.speechRate, in: 0.2...0.8, step: 0.05)
                    .accessibilityLabel("Speech Rate")
            }
        }
        .tint(AppTheme.focusOverlay)
    }
}

#Preview {
    SettingsView(settings: .constant(.default))
}
