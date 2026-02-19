import Vision

final class VisionTextRecognitionService: TextRecognitionServiceProtocol {
    private let queue = DispatchQueue(label: "lexica.vision.text", qos: .userInitiated)
    private var handler: ((String) -> Void)?

    func startRecognition(handler: @escaping (String) -> Void) {
        self.handler = handler
    }

    func stopRecognition() {
        handler = nil
    }

    func processFrame(_ pixelBuffer: CVPixelBuffer) {
        let request = VNRecognizeTextRequest { [weak self] request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let text = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            self?.handler?(text)
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        queue.async {
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try? requestHandler.perform([request])
        }
    }
}
