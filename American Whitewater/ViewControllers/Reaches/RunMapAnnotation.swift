import Foundation
import MapKit
import Contacts

class RunMapAnnotation: NSObject, MKAnnotation {
    enum Kind {
        case putin
        case takeout
        case rapid(Rapid)
    }
    
    let kind: Kind
    let title: String?
    let sectionSubtitle: String
    let coordinate: CLLocationCoordinate2D
    
    init(kind: Kind, title: String, sectionSubtitle: String, coordinate: CLLocationCoordinate2D) {
        self.kind = kind
        self.title = title
        self.sectionSubtitle = sectionSubtitle
        self.coordinate = coordinate

        super.init()
    }
    
    var subtitle: String? {
        return sectionSubtitle
    }
    
    var imageName: String {
        switch kind {
        case .putin: return "mapPinHighSm"
        case .takeout: return "runnablePin"
        case .rapid(_): return "lowPin"
        }
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
         
        let addressDict = [CNPostalAddressStreetKey: self.title!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title ?? "Unknown"
      
        return mapItem
    }
}
