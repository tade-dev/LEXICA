import Foundation
import CoreVideo
import Vision

struct RecognizedTextResult {
    let fullText: String
    let observations: [VNRecognizedTextObservation]
}

protocol TextRecognitionServiceProtocol {
    func recognizeText(from pixelBuffer: CVPixelBuffer, completion: @escaping (RecognizedTextResult) -> Void)
}

protocol SpeechServiceProtocol {
    func speak(text: String, rate: Float)
    func stopSpeaking()
}

protocol CameraServiceProtocol {
    func startSession()
    func stopSession()
}
