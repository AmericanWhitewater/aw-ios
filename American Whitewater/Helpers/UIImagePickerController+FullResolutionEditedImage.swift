//
//  UIImagePickerController+FullResolutionEditedImage.swift
//  American Whitewater
//
//  Created by Phil Kast on 7/19/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import UIKit
import CoreGraphics

// See https://github.com/expo/expo/pull/9316, which this approach is based on
extension Dictionary where Key == UIImagePickerController.InfoKey {
    public func fullResolutionCroppedImage() -> UIImage? {
        guard
            let original = self[.originalImage] as? UIImage,
            let cropRect = (self[.cropRect] as? NSValue)?.cgRectValue,
            let cropped = original.cgImage?.cropping(to: cropRect)
        else {
            return self[.editedImage] as? UIImage
        }
        
        return UIImage(cgImage: cropped,
                       scale: original.scale,
                       orientation: original.imageOrientation
        )
    }
}
