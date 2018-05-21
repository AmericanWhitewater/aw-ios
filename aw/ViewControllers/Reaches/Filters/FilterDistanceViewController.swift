import CoreData
import CoreLocation
import UIKit

class FilterDistanceViewController: UIViewController {
    @IBOutlet weak var howFarLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!

    var managedObjectContext: NSManagedObjectContext?

    let locationManager = CLLocationManager()

    var distance: Float! {
        didSet {
            setDistanceLabel()
        }
    }
    var locateTapped = false

    override func viewDidLoad() {
        super.viewDidLoad()

        howFarLabel.apply(style: .Text3)
        distanceLabel.apply(style: .Text2)
        currentLocationLabel.apply(style: .Text3)
        cityStateLabel.apply(style: .Text3)
        addressLabel.apply(style: .Text2)
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping

        updateButton.titleLabel?.apply(style: .Text3)
        updateButton.setTitleColor(.black, for: .normal)

        distance = DefaultsManager.distanceFilter

        slider.value = distance
        locationManager.delegate = self

        displayLocation()
    }

    fileprivate func setDistanceLabel() {
        if distance == 0.0 {
            distanceLabel.text = "Search anywhere"
        } else {
            distanceLabel.text = "\(Int(distance)) miles"
        }
    }

    @IBAction func distanceChanged(_ sender: UISlider) {
        distance = slider.value
    }

    @IBAction func updateLocationTapped(_ sender: Any) {
        locateTapped = true
        setupLocationUpdates()
    }
}

extension FilterDistanceViewController {
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

    func displayLocation() {
        let decoder = CLGeocoder()
        let location = CLLocation(latitude: DefaultsManager.latitude, longitude: DefaultsManager.longitude)
        decoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil,
                let placemarks = placemarks,
                let place = placemarks.first,
                let state = place.administrativeArea,
                let city = place.locality
                else {
                    self.cityStateLabel.text = "Unknown"
                    self.addressLabel.text = ""
                    return }
            self.cityStateLabel.text = "\(city), \(state)"

            guard let streetNumber = place.subThoroughfare,
                let street = place.thoroughfare,
                let postalCode = place.postalCode
                else {
                    self.addressLabel.text = ""
                    return
            }

            self.addressLabel.text = "\(streetNumber) \(street), \(city), \(state) \(postalCode)"
        }
    }
}

extension FilterDistanceViewController: FilterViewControllerType {
    func save() {
        DefaultsManager.distanceFilter = distance
    }
}

extension FilterDistanceViewController: MOCViewControllerType {
}

extension FilterDistanceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if locateTapped && status == .authorizedWhenInUse {
            updateLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        locationManager.stopUpdatingLocation()
        print("location updated")
        print(location)

        DefaultsManager.latitude = location.coordinate.latitude
        DefaultsManager.longitude = location.coordinate.longitude

        if let context = managedObjectContext {
            AWApiHelper.updateDistances(viewContext: context)
        }
        displayLocation()
    }
}
