import CoreData
import CoreLocation
import UIKit

class FilterDistanceViewController: UIViewController {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

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

        distance = DefaultsManager.distanceFilter

        slider.value = distance
        locationManager.delegate = self
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
    }
}
