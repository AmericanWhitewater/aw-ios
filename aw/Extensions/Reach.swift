//
//  Reach.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation
import MapKit

extension Reach: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        // put in latitude and longitude are optional strings
        guard let lat = putInLat, let latitude = Double(lat), let lon = putInLon, let longitude = Double(lon) else {
            return kCLLocationCoordinate2DInvalid
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
extension Reach {

    var readingFormatted: String {
        guard let lastGuageReading = lastGageReading, let unit = unit else {
            //print(self.lastGageReading, self.unit)
            return "n/a"
        }
        return "\(lastGuageReading) \(unit)"
    }
    
    var color: UIColor {
        let con = AWApiHelper.conditionFromApi(condition: condition ?? "")
        
        return con.color
    }
}
