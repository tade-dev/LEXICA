import UIKit
import RealityKit

/// Creates 3D letter entities for use in AR learning sessions.
struct LetterFactory {

    /// The target height (in meters) for generated letter entities.
    private static let targetHeight: Float = 0.08

    /// Creates a 3D `ModelEntity` for the given character.
    ///
    /// - Parameters:
    ///   - character: The character to render as a 3D mesh.
    ///   - color: The fill color applied via an unlit material. Defaults to `.systemBlue`.
    /// - Returns: A fully configured `ModelEntity` with collision shapes and appropriate scale.
    static func createLetter(
        character: Character,
        color: UIColor = .systemBlue
    ) -> ModelEntity {
        let mesh = MeshResource.generateText(
            String(character),
            extrusionDepth: 0.02,
            font: .systemFont(ofSize: 1, weight: .medium),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byClipping
        )

        var material = UnlitMaterial()
        material.color = .init(tint: color)

        let entity = ModelEntity(mesh: mesh, materials: [material])

        // Scale to target height based on the generated mesh bounds.
        let bounds = entity.visualBounds(relativeTo: nil)
        let currentHeight = bounds.extents.y
        if currentHeight > 0 {
            let scaleFactor = targetHeight / currentHeight
            entity.scale = SIMD3<Float>(repeating: scaleFactor)
        }

        // Center the entity on its own geometry.
        let centeredBounds = entity.visualBounds(relativeTo: nil)
        let center = centeredBounds.center
        entity.position = [-center.x, -center.y, -center.z]

        // Generate collision shapes for tap and drag interactions.
        entity.generateCollisionShapes(recursive: true)

        return entity
    }
}
