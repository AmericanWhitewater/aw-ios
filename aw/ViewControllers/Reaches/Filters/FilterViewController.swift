//
//  FilterViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var regionView: UIView!
    var classView: UIView!
    var distanceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionView = FilterRegionViewController().view
        classView = FilterClassViewController().view
        distanceView = FilterDistanceViewController().view
        
        containerView.addSubview(distanceView)
        containerView.addSubview(classView)
        containerView.addSubview(regionView)
        

        // make our segmented control view blend in with the navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            containerView.bringSubview(toFront: regionView)
        case 1:
            containerView.bringSubview(toFront: classView)
        case 2:
            containerView.bringSubview(toFront: distanceView)
        default:
            break
        }
    }
}
