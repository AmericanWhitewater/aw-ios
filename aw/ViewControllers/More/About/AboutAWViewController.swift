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

    @IBOutlet weak var missionView: UIView!
    @IBOutlet weak var stewardshipView: UIView!
    @IBOutlet weak var fundingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // make our segmented control view blend in with the navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")

        setViewShown(view: .mission)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setViewShown(view: AboutViews.mission)
        case 1:
            setViewShown(view: AboutViews.stewardship)
        case 2:
            setViewShown(view: AboutViews.funding)
        default:
            break
        }
    }
}

enum AboutViews: String {
    case mission, stewardship, funding
}

extension AboutAWViewController {
    func setViewShown(view: AboutViews) {
        switch view {
        case .mission:
            missionView.isHidden = false
            stewardshipView.isHidden = true
            fundingView.isHidden = true
        case .stewardship:
            missionView.isHidden = true
            stewardshipView.isHidden = false
            fundingView.isHidden = true
        case .funding:
            missionView.isHidden = true
            stewardshipView.isHidden = true
            fundingView.isHidden = false
        }
    }
}
