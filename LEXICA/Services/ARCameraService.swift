import UIKit
import ARKit
import RealityKit
import Vision
import simd

final class ARCameraService: NSObject, CameraServiceProtocol {
    private var arView: ARView?
    private let textService: TextRecognitionServiceProtocol
    private var highlightAnchors: [AnchorEntity] = []

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

    func placeHighlights(for observations: [VNRecognizedTextObservation]) {
        guard let view = arView else { return }

        for anchor in highlightAnchors {
            view.scene.anchors.remove(anchor)
        }
        highlightAnchors.removeAll()

        let bounds = view.bounds
        guard bounds.width > 0, bounds.height > 0 else { return }

        for observation in observations {
            let rect = screenRect(from: observation.boundingBox, in: bounds)
            let center = CGPoint(x: rect.midX, y: rect.midY)

            guard let result = view.raycast(from: center, allowing: .estimatedPlane, alignment: .any).first else {
                continue
            }

            let position = SIMD3<Float>(
                result.worldTransform.columns.3.x,
                result.worldTransform.columns.3.y,
                result.worldTransform.columns.3.z
            )
            
            let distance = simd_length(position)
            let metersPerPoint = max(0.0004, distance * 0.00025)
            let width = max(0.01, Float(rect.width) * metersPerPoint)
            let height = max(0.01, Float(rect.height) * metersPerPoint)

            let mesh = MeshResource.generatePlane(width: width, height: height)
            let material = SimpleMaterial(color: UIColor.yellow.withAlphaComponent(0.4), isMetallic: false)
            let highlightEntity = ModelEntity(mesh: mesh, materials: [material])
            highlightEntity.scale = SIMD3(0.9, 0.9, 0.9)

            let anchor = AnchorEntity(world: result.worldTransform)
            anchor.addChild(highlightEntity)
            view.scene.anchors.append(anchor)
            highlightAnchors.append(anchor)

            let pulseUp = Transform(scale: SIMD3(1.05, 1.05, 1.05))
            let pulseDown = Transform(scale: SIMD3(1.0, 1.0, 1.0))
            highlightEntity.move(
                to: pulseUp,
                relativeTo: highlightEntity,
                duration: 0.25,
                timingFunction: .easeInOut
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                highlightEntity.move(
                    to: pulseDown,
                    relativeTo: highlightEntity,
                    duration: 0.25,
                    timingFunction: .easeInOut
                )
            }
        }
    }

    func clearHighlights(animated: Bool = true) {
        guard let view = arView else {
            highlightAnchors.removeAll()
            return
        }

        guard animated else {
            for anchor in highlightAnchors {
                view.scene.anchors.remove(anchor)
            }
            highlightAnchors.removeAll()
            return
        }

        let anchorsToRemove = highlightAnchors
        highlightAnchors.removeAll()

        let duration: TimeInterval = 0.3
        let steps = 10
        let interval = duration / Double(steps)

        for anchor in anchorsToRemove {
            let modelEntities = anchor.children.compactMap { $0 as? ModelEntity }

            for step in 0...steps {
                let alpha = CGFloat(1.0 - (Double(step) / Double(steps)))
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(step) * interval)) {
                    for model in modelEntities {
                        self.applyOpacity(alpha, to: model)
                    }
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                view.scene.anchors.remove(anchor)
            }
        }
    }

    private func screenRect(from normalized: CGRect, in bounds: CGRect) -> CGRect {
        let width = bounds.width * normalized.width
        let height = bounds.height * normalized.height
        let x = bounds.minX + bounds.width * normalized.minX
        let y = bounds.minY + bounds.height * (1 - normalized.maxY)
        return CGRect(x: x, y: y, width: width, height: height)
    }

    private func applyOpacity(_ opacity: CGFloat, to model: ModelEntity) {
        guard var modelComponent = model.model else { return }
        modelComponent.materials = modelComponent.materials.map { material in
            guard var simple = material as? SimpleMaterial else { return material }
            let tint = simple.color.tint.withAlphaComponent(opacity)
            simple.color = SimpleMaterial.BaseColor(tint: tint, texture: simple.color.texture)
            return simple
        }
        model.model = modelComponent
    }
}
