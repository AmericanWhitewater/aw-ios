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
    let lastGageUpdated: String?
    let section: String
    let unit: String?
    let takeOutLat: String?
    let takeOutLon: String?
    let state: String?
    let delta: String?
    //swiftlint:disable:next identifier_name
    let rc: String?
    let gageId: Int?
    let gageMetric: Int?

    enum CodingKeys: String, CodingKey {
        //swiftlint:disable:next identifier_name
        case id, name, section, unit, state, delta, rc
        case difficulty = "class"
        case condition = "cond"
        case putInLat = "plat"
        case putInLon = "plon"
        case lastGageReading = "last_gauge_reading"
        case lastGageUpdated = "last_gauge_updated"
        case takeOutLat = "tlat"
        case takeOutLon = "tlon"
        case gageId = "gauge_id"
        case gageMetric = "gauge_metric"
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
    let id: Int
    let abstract: String?
    let avgGradient: Int16?
    let photoId: Int32?
    let length: String?
    let maxGradient: Int16?
    let description: String?
    let shuttleDetails: String?
    let zipcode: String?

    enum CodingKeys: String, CodingKey {
        //swiftlint:disable:next identifier_name
        case id, abstract, length, description, zipcode
        case avgGradient = "avggradient"
        case photoId = "photoid"
        case maxGradient = "maxgradient"
        case shuttleDetails = "shuttledetails"
    }
}

struct AWReachGage: Codable {
    let gageID: Int
    let gageReading: String?
    let rangeComment: String?

    enum CodingKeys: String, CodingKey {
        case gageID = "gauge_id"
        case gageReading = "gauge_reading"
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
        let gages: [AWReachGage]
        //let gagesummary: GageSummary

        enum CodingKeys: String, CodingKey {
            case info
            case gages = "gauges"
            // case gageSummary = "guagesummary"
        }
    }
}

extension AWReachDetailResponse.Sub.Main {
    struct GageSummary: Codable {
        let gages: [String: AWReachGage]

        enum CodingKeys: String, CodingKey {
            case gages = "gauges"
        }
    }
}
