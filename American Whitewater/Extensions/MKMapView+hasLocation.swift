import Foundation
import MapKit

extension MKMapView {
    var hasLocation: Bool {
        userLocation.coordinate.latitude != 0 && userLocation.coordinate.longitude != 0
    }
}
