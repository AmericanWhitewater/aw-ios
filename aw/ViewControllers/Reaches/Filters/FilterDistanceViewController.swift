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
    
    var distance: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distance = DefaultsManager.distanceFilter

        setDistanceLabel()
        
        slider.value = distance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setDistanceLabel() {
        if distance == 0.0 {
            distanceLabel.text = "Search anywhere"
        } else {
            distanceLabel.text = "\(Int(distance)) miles"
        }
    }
    
    @IBAction func distanceChanged(_ sender: UISlider) {
        distance = slider.value
        setDistanceLabel()
    }
}

extension FilterDistanceViewController: FilterViewControllerType {
    func save() {
        DefaultsManager.distanceFilter = distance
    }
}
