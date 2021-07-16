
import UIKit
import Foundation

extension UISegmentedControl {

    func fallBackToPreIOS13Layout(using tintColor: UIColor) {
        if #available(iOS 13, *) {
            let backGroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
            let dividerImage = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))

            setBackgroundImage(backGroundImage, for: .normal, barMetrics: .default)
            setBackgroundImage(dividerImage, for: .selected, barMetrics: .default)

            setDividerImage(dividerImage,
                            forLeftSegmentState: .normal,
                            rightSegmentState: .normal, barMetrics: .default)

            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor

            setTitleTextAttributes([.foregroundColor: tintColor], for: .normal)
            setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        } else {
            self.tintColor = tintColor
        }
    }
}
