//
//  UISearchBar+BGColor.swift
//  American Whitewater
//
//  Created by David Nelson on 10/31/19.
//  Copyright © 2019 American Whitewater. All rights reserved.
//

import UIKit
import Foundation

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
