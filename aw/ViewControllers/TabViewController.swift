//
//  TabViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/26/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

class TabViewController: UITabBarController, MOCViewControllerType {
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        // MARK: - Inject CoreData dependencies
        for childVC in childViewControllers {
            if let navVC = childVC as? UINavigationController,
                var destinationVC = navVC.childViewControllers[0] as? MOCViewControllerType {
                destinationVC.managedObjectContext = managedObjectContext
            }
        }
    }
}

// MARK: - TabBarControllerDelegate
extension TabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {

        if let navController = viewControllers?[selectedIndex] as? UINavigationController {
            for controller in navController.viewControllers.compactMap({ $0 as? RunListTableViewController }) {
                controller.dismissSearch()
            }
        }
        return true
    }
}
