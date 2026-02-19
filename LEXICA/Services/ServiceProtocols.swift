import Foundation
import CoreVideo

protocol TextRecognitionServiceProtocol {
    func recognizeText(from pixelBuffer: CVPixelBuffer, completion: @escaping (String) -> Void)
}

protocol SpeechServiceProtocol {
    func speak(text: String, rate: Float)
    func stopSpeaking()
}

protocol CameraServiceProtocol {
    func startSession()
    func stopSession()
}
