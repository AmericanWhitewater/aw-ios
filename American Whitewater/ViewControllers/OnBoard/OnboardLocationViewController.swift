/*
 The main entry point for the app is the TabViewController.
 On load the app checks if onboarding needs to take place:
 -- YES: it shows this modal view over the whole screen
 -- NO: it continues as normal
 The design for this view is handled entirely in Interface Builder
*/

import UIKit
import CoreLocation
import AlamofireNetworkActivityIndicator

class OnboardLocationViewController: UIViewController {

    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var locationImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var userLocation:CLLocation?
    
    var referenceViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This controller is the presentation context for any further modal presentations, like the location denied alert
        definesPresentationContext = true

        // setup style elements
        nextButton.layer.cornerRadius = 22.5
        
        // For presenting dialogs
        self.locationManager.delegate = self
    }
    
    /*
     zipCodeChanged(_ textField: UITextField)
     Handled changes in the zipCodeTextField and responds based on
     user entering their location manually
    */
    @IBAction func zipCodeChanged(_ textField: UITextField) {
        
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            nextButton.setTitle("Use Your Current Location", for: .normal)
            locationImageView.isHidden = false
        } else if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 5 {
            nextButton.setTitle("Use Entered Zipcode", for: .normal)
            locationImageView.isHidden = true
        } else {
            nextButton.setTitle("Enter Full Zipcode", for: .normal)
            locationImageView.isHidden = true
        }
        
        if textField.text!.count > 5 {
            let text = textField.text!
            textField.text = String(text.prefix(5))
        }
    }
    
    /*
     nextButtonPressed(_ sender: Any)
     When user presses next the app decides to grab their
     location automatically or it'll use any manually entered
     zip code to find the users default region
    */
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if nextButton.titleLabel?.text == "Use Your Current Location" {
            if Location.shared.checkLocationStatusOnUserAction(manager: locationManager) {
                locationManager.startUpdatingLocation()
            }
        } else if nextButton.titleLabel?.text == "Use Entered Zipcode" {
            
            // Geocode the zip code so we can get the region from the
            // administrative Area property
            let decoder = CLGeocoder()
            decoder.geocodeAddressString(zipcodeTextField.text!) { (placemarks, error) in
                guard error == nil,
                    let placemarks = placemarks,
                    let place = placemarks.first,
                    let coordinate = place.location?.coordinate else {
                        
                        // some sort of error so show message and reset view
                        DuffekDialog.shared.showOkDialog(title: "Unable to Find Location", message: "We are unable to find that location. Please check your connection or enter a new zip code to try again.")
                        self.zipcodeTextField.text = ""
                        self.nextButton.setTitle("Use Your Current Location", for: .normal)
                        self.locationImageView.isHidden = false
                        return
                }
                
                self.updateDefaults(
                    coordinate: coordinate,
                    regionCodes: self.regionCodes(placemarks: placemarks)
                )
                
                // dismiss this view controller and tell the referencing ViewController to refresh
                // AWTODO: Post a notification about this instead of coupling to the runs list controller
                self.dismiss(animated: true, completion: {
                    if let viewVC = self.referenceViewController as? RunsListViewController {
                        viewVC.updateData()
                    }
                })
            }
        }
    }
    
    /// Make all the changes to DefaultsManager that are the result of this
    /// Giving a location in onboarding indicates the filters should reset to the default distance filter
    /// That should match the user's expectation as they exit onboarding: they gave a location, and the app will show things around that location
    private func updateDefaults(coordinate: CLLocationCoordinate2D, regionCodes: [String]? = nil) {
        var filters = Filters.defaultByDistanceFilters
        
        // Set the region code if available, but otherwise avoid clobbering anything that was already set
        filters.regionsFilter = regionCodes ?? DefaultsManager.shared.filters.regionsFilter
        
        DefaultsManager.shared.filters = filters
        DefaultsManager.shared.coordinate = coordinate
        DefaultsManager.shared.onboardingCompleted = true
        
        // FIXME: why is this the onboarding controller's job?
        DefaultsManager.shared.appVersion = Double( (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "" ) ?? 0.0
    }
    
    private func regionCodes(placemarks: [CLPlacemark]?) -> [String]? {
        guard
            let placemark = placemarks?.first,
            let adminArea = placemark.administrativeArea,
            let region = Region.regionByCode(code: "st\(adminArea)")
        else {
            return nil
        }
        
        return [region.code]
    }
}

extension OnboardLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        self.updateDefaults(
            coordinate: location.coordinate,
            regionCodes: nil
        )
        
        // Reverse geocode to set the regionsFilter
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard
                let self = self,
                let codes = self.regionCodes(placemarks: placemarks)
            else {
                return
            }
            
            DefaultsManager.shared.filters.regionsFilter = codes
        }
        
        // dismiss this modal view controller and tell the referencing ViewController to refresh
        // AWTODO: Post a notification about this instead of coupling to the runs list controller
        self.dismiss(animated: true, completion: {
            if let viewVC = self.referenceViewController as? RunsListViewController {
                viewVC.updateData()
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}
