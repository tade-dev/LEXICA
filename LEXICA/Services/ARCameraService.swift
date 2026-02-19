import UIKit
import ARKit
import RealityKit

final class ARCameraService: NSObject, CameraServiceProtocol, ARSessionDelegate {
    private var arView: ARView?
    private let textService: TextRecognitionServiceProtocol
    private let frameQueue = DispatchQueue(label: "lexica.ar.frame.queue", qos: .userInitiated)

    init(textService: TextRecognitionServiceProtocol) {
        self.textService = textService
        super.init()
    }

    func makeARView() -> ARView {
        let view = ARView(frame: UIScreen.main.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.session.delegate = self
        arView = view
        return view
    }

    func startSession() {
        let view = arView ?? makeARView()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = []
        configuration.environmentTexturing = .none
        view.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    func stopSession() {
        arView?.session.pause()
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        frameQueue.async { [weak self] in
            self?.textService.processFrame(pixelBuffer)
        }
    }
}
