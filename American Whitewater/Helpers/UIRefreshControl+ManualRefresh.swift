//
//  UIRefreshControl+ManualRefresh.swift
//  American Whitewater
//
//  Created by David Nelson on 5/13/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit
import Foundation

extension UIRefreshControl {

    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: false)
        }
        beginRefreshing()
        //sendActions(for: .valueChanged)
    }
    
}
