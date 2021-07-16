//
//  ProgressViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 6/3/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var blackBackgroundTintView: UIView!
    @IBOutlet weak var blackRectBackgroundView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var messageToDisplay: String = "Loading..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blackRectBackgroundView.layer.cornerRadius = 15
        blackRectBackgroundView.clipsToBounds = true
        
        messageLabel.text = messageToDisplay
    }
}
