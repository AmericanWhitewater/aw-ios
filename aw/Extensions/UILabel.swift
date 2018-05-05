import UIKit

extension UILabel {
    func apply(style: FontStyle) {
        font = style.font()
        textColor = style.color()
    }
}
