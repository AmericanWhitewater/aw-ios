//
//  GaugeDataPoint.swift
//  GaugeDataPoint
//
//  Created by Phillip Kast on 8/29/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation
import OAuthSwift

struct GaugeDataPoint {
    var id: Int
    var gaugeId: Int
    var metric: Int
    var nv: Double
    var reading: Double
    var updated: Double
}

extension GaugeDataPoint: Decodable {
    enum CodingKeys: CodingKey {
        case id, gaugeId, metric, nv, reading, updated
    }
    
    enum Errors: Error {
        case invalidUpdatedString(String)
    }
    
    // Manual decoding to deal with stringly typing in the response
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        gaugeId = try values.decode(Int.self, forKey: .gaugeId)
        metric = try values.decode(Int.self, forKey: .metric)
        nv = try values.decode(Double.self, forKey: .nv)
        
        let readingString = try values.decode(String.self, forKey: .reading)
        reading = Double(readingString) ?? 0
        
        // Sometimes the API call returns a number for updated, sometimes it returns a string:
        if let d = try? values.decode(Double.self, forKey: .updated) {
            updated = d
        } else {
            let dStr = try values.decode(String.self, forKey: .updated)
            
            guard let d = Double(dStr) else {
                throw Errors.invalidUpdatedString(dStr)
            }
            
            updated = d
        }
    }
}
