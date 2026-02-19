import Foundation
import Combine

final class ReadingViewModel: ObservableObject {
    @Published var recognizedText: String
    @Published var isRecognizing: Bool
    @Published var settings: ReadingSettings

    private let textService: TextRecognitionServiceProtocol
    private let speechService: SpeechServiceProtocol

    init(
        textService: TextRecognitionServiceProtocol,
        speechService: SpeechServiceProtocol,
        settings: ReadingSettings = .default
    ) {
        self.textService = textService
        self.speechService = speechService
        self.settings = settings
        self.recognizedText = ""
        self.isRecognizing = false
    }

    func startRecognition() {
        isRecognizing = true
        textService.startRecognition { [weak self] text in
            self?.recognizedText = text
        }
    }

    func stopRecognition() {
        isRecognizing = false
        textService.stopRecognition()
    }

    func speakCurrentText() {
        speechService.speak(text: recognizedText, rate: settings.speechRate)
    }

    func updateSettings(_ newSettings: ReadingSettings) {
        settings = newSettings
    }
}
