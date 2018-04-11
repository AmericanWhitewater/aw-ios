import Foundation
import MapKit

class RunAnnotation: NSObject, MKAnnotation {
    let latitude: Double
    let longitude: Double
    let title: String?

    init(latitude: Double, longitude: Double, title: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
    }

    var coordinate: CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if CLLocationCoordinate2DIsValid(coordinate) {
            return coordinate
        } else {
            print("Invalid coordinates")
            return kCLLocationCoordinate2DInvalid
        }
    }
}
