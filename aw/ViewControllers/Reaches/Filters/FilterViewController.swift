//
//  FilterViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var distanceView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make our segmented control view blend in with the navigation bar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        setViewShown(name: "region")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewShown(name: String) {
        switch name {
        case "region":
            regionView.isHidden = false
            classView.isHidden = true
            distanceView.isHidden = true
        case "class":
            regionView.isHidden = true
            classView.isHidden = false
            distanceView.isHidden = true
        case "distance":
            regionView.isHidden = true
            classView.isHidden = true
            distanceView.isHidden = false
        default:
            regionView.isHidden = false
            classView.isHidden = true
            distanceView.isHidden = true
        }
    }
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setViewShown(name: "region")
        case 1:
            setViewShown(name: "class")
        case 2:
            setViewShown(name: "distance")
        default:
            break
        }
    }
    
    @IBAction func cancelHit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneHit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        //let regionVC = regionView.subviews.first.responder
        for childVC in childViewControllers {
            guard let childVC = childVC as? FilterViewControllerType else { return }
            childVC.save()
        }
    }
}
