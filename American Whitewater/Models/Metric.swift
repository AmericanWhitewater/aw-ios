//
//  Metric.swift
//  Metric
//
//  Created by Phillip Kast on 9/6/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation

struct Metric {
    var id: String
    var name: String
    var unit: String
    
    init(id: String, name: String, unit: String) {
        self.id = id
        self.name = name
        self.unit = unit
    }
    
    init?(datum: GagesForReachQuery.Data.Gauge.Gauge.Metric) {
        guard
            let id = datum.id,
            let name = datum.name,
            let unit = datum.unit
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.unit = unit
    }
}
