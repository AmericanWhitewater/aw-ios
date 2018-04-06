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

struct AWReachGauge: Codable {
    let gaugeID: Int
    let gaugeReading: String?
    let rangeComment: String?

    enum CodingKeys: String, CodingKey {
        case gaugeID = "gauge_id"
        case gaugeReading = "gauge_reading"
        case rangeComment = "range_comment"
    }
}

struct AWRapid: Codable {
    let name: String?
    let description: String?
    let rapidid: Int
    let difficulty: String?
    let rlat: String?
    let rlon: String?
}

struct AWReachMain: Codable {
    let info: AWReachInfo
}

struct AWReachDetailResponse: Codable {
    let view: Sub

    enum CodingKeys: String, CodingKey {
        case view = "CContainerViewJSON_view"
    }
}

extension AWReachDetailResponse {
    struct Sub: Codable {
        let main: Main
        let rapids: RapidsView

        enum CodingKeys: String, CodingKey {
            case main = "CRiverMainGadgetJSON_main"
            case rapids = "CRiverRapidsGadgetJSON_view-rapids"
        }
    }
}

extension AWReachDetailResponse.Sub {
    struct RapidsView: Codable {
        let rapids: [AWRapid]
    }
    struct Main: Codable {
        let info: AWReachInfo
        let gauges: [AWReachGauge]
        //let guagesummary: GuageSummary
    }
}

extension AWReachDetailResponse.Sub.Main {
    struct GuageSummary: Codable {
        let gauges: [String: AWReachGauge]
    }
}
