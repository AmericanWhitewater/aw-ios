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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if DefaultsManager.onboardingCompleted {
            performSegue(withIdentifier: Segue.alreadyOnboarded.rawValue, sender: nil)
        } else {
            performSegue(withIdentifier: Segue.onboardingNeeded.rawValue, sender: nil)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        default:
            injectContextAndContainerToChildVC(segue: segue)
        }
    }
}
