import Foundation
import Combine
import Vision

final class ReadingViewModel: ObservableObject {
    @Published var recognizedText: String
    @Published var isRecognizing: Bool
    @Published var isSpeaking: Bool = false
    @Published var textObservations: [VNRecognizedTextObservation] = []
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
    }

    func stopRecognition() {
        isRecognizing = false
    }

    func scanCurrentFrame(using cameraService: ARCameraService) {
        guard let pixelBuffer = cameraService.captureCurrentFrame() else { return }

        DispatchQueue.main.async { [weak self] in
            self?.isRecognizing = true
        }

        textService.recognizeText(from: pixelBuffer) { [weak self] result in
            DispatchQueue.main.async {
                self?.recognizedText = result.fullText
                self?.textObservations = result.observations
                self?.isRecognizing = false
            }
        }
    }

    func speakCurrentText() {
        if isSpeaking {
            speechService.stopSpeaking()
            DispatchQueue.main.async { [weak self] in
                self?.isSpeaking = false
            }
        } else {
            speechService.speak(text: recognizedText, rate: settings.speechRate)
            DispatchQueue.main.async { [weak self] in
                self?.isSpeaking = true
            }
        }
    }

    func updateSettings(_ newSettings: ReadingSettings) {
        settings = newSettings
    }
}
