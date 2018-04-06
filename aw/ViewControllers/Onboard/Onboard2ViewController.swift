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
    @IBOutlet weak var buttonText: UILabel!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var locationArrow: UIImageView!

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

    @IBAction func zipcodeChanged(_ sender: UITextField) {
        if sender.text?.count == 0 {
            toggleLayout(.noZip)
        } else if sender.text?.count == 5 {
            toggleLayout(.fullZip)
        } else {
            toggleLayout(.partialZip)
        }
    }

    @IBAction func zipcodeContinueHit(_ sender: UITextField) {
        locationFromZip()
    }

    @IBAction func allowLocationPressed(_ sender: Any) {
        if zipcodeField.text?.count == 0 {
            setupLocationUpdates()
        } else if zipcodeField.text?.count == 5 {
            locationFromZip()
        }

    }
}

// MARK: - Extension
extension Onboard2ViewController {
    func initialize() {
        locationManager.delegate = self
        
        if let context = managedObjectContext {
            AWArticleAPIHelper.updateArticles(viewContext: context) {
                print("fetched articles")
                print(DefaultsManager.articlesLastUpdated as Any)
            }
        }
    }

    func saveLocationAndSegue(location: CLLocationCoordinate2D) {
        DefaultsManager.latitude = location.latitude
        DefaultsManager.longitude = location.longitude
        DefaultsManager.onboardingCompleted = true
        DefaultsManager.distanceFilter = 100

        if let context = managedObjectContext {
            AWApiHelper.updateRegions(viewContext: context) {
                // nothing needed to callback since this screeen is going away
            }
        }

        performSegue(withIdentifier: Segue.onboardingCompleted.rawValue, sender: nil)
    }

    func locationFromZip() {
        guard zipcodeField.text?.count == 5,
            let zipcode = zipcodeField.text else { return }

        let decoder = CLGeocoder()
        toggleLayout(.locating)
        decoder.geocodeAddressString(zipcode) { (placemarks, error) in
            guard error == nil,
                let placemarks = placemarks,
                let place = placemarks.first,
                let coordinates = place.location?.coordinate else {
                self.toggleLayout(.fullZip)
                return
            }
            self.saveLocationAndSegue(location: coordinates)
        }
    }

    enum LocationState {
        case noZip, partialZip, fullZip, locating
    }

    func toggleLayout(_ zipEntry: LocationState) {
        switch zipEntry {
        case .noZip:
            locationButton.isEnabled = true
            orLabel.isHidden = false
            buttonText.textColor = UIColor(named: "font_clickable")
            buttonText.text = "Use your current location?"
            locationArrow.isHidden = false
            zipcodeField.isEnabled = true
        case .partialZip:
            locationButton.isEnabled = false
            orLabel.isHidden = true
            buttonText.textColor = UIColor(named: "font_grey")
            buttonText.text = "Confirm location"
            locationArrow.isHidden = true
            zipcodeField.isEnabled = true
        case .fullZip:
            locationButton.isEnabled = true
            orLabel.isHidden = true
            buttonText.textColor = UIColor(named: "font_clickable")
            buttonText.text = "Confirm location"
            locationArrow.isHidden = true
            zipcodeField.isEnabled = true
        case .locating:
            locationButton.isEnabled = false
            buttonText.textColor = UIColor(named: "font_grey")
            buttonText.text = "Locating..."
            zipcodeField.isEnabled = false
        }
    }

    func setupLocationUpdates() {
        toggleLayout(.locating)
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

        saveLocationAndSegue(location: location.coordinate)
    }
}
