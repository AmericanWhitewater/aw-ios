import Foundation
import MapKit

class RunAnnotation: NSObject, MKAnnotation {
    let latitude: Double
    let longitude: Double
    let title: String?
    let subtitle: String?
    let type: AnnotationType

    init(latitude: Double, longitude: Double, title: String?, subtitle: String?, type: AnnotationType) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
        self.type = type
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

    var icon: UIImage? {
        switch type {
        case .putIn:
            return UIImage(named: "runnablePin")
        case .takeOut:
            return UIImage(named: "frozenPin")
        case .gage:
            return UIImage(named: "highPin")
        case .rapid:
            return UIImage(named: "lowPin")
        }
    }

    enum AnnotationType {
        case putIn, takeOut, rapid, gage
    }
}
