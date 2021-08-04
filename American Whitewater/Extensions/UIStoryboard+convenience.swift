//
//  UIStoryboard+static.swift
//  UIStoryboard+static
//
//  Created by Phillip Kast on 8/3/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /// The main storyboard, used for all the storyboard driven stuff in the app
    static var main: UIStoryboard { UIStoryboard(name: "Main", bundle: nil) }
}
