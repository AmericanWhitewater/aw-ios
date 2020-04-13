import UIKit
import Foundation

extension UISearchBar {
    public var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        }

        guard let firstSubview = subviews.first else {
            assertionFailure("Could not find text field")
            return nil
        }

        for view in firstSubview.subviews {
            if let textView = view as? UITextField {
                return textView
            }
        }

        assertionFailure("Could not find text field")

        return nil
    }
}
