//
//  UIImage+Color.swift
//  American Whitewater
//
//  Created by David Nelson on 11/22/19.
//  Copyright © 2019 American Whitewater. All rights reserved.
//

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
