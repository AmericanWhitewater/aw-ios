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

class OnboardLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var locationImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var userLocation:CLLocation?
    
    var referenceViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup style elements
        nextButton.layer.cornerRadius = 22.5
        
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
            
            // check for requesting user location permissions
            // ask if they don't have it and continue if they do
            setupLocationUpdates()
            
        } else if nextButton.titleLabel?.text == "Use Entered Zipcode" {
            
            // Geocode the zip code so we can get the region from the
            // administrative Area property
            let decoder = CLGeocoder()
            decoder.geocodeAddressString(zipcodeTextField.text!) { (placemarks, error) in
                guard error == nil,
                    let placemarks = placemarks,
                    let place = placemarks.first,
                    let coordinates = place.location?.coordinate else {
                        
                        // some sort of error so show message and reset view
                        DuffekDialog.shared.showOkDialog(title: "Unable to Find Location", message: "We are unable to find that location. Please check your connection or enter a new zip code to try again.")
                        self.zipcodeTextField.text = ""
                        self.nextButton.setTitle("Use Your Current Location", for: .normal)
                        self.locationImageView.isHidden = false
                        return
                }
                
                print("Location found: \(coordinates.latitude), \(coordinates.longitude)")
                print("Place: \(String(describing: place.administrativeArea))")
                
                DefaultsManager.latitude = coordinates.latitude
                DefaultsManager.longitude = coordinates.longitude
                DefaultsManager.distanceFilter = 100
                DefaultsManager.onboardingCompleted = true
                DefaultsManager.appVersion = Double( (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "" ) ?? 0.0
                
                // grab and store the region code from admin area
                if let adminArea = place.administrativeArea, let region = Region.regionByCode(code: "st\(adminArea)") {
                    DefaultsManager.regionsFilter = [region.code]
                }
                
                // dismiss this view controller and tell the referencing ViewController to refresh
                // NOTE: this could be a delegate or protocol if we want to get fancier
                self.dismiss(animated: true, completion: {
                    if let viewVC = self.referenceViewController as? RunsListViewController {
                        viewVC.refresh()
                    }
                })
            }
        }
    }

    /*
     setupLocationUpdates()
     Check if the user has agreed to accept location permissions
     IF NOT: we ask them to reconsider and make it easy by taking them
      to the settings view
     IF YES: we move on and grab their location as requested
    */
    func setupLocationUpdates() {
        self.locationManager.delegate = self

        let authStatus = CLLocationManager.authorizationStatus()
        
        switch authStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            case .authorizedWhenInUse:
                print("authorized")
                // start updating location info
                if CLLocationManager.locationServicesEnabled() {
                    print("Starting updating Location")
                    locationManager.startUpdatingLocation()
                }
            
            case .denied:
                DuffekDialog.shared.showStandardDialog(title: "Permission Denied", message: "You chose to deny this app location permissions so we are unable to use your current location. Please update your settings and try again.", buttonTitle: "Change Settings", buttonFunction: {
                    
                    // take user to change their settings
                    if let bundleId = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                }, cancelFunction: {})
            
            default:
                break
        }
    }
    
    /*
     locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
     handles location updates and when we get the latest update we use it to find the users location
     and zip code so we can find a default region for them to see
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {

            print("Got the latest location: \(location.debugDescription)")
            // stop updating
            locationManager.stopUpdatingLocation()

            // store the location for future use
            DefaultsManager.latitude = location.coordinate.latitude
            DefaultsManager.longitude = location.coordinate.longitude
            DefaultsManager.distanceFilter = 100
            DefaultsManager.onboardingCompleted = true
            DefaultsManager.appVersion = Double( (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "" ) ?? 0.0
            
            // reverse geocode the users location so we can get the admin area so we can request this location first
            let decoder = CLGeocoder()
            decoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil {
                    if let placemark = placemarks?.first {
                        if let adminArea = placemark.administrativeArea, let region = Region.regionByCode(code: "st\(adminArea)") {

                            DefaultsManager.regionsFilter = [region.code]
                        }
                    }
                }
            }
            
            // dismiss this modal view controller and tell the referencing ViewController to refresh
            // NOTE: this could be a delegate or protocol if we want to get fancier
            self.dismiss(animated: true, completion: {
                if let viewVC = self.referenceViewController as? RunsListViewController {
                    viewVC.refresh()
                }
            })
        }
    }
    
    // if the user changed their settings we need to react to this
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}