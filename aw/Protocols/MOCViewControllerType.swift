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
    var persistentContainer: NSPersistentContainer? { get set }
}

extension MOCViewControllerType {
    func injectContextAndContainerToChildVC(segue: UIStoryboardSegue) {
        guard var destinationVC = segue.destination as? MOCViewControllerType else { return }
        
        destinationVC.managedObjectContext = managedObjectContext
        destinationVC.persistentContainer = persistentContainer
    }
    
    func injectContextAndContainerToNavChildVC(segue: UIStoryboardSegue) {
        guard let navVC = segue.destination as? UINavigationController,
            var destinationVC = navVC.viewControllers[0] as? MOCViewControllerType else { return }
        
        destinationVC.managedObjectContext = managedObjectContext
        destinationVC.persistentContainer = persistentContainer
    }
    
    func injectContextAndContainerToTabChildVC(segue: UIStoryboardSegue) {
        guard let tabVC = segue.destination as? UITabBarController else { return }
        
        for childVC in tabVC.childViewControllers {
            if var childVC = childVC as? MOCViewControllerType {
                childVC.managedObjectContext = managedObjectContext
                childVC.persistentContainer = persistentContainer
            }
        }
    }
}
