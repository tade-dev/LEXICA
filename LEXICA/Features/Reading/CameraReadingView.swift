import SwiftUI

struct CameraReadingView: View {
    @StateObject var viewModel: ReadingViewModel

    var body: some View {
        VStack(spacing: AppTheme.large) {
            topBar

            Spacer()

            readingText

            Spacer()

            bottomBar
        }
        .padding(AppTheme.large)
        .background(AppTheme.primaryBackground.ignoresSafeArea())
    }

    private var topBar: some View {
        HStack {
            Button("Settings") {
            }
            .foregroundStyle(AppTheme.mutedText)

            Spacer()

            Toggle("Focus", isOn: $viewModel.settings.focusModeEnabled)
                .labelsHidden()
        }
    }

    private var bottomBar: some View {
        HStack(spacing: AppTheme.medium) {
            Button(viewModel.isRecognizing ? "Stop" : "Start") {
                if viewModel.isRecognizing {
                    viewModel.stopRecognition()
                } else {
                    viewModel.startRecognition()
                }
            }
            .padding(.vertical, AppTheme.small)
            .padding(.horizontal, AppTheme.medium)
            .background(AppTheme.focusOverlay)
            .cornerRadius(AppTheme.cornerRadius)

            Button("Speak") {
                viewModel.speakCurrentText()
            }
            .padding(.vertical, AppTheme.small)
            .padding(.horizontal, AppTheme.medium)
            .background(AppTheme.focusOverlay)
            .cornerRadius(AppTheme.cornerRadius)
        }
    }

    private var readingText: some View {
        Group {
            if viewModel.settings.focusModeEnabled {
                focusModeText
            } else {
                DyslexiaTextView(
                    text: viewModel.recognizedText,
                    settings: viewModel.settings
                )
            }
        }
    }

    private var focusModeText: some View {
        ZStack {
            AppTheme.mutedText
                .opacity(0.15)
                .frame(maxWidth: .infinity)
                .cornerRadius(AppTheme.cornerRadius)

            DyslexiaTextView(
                text: activeLine,
                settings: viewModel.settings
            )
            .background(AppTheme.focusOverlay)
            .cornerRadius(AppTheme.cornerRadius)
        }
    }

    private var activeLine: String {
        viewModel.recognizedText
            .components(separatedBy: .newlines)
            .first ?? ""
    }
}

#Preview {
    CameraReadingView(
        viewModel: ReadingViewModel(
            textService: PreviewTextService(),
            speechService: PreviewSpeechService()
        )
    )
}
private struct PreviewTextService: TextRecognitionServiceProtocol {
    func startRecognition(handler: @escaping (String) -> Void) {
        handler("Recognized text will appear here.")
    }

    func stopRecognition() {
    }
}

private struct PreviewSpeechService: SpeechServiceProtocol {
    func speak(text: String, rate: Float) {
    }

    func stopSpeaking() {
    }
}
