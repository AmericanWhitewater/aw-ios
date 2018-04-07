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
        let con = Condition.fromApi(condition: condition ?? "")

        return con.color
    }

    var icon: UIImage? {
        return Condition.fromApi(condition: condition ?? "").icon
    }

    var sectionCleanedHTML: String? {
        if let section = section,
            let data = section.data(using: .utf8),
            let html = try? NSMutableAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil) {
            return html.string
        } else {
            return nil
        }
    }

    var distanceFormatted: String? {
        return distance != 0 ? "\(Int(distance)) mi" : ""
    }

    var updatedString: String? {
        guard let date = detailUpdated else { return nil }
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.doesRelativeDateFormatting = true

        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"

        return "\(dateFormat.string(from: date)) at \(timeFormat.string(from: date))"
    }

    var photoUrl: String? {
        if photoId != 0 {
            return "https://www.americanwhitewater.org/photos/archive/medium/\(photoId).jpg"
        } else {
            return nil
        }
    }

    var runnable: String {
        if let rcString = rc {
            return Runnable.fromRc(rcString: rcString)
        } else {
            return ""
        }
    }

    var url: URL? {
        return URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\( id )/")
    }
}

// MARK: - MKAnnotation
extension Reach: MKAnnotation {
    public var title: String? {
        if let difficulty = difficulty, let name = name {
            return "\(name) (\(difficulty))"
        } else {
            return name
        }
    }

    public var subtitle: String? {
        return sectionCleanedHTML
    }

    public var coordinate: CLLocationCoordinate2D {
        guard let lat = putInLat, let latitude = Double(lat),
            let lon = putInLon, let longitude = Double(lon) else {
                print("\(id) has invalid coordinates")
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
