//
//  Gauge.swift
//  Gauge
//
//  Created by Phillip Kast on 9/6/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation

struct Gauge {
    var id: String?
    var name: String?
    var source: String?
    var metric: Metric?
    
    init(id: String, name: String, source: String, metric: Metric) {
        self.id = id
        self.name = name
        self.source = source
        self.metric = metric
    }
    
    // FIXME: all properties are optional -- can they be non-optional and this init returns nil if any necessary property is nil?
    init?(datum: GagesForReachQuery.Data.Gauge.Gauge) {
        guard let gauge = datum.gauge else {
            return nil
        }
        
        id = gauge.id
        name = gauge.name
        source = gauge.source
        if let metricDatum = datum.metric {
            metric = Metric(datum: metricDatum)
        }
    }
}
