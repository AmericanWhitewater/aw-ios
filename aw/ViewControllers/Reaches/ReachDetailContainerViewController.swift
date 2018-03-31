//
//  ReachDetailContainerViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/31/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

enum SubViews {
    case detail, map
}

class ReachDetailContainerViewController: UIViewController {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mapView: UIView!
    
    var managedObjectContext: NSManagedObjectContext?
    var reach: Reach?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

}

extension ReachDetailContainerViewController {
    func initialize() {
        initializeChildVCs()
        setupSegmentedControl()

        showView(name: .detail)
    }

    func initializeChildVCs() {
        for childVC in childViewControllers {
            print("childVC")
            if var childVC = childVC as? RunDetailViewControllerType {
                print("Run detail type")
                childVC.reach = reach
            }
            if var childVC = childVC as? MOCViewControllerType {
                print("MOC type")
                childVC.managedObjectContext = managedObjectContext
            }
        }
    }

    func setupSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["Details", "Map"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
    }

    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            showView(name: .map)
        } else {
            showView(name: .detail)
        }
    }

    func showView(name: SubViews) {
        switch name {
        case .map:
            detailView.isHidden = true
            mapView.isHidden = false
        default:
            detailView.isHidden = false
            mapView.isHidden = true
        }
    }
}

extension ReachDetailContainerViewController: MOCViewControllerType {

}
