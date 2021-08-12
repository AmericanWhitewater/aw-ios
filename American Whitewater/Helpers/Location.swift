import UIKit
import Foundation
import CoreLocation

class Location {
    static let shared = Location()
    private init() {}
    
    // App needs location data, but not from a direct user action.
    func checkLocationStatus(manager: CLLocationManager, notifyDenied: Bool = false) -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            if notifyDenied {
                showLocationDeniedMessage()
            }
        case .restricted:
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
}
