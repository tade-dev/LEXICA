import Vision

final class VisionTextRecognitionService: TextRecognitionServiceProtocol {
    private let queue = DispatchQueue(label: "lexica.vision.text", qos: .userInitiated)

    func recognizeText(from pixelBuffer: CVPixelBuffer, completion: @escaping (String) -> Void) {
        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let block = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            DispatchQueue.main.async {
                completion(block)
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        queue.async {
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try? requestHandler.perform([request])
        }
    }
}
