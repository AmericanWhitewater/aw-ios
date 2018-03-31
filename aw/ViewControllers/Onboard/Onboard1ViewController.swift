//
//  Onboard1ViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

class Onboard1ViewController: UIViewController, MOCViewControllerType {

    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        DefaultsManager.latitude = 43.6570
        DefaultsManager.longitude = -70.9667
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        performSegue(withIdentifier: Segue.alreadyOnboarded.rawValue, sender: nil)
        //performSegue(withIdentifier: Segue.onboardingNeeded.rawValue, sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        //case Segue.alreadyOnboarded.rawValue:
        //    injectContextAndContainerToTabChildVC(segue: segue)
        default:
            injectContextAndContainerToChildVC(segue: segue)
        }
    }
}
