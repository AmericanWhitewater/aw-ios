//
//  ReachAnnotation.swift
//  aw
//
//  Created by Alex Kerney on 3/30/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation
import MapKit

class ReachAnnotation: NSObject {
    let lat: String?
    let lon: String?
    //swiftlint:disable:next identifier_name
    let id: Int16
    let title: String?
    let subtitle: String?
    let condition: String?

    //swiftlint:disable:next identifier_name
    init(lat: String?, lon: String?, id: Int16, title: String?, subtitle: String?, condition: String?) {
        self.lat = lat
        self.lon = lon
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.condition = condition
    }

    var icon: UIImage? {
        guard let condition = condition else {
            return nil
        }
        return Condition.fromApi(condition: condition).icon
    }
}

extension ReachAnnotation: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        guard let lat = lat, let latitude = Double(lat), let lon = lon, let longitude = Double(lon) else {
            print("\(id) has invalid coordinates, can't make Doubles")
            return kCLLocationCoordinate2DInvalid
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if CLLocationCoordinate2DIsValid(coordinate) {
            return coordinate
        } else {
            print("\(id) has invalid coordinates")
            return kCLLocationCoordinate2DInvalid
        }
    }
}
