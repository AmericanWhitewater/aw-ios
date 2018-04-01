//
//  AWButton.swift
//  aw
//
//  Created by Alex Kerney on 4/1/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class AWButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        layer.masksToBounds = true
    }
}
