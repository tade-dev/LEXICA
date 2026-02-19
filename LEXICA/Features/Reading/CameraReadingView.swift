import SwiftUI
import CoreVideo

struct CameraReadingView: View {
    @StateObject var viewModel: ReadingViewModel
    let cameraService: ARCameraService
    @State private var floating = false

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.965)
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
        .onAppear {
            floating = true
        }
    }

    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Reading Mode")
                    .font(.title2.bold())
                Text("Transform text for clarity")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            Toggle("", isOn: $viewModel.settings.focusModeEnabled)
                .labelsHidden()
        }
        .padding(.top, 12)
    }

    private var bottomBar: some View {
        HStack(spacing: 16) {
            Button("Scan Text") {
                viewModel.scanCurrentFrame(using: cameraService)
            }
            .buttonStyle(ElevatedButtonStyle())

            Button(viewModel.isSpeaking ? "Stop" : "Speak") {
                viewModel.speakCurrentText()
            }
            .buttonStyle(ElevatedButtonStyle())
            .scaleEffect(viewModel.isSpeaking ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: viewModel.isSpeaking)

            if viewModel.isRecognizing {
                ProgressView()
            }
        }
    }

    private var readingText: some View {
        Group {
            if viewModel.recognizedText.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "text.viewfinder")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)
                    Text("Tap Scan to capture text")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if viewModel.settings.focusModeEnabled {
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
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color(red: 0.94, green: 0.91, blue: 0.80))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
        .opacity(viewModel.isSpeaking ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isSpeaking)
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

struct ElevatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.85))
            )
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
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
