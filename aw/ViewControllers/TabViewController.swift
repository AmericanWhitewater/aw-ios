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
    var persistentContainer: NSPersistentContainer?

    override func viewDidLoad() {
        super.viewDidLoad()

        for childVC in childViewControllers {
            if let navVC = childVC as? UINavigationController, var destinationVC = navVC.childViewControllers[0] as? MOCViewControllerType {
                destinationVC.managedObjectContext = managedObjectContext
                destinationVC.persistentContainer = persistentContainer
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
