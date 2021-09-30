/*
 The main entry point for the app is the TabViewController.
 On load the app checks if onboarding needs to take place:
 -- YES: it shows this modal view over the whole screen
 -- NO: it continues as normal
 The design for this view is handled entirely in Interface Builder
*/

import UIKit
import CoreLocation

class OnboardLocationViewController: UIViewController {
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var locationImageView: UIImageView!
    
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This controller is the presentation context for any further modal presentations, like the location denied alert
        definesPresentationContext = true

        // setup style elements
        nextButton.layer.cornerRadius = 22.5
        
        // For presenting dialogs
        locationManager.delegate = self
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
    
    //
    // MARK: - Next button/finishing
    //
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if nextButton.titleLabel?.text == "Use Your Current Location" {
            continueForLocation()
        } else if nextButton.titleLabel?.text == "Use Entered Zipcode" {
            continueForZipcode()
        }
    }
    
    fileprivate func continueForLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.isAuthorized {
            locationManager.startUpdatingLocation()
        } else if CLLocationManager.isDenied {
            present(LocationHelper.locationDeniedAlert(), animated: true)
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

    fileprivate func continueForZipcode() {
        // Geocode the zip code so we can get the region from the
        // administrative Area property
        geoCoder.geocodeAddressString(zipcodeTextField.text!) { (placemarks, error) in
            guard error == nil,
                  let placemarks = placemarks,
                  let place = placemarks.first,
                  let coordinate = place.location?.coordinate else {
                      let alert = UIAlertController(
                        title: "Unable to Find Location",
                        message: "We are unable to find that location. Please check your connection or enter a new zip code to try again.",
                        preferredStyle: .alert)
                      alert.addAction(.init(title: "Dismiss", style: .default, handler: nil))
                      self.present(alert, animated: true)
                      
                      self.zipcodeTextField.text = ""
                      self.nextButton.setTitle("Use Your Current Location", for: .normal)
                      self.locationImageView.isHidden = false
                      return
                  }
            
            self.updateDefaults(
                coordinate: coordinate,
                regionCodes: self.regionCodes(placemarks: placemarks)
            )

            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension OnboardLocationViewController: CLLocationManagerDelegate {
    /// When we get the latest update we use it to find the users location and zip code so we can find a default region for them to see
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

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

        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}
