import UIKit
import Foundation

extension UIImage {

    convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.fill(CGRect(origin: .zero, size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
              let imagePNGData = image.pngData()
              else { return nil }
    
        UIGraphicsEndImageContext()

        self.init(data: imagePNGData)
    }
}
