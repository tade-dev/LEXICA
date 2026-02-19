import ARKit
import RealityKit

final class ARCameraService: NSObject {
    private var arView: ARView?
    
    override init() {
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
}
