import Foundation
import MapKit
import Contacts

class RunMapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let sectionSubtitle: String
    let coordinate: CLLocationCoordinate2D
    var imageName: String = ""
    let reach: Reach?
    
    
    init(title: String, sectionSubtitle: String, coordinate: CLLocationCoordinate2D, reach: Reach?) {
        self.title = title
        self.sectionSubtitle = sectionSubtitle
        self.reach = reach
        self.coordinate = coordinate
        
        if title.uppercased() == "Put-In".uppercased() {
            self.imageName = "mapPinHighSm"
        } else if title.uppercased() == "Take-Out".uppercased() {
            self.imageName = "runnablePin"
        } else {
            self.imageName = "lowPin"
        }

        //print("Chose ImageName: \(self.imageName)")

        super.init()
    }
    
    var subtitle: String? {
        return sectionSubtitle
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
