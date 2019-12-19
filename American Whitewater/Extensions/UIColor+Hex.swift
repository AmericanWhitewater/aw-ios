//
//  UIColor+Hex.swift
//  Duffek Mobile
//
//  Created by David Nelson on 8/22/18.
//  Copyright © 2019 Duffek Mobile. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // List of BrewFund Specific Colors
    struct AW {
        static let Low = UIColor(webHex: 0xff8684)
        static let Med = UIColor(webHex: 0x59e68d)
        static let High = UIColor(webHex: 0x5dace1)
        static let Unknown = UIColor(webHex: 0x5a6872)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(webHex:Int) {
        self.init(red:(webHex >> 16) & 0xff, green:(webHex >> 8) & 0xff, blue:webHex & 0xff)
    }
}


