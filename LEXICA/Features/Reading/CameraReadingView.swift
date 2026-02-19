import SwiftUI
import CoreVideo

struct CameraReadingView: View {
    @StateObject var viewModel: ReadingViewModel
    let cameraService: ARCameraService

    var body: some View {
        ZStack {
            ARCameraView(cameraService: cameraService)
                .ignoresSafeArea()

            VStack(spacing: AppTheme.large) {
                topBar

                Spacer()

                readingText

                Spacer()

                bottomBar
            }
            .padding(AppTheme.large)
        }
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
            Button("Scan Text") {
                viewModel.scanCurrentFrame(using: cameraService)
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

            if viewModel.isRecognizing {
                ProgressView()
            }
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
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .bottom)),
                    removal: .opacity
                ))
            }
        }
        .padding(AppTheme.medium)
        .background(AppTheme.focusOverlay.opacity(0.85))
        .cornerRadius(AppTheme.cornerRadius)
        .animation(.easeInOut(duration: 0.4), value: viewModel.recognizedText)
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
        ),
        cameraService: ARCameraService(textService: PreviewTextService())
    )
}
private struct PreviewTextService: TextRecognitionServiceProtocol {
    func recognizeText(from pixelBuffer: CVPixelBuffer, completion: @escaping (String) -> Void) {
        completion("Recognized text will appear here.")
    }
}

private struct PreviewSpeechService: SpeechServiceProtocol {
    func speak(text: String, rate: Float) {
    }

    func stopSpeaking() {
    }
}
