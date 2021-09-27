//
//  API+GaugeGraphData.swift
//  API+GaugeGraphData
//
//  Created by Phillip Kast on 8/29/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension API {
    struct GaugeGraphData {
        enum Errors: Error {
            case badURL
        }
        
        /// Retrieves gauge data
        static func get(gaugeId: Int, dateInterval: DateInterval, resolution: Int, completion: @escaping ([GaugeDataPoint]?, Error?) -> Void) {
            let start = Int(round(dateInterval.start.timeIntervalSince1970))
            let end = Int(round(dateInterval.end.timeIntervalSince1970))
            
            guard let url = URL(string: "\(AWGC.AW_BASE_URL)/api/gauge/\(gaugeId)/flows/2?from=\(start)&to=\(end)&resolution=\(resolution)") else {
                completion(nil, Errors.badURL)
                return
            }
            
            AF.request(url).responseData { (response) in
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    do {
                        let points = try decoder.decode([GaugeDataPoint].self, from: value)
                        
                        print("Total flow data points from server: \(points.count)")
                        
                        // TODO: convert epoch date/times to date objects (which keys?)
                        
                        completion(points, nil)
                    } catch {
                        completion(nil, error)
                        return
                    }
                case .failure(let error):
                    completion(nil, error)
                }
                
            }
        }
        
    }
}
