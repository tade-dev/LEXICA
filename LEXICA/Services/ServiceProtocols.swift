import Foundation
import CoreVideo

protocol TextRecognitionServiceProtocol {
    func startRecognition(handler: @escaping (String) -> Void)
    func stopRecognition()
    func processFrame(_ pixelBuffer: CVPixelBuffer)
}

protocol SpeechServiceProtocol {
    func speak(text: String, rate: Float)
    func stopSpeaking()
}

protocol CameraServiceProtocol {
    func startSession()
    func stopSession()
}
