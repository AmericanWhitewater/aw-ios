//
//  UIImage+AsyncURLLoad.swift
//  American Whitewater
//
//  Created by David Nelson on 5/15/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

extension UIImageView {
    
    func load(url: URL) {
        AF.request(url).responseImage { (response) in
            if case .success(let image) = response.result {
                self.image = image
            } else {
                print("Unable to load image at URL: \(url.string)")
            }
        }
    }
    
}
