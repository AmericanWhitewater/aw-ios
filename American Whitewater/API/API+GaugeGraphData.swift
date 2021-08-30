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
        static func get(gaugeId: Int, dateInterval: DateInterval, resolution: Int, completion: @escaping ([[String: Any?]]?, Error?) -> Void) {
            let start = Int(round(dateInterval.start.timeIntervalSince1970))
            let end = Int(round(dateInterval.end.timeIntervalSince1970))
            
            guard let url = URL(string: "\(AWGC.AW_BASE_URL)/api/gauge/\(gaugeId)/flows/2?from=\(start)&to=\(end)&resolution=\(resolution)") else {
                completion(nil, Errors.badURL)
                return
            }
            
            AF.request(url).responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    
                    var flowData = [[String:Any?]]()
                    
                    let json = JSON(value)
                    
                    if let flowArray = json.array {
                        for flow in flowArray {
                            var flowDict = [String: Any?]()
                            flowDict["gauge_id"] = flow["gauge_id"].intValue
                            flowDict["metric"] = flow["metric"].intValue
                            flowDict["nv"] = flow["nv"].doubleValue
                            flowDict["reading"] = flow["reading"].stringValue
                            flowDict["updated"] = flow["updated"].doubleValue
                            flowDict["id"] = flow["id"].int32Value
                            flowData.append(flowDict)
                        }
                    }
                    
                    print("Total flow data points from server: \(json.count)")
                    
                    // convert epoc date/times to date objects
                    
                    completion(flowData, nil)
                    
                case .failure(let error):
                    print("Failed trying to call: \(url)")
                    print("Response: \(response)")
                    print("Response Description: \(response.debugDescription)")
                    print("HTTP Response: \(response.response.debugDescription)")
                    print("Error:", error)
                }
                
            }
        }
        
    }
}
