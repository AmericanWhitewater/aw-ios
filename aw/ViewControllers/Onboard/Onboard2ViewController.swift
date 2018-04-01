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

class Onboard2ViewController: UIViewController, MOCViewControllerType {
    @IBOutlet weak var locationButton: UIButton!

    var managedObjectContext: NSManagedObjectContext?

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

        locationButton.mask?.clipsToBounds = true
        locationButton.layer.cornerRadius = 45/2
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
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension Onboard2ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // allow location updates
            print("Authorized to get location")
            updateLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        print(location)
        locationManager.stopUpdatingLocation()

        DefaultsManager.latitude = location.coordinate.latitude
        DefaultsManager.longitude = location.coordinate.longitude
        DefaultsManager.onboardingCompleted = true

        if let context = managedObjectContext {
            AWApiHelper.updateRegions(viewContext: context) {
                // nothing needed to callback since this screeen is going away
            }
        }

        performSegue(withIdentifier: Segue.onboardingCompleted.rawValue, sender: nil)
    }
}
