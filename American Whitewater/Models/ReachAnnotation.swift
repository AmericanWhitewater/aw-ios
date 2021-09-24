import Foundation
import CoreLocation
import MapKit

/// Wraps a Reach and provides MKAnnotation conformance
class ReachAnnotation: NSObject, MKAnnotation {
    let reach: Reach
    
    init(_ reach: Reach) {
        self.reach = reach
        super.init()
    }
    
    public var title: String? {
        reach.title
    }

    public var subtitle: String? {
        reach.section ?? ""
    }
    
    public var coordinate: CLLocationCoordinate2D {
        guard
            let loc = reach.putIn,
            CLLocationCoordinate2DIsValid(loc.coordinate)
        else {
            return kCLLocationCoordinate2DInvalid
        }
        
        return loc.coordinate
    }
    
    public var imageName: String {
        if let condition = reach.condition {
            switch condition {
                case "low":
                    return "mapPinLowSm"
                case "med":
                    return "mapPinRunningSm"
                case "high":
                    return "mapPinHighSm"
                default:
                    return "mapPinNoneSm"
            }
        } else {
            return "mapPinNoneSm"
        }
    }
}
