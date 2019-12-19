//
//  UISearchBar+UITextFieldColor.swift
//  American Whitewater
//
//  Created by David Nelson on 11/20/19.
//  Copyright © 2019 American Whitewater. All rights reserved.
//

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
