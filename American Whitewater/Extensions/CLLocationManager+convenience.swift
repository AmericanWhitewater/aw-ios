import Foundation
import CoreLocation

extension CLLocationManager {
    static var isAuthorized: Bool {
        switch authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined, .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    static var isDenied: Bool {
        authorizationStatus() == .denied
    }
}
