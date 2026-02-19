import Vision

final class VisionTextRecognitionService: TextRecognitionServiceProtocol {
    private let queue = DispatchQueue(label: "lexica.vision.text", qos: .userInitiated)

    func recognizeText(from pixelBuffer: CVPixelBuffer, completion: @escaping (RecognizedTextResult) -> Void) {
        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let fullText = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            let result = RecognizedTextResult(
                fullText: fullText,
                observations: observations
            )
            DispatchQueue.main.async {
                completion(result)
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
