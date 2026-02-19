import UIKit
import ARKit
import RealityKit

final class ARCameraService: NSObject, CameraServiceProtocol {
    private var arView: ARView?
    private let textService: TextRecognitionServiceProtocol

    init(textService: TextRecognitionServiceProtocol) {
        self.textService = textService
        super.init()
    }

    func makeARView() -> ARView {
        let view = ARView(frame: .zero)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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

    func captureCurrentFrame() -> CVPixelBuffer? {
        arView?.session.currentFrame?.capturedImage
    }
}
