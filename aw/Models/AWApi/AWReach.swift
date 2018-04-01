//
//  AWApiStructures.swift
//  aw
//
//  Created by Alex Kerney on 4/1/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import MapKit
import Foundation
import UIKit

struct AWReach: Codable {
    let difficulty: String
    let condition: String
    //swiftlint:disable:next identifier_name
    let id: Int
    let name: String
    let putInLat: String?
    let putInLon: String?
    let lastGageReading: String?
    let section: String
    let unit: String?
    let takeOutLat: String?
    let takeOutLon: String?
    let state: String?
    let delta: String?

    enum CodingKeys: String, CodingKey {
        //swiftlint:disable:next identifier_name
        case id, name, section, unit, state, delta
        case difficulty = "class"
        case condition = "cond"
        case putInLat = "plat"
        case putInLon = "plon"
        case lastGageReading = "last_gauge_reading" // "reading_formatted"
        case takeOutLat = "tlat"
        case takeOutLon = "tlon"
    }

    func distanceFrom(location: CLLocation) -> Double? {
        guard let lat = putInLat, let latitude = Double(lat),
            let lon = putInLon, let longitude = Double(lon) else { return nil }

        let reachCoordinate = CLLocation(latitude: latitude, longitude: longitude)

        guard CLLocationCoordinate2DIsValid(reachCoordinate.coordinate) else { return nil }

        return reachCoordinate.distance(from: location)
    }
}

struct AWReachInfo: Codable {
    //swiftlint:disable:next identifier_name
    let id: Int //
    let abstract: String? //
    let avgGradient: Int16? //
    let photoId: Int32? //
    let length: String? //
    let maxGradient: Int16? //
    let description: String? //
    let shuttleDetails: String? //
    let zipcode: String? //

    enum CodingKeys: String, CodingKey {
        //swiftlint:disable:next identifier_name
        case id, abstract, length, description, zipcode
        case avgGradient = "avggradient"
        case photoId = "photoid"
        case maxGradient = "maxgradient"
        case shuttleDetails = "shuttledetails"
    }
}

struct AWReachMain: Codable {
    let info: AWReachInfo
}

struct AWReachDetailSubResponse: Codable {
    let main: AWReachMain

    enum CodingKeys: String, CodingKey {
        case main = "CRiverMainGadgetJSON_main"
    }
}

struct AWReachDetailResponse: Codable {
    let view: AWReachDetailSubResponse

    enum CodingKeys: String, CodingKey {
        case view = "CContainerViewJSON_view"
    }
}
