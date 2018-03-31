//
//  Reach.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation
import MapKit

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

    var annotation: ReachAnnotation {
        let title: String?
        if let difficulty = difficulty, let name = name {
            title = "\(name) (\(difficulty))"
        } else {
            title = name
        }
        return ReachAnnotation(lat: putInLat, lon: putInLon, id: id, title: title, subtitle: section, condition: condition)
    }

    var photoUrl: String? {
        if photoId != 0 {
            return "https://www.americanwhitewater.org/photos/archive/medium/\(photoId).jpg"
        } else {
            return nil
        }
    }
}
