//
//  AboutAWViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class AboutAWViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var missionView: UIView!
    var stewardshipView: UIView!
    var fundingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        missionView = AboutAWMissionViewController().view
        stewardshipView = AboutAWStewardshipViewController().view
        fundingView = AboutAWFundingViewController().view
        
        containerView.addSubview(stewardshipView)
        containerView.addSubview(fundingView)
        
        // add mission view last, so it shows up on load
        containerView.addSubview(missionView)

        // make our segmented control view blend in with the navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            containerView.bringSubview(toFront: missionView)
        case 1:
            containerView.bringSubview(toFront: stewardshipView)
        case 2:
            containerView.bringSubview(toFront: fundingView)
        default:
            break
        }
    }
}
