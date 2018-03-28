//
//  Onboard2ViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/28/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import CoreLocation
import UIKit

class Onboard2ViewController: UITabBarController, MOCViewControllerType {

    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectContextAndContainerToChildVC(segue: segue)
    }

    @IBAction func allowLocationPressed(_ sender: Any) {
        setupLocationUpdates()
    }
}

// MARK: - Extension
extension Onboard2ViewController {
    func initialize() {
        locationManager.delegate = self
    }

    func setupLocationUpdates() {
        let authStatus = CLLocationManager.authorizationStatus()

        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            updateLocation()
        default:
            break
        }
    }

    func updateLocation() {
        // soon
    }
}

// MARK: - CLLocationManagerDelegate
extension Onboard2ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // allow location updates
            print("Authorized to get location")
        }
    }
}
