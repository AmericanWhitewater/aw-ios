//
//  MOCViewControllerType.swift
//  ResinDemoApp
//
//  Created by Alex Kerney on 2/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation
import UIKit

protocol MOCViewControllerType {
    var managedObjectContext: NSManagedObjectContext? { get set }
}

extension MOCViewControllerType {
    func injectContextAndContainerToChildVC(segue: UIStoryboardSegue) {
        guard var destinationVC = segue.destination as? MOCViewControllerType else { return }

        destinationVC.managedObjectContext = managedObjectContext
    }

    func injectContextAndContainerToNavChildVC(segue: UIStoryboardSegue) {
        guard let navVC = segue.destination as? UINavigationController,
            var destinationVC = navVC.viewControllers[0] as? MOCViewControllerType else { return }

        destinationVC.managedObjectContext = managedObjectContext
    }
}
