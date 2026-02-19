import SwiftUI
import RealityKit
import ARKit

struct ARCameraView: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let configuration = ARWorldTrackingConfiguration()
        view.session.run(configuration)
        return view
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }

    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
    }
}
