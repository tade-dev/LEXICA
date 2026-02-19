import Foundation

protocol TextRecognitionServiceProtocol {
    func startRecognition(handler: @escaping (String) -> Void)
    func stopRecognition()
}

protocol SpeechServiceProtocol {
    func speak(text: String, rate: Float)
    func stopSpeaking()
}

protocol CameraServiceProtocol {
    func startSession()
    func stopSession()
}
