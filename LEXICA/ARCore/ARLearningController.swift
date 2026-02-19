import ARKit
import RealityKit
import Combine

/// Orchestrates the AR learning session: owns the ARView, manages the
/// root anchor, and tracks the current learning state.
final class ARLearningController: ObservableObject {

    // MARK: - Published State

    @Published private(set) var currentState: LearningState = .singleLetter("A")

    // MARK: - AR Scene

    /// The ARView that hosts the learning session.
    let arView: ARView = {
        let view = ARView(frame: .zero)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    /// Root anchor attached to a detected horizontal plane.
    let rootAnchor: AnchorEntity = {
        AnchorEntity(.plane(.horizontal, classification: .any,
                            minimumBounds: SIMD2<Float>(0.2, 0.2)))
    }()

    // MARK: - Init

    init() {
        arView.scene.addAnchor(rootAnchor)
    }

    // MARK: - Session

    /// Configures and starts the AR session with horizontal plane detection.
    func startSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    /// Pauses the AR session.
    func stopSession() {
        arView.session.pause()
    }

    // MARK: - State Management

    /// Transitions to a new learning state, clearing all entities from the
    /// root anchor before the switch.
    func transition(to newState: LearningState) {
        clearScene()
        currentState = newState
    }

    // MARK: - Helpers

    /// Removes all child entities from the root anchor.
    private func clearScene() {
        rootAnchor.children.removeAll()
    }
}
