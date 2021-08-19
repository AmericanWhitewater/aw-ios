import UIKit
import Foundation

class LocationHelper {
    /// An alert controller with a permission denied message and an action opening the app's settings
    static func locationDeniedAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Location not enabled",
            message: "We are unable to use your current location. Please update your settings to use this feature.",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(
            title: "Change Settings",
            style: .default,
            handler: { _ in
                // take user to change their settings
                if let bundleId = Bundle.main.bundleIdentifier,
                    let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        ))
        
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        return alert 
    }
}
