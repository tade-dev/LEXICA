import SwiftUI
import UIKit

extension View {
    func renderAsImage(size: CGSize) -> UIImage {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.bounds = CGRect(origin: .zero, size: size)
        hostingController.view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            hostingController.view.layer.render(in: context.cgContext)
        }
    }
}
