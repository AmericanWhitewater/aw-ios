//
//  AWGage.swift
//  aw
//
//  Created by Alex Kerney on 4/18/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation

struct AWGage: Codable {
    let gageId: Int
    let glat: String?
    let glon: String?
    let name: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case gageId = "id"
        case glat, glon, name, state
    }
}

extension AWGage {
    struct Conditions: Codable {
        let reading: String
        let series: Int
        let updated: Date

        //swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case reading, series, updated
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reading = try values.decode(String.self, forKey: .reading)
            series = try values.decode(Int.self, forKey: .series)
            let updatedSeconds = Double(try values.decode(String.self, forKey: .updated))
            updated = Date().addingTimeInterval(-updatedSeconds!)
        }
    }
}

extension AWGage {
    struct Metric: Codable {
        let metricId: Int
        let unit: String
        let name: String

        //swiftlint:disable:next nesting
        enum CodingKeys: String, CodingKey {
            case metricId = "id"
            case unit, name
        }
    }
}

struct AWGageResponse: Codable {
    let conditions: [AWGage.Conditions]
    let gage: AWGage
    let metrics: [Int: AWGage.Metric]
    let riverInfo: [AWReach]

    enum CodingKeys: String, CodingKey {
        case conditions, metrics
        case gage = "gauge"
        case riverInfo = "riverinfo"
    }
}
