import UIKit
import MapKit
import Foundation
import CoreLocation

class Location {
    static let shared = Location()
    private init() {}
    
    // User takes an action that requires location, like clicking on the my location button.
    func checkLocationStatusOnUserAction(manager: CLLocationManager) -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            showLocationDeniedMessage()
        case .restricted:
            // TODO: should this also show the location denied message?
            // (it indicates that location services aren't available, but probably for circumstances the user can't control)
            break
        
        @unknown default:
            break
        }
        
        return false
    }

    // App needs location data, but not from a direct user action.
    func checkLocationStatusInBackground(manager: CLLocationManager) -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
        
        return false
    }

    func showLocationDeniedMessage() {
        DuffekDialog.shared.showStandardDialog(title: "Location not enabled", message: "We are unable to use your current location. Please update your settings to use this feature.", buttonTitle: "Change Settings", buttonFunction: {
            
            // take user to change their settings
            if let bundleId = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }, cancelFunction: {})
    }
    
    func hasLocation(mapView: MKMapView) -> Bool {
        return mapView.userLocation.coordinate.latitude != 0 &&
        mapView.userLocation.coordinate.longitude != 0
    }
}
