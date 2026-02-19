import SwiftUI
import RealityKit
import ARKit

struct ARCameraView: UIViewRepresentable {
    let cameraService: ARCameraService

    func makeUIView(context: Context) -> ARView {
        let view = cameraService.makeARView()
        cameraService.startSession()
        return view
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }

    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        // Ensure session is stopped when the view is torn down.
        uiView.session.pause()
    }
}
