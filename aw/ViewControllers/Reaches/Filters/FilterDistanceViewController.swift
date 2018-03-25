//
//  FilterDistanceViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class FilterDistanceViewController: UIViewController {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDistanceLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setDistanceLabel() {
        if slider.value == 0.0 {
            distanceLabel.text = "Search anywhere"
        } else {
            distanceLabel.text = "\(Int(slider.value)) miles"
        }
    }
    
    @IBAction func distanceChanged(_ sender: UISlider) {
        setDistanceLabel()
    }
}
