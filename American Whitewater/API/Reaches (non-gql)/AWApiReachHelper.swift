import Alamofire
import SwiftyJSON
import Foundation
import CoreLocation

class AWApiReachHelper {
    private let baseURL: String
    private let riverURL: String
    private let baseGaugeDetailURL: String

    init(baseURL: String, riverURL: String, baseGaugeDetailURL: String) {
        self.baseURL = baseURL
        self.riverURL = riverURL
        self.baseGaugeDetailURL = baseGaugeDetailURL
    }
    
    typealias ReachCallback = ([AWReach]) -> Void
    typealias UpdateCallback = () -> Void
    typealias ReachErrorCallback = (Error) -> Void
    typealias UpdateReachesCallback = () -> Void
    typealias ReachDetailCallback = (AWReachDetail) -> Void
    
    /// Calls each of the regions to be downloaded, then after all are downloaded it processes all of them at once which happens very quickly
    /// This is designed to run in the background and update the UI as it goes without delays. Users can still pull/refresh individual data while this is happening.
    private func fetchReachesRecursively(currentIndex: Int, allRegionCodes: [String], allRiverJSONdata: [JSON], successCallback: @escaping ReachCallback, callbackError: @escaping ReachErrorCallback) {
        
        var allRiverJSON = allRiverJSONdata
        
        let nextRegionCode = allRegionCodes[currentIndex]
        
        let urlString = riverURL + "?state=\(nextRegionCode)"
        print("Downloading Region at: \(urlString)")
        
        AF.request(urlString).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    // handle success
                    let json = JSON(value)
                    allRiverJSON.append(json)
                case .failure(let error):
                    // handle error
                    print("Error with \(urlString)")
                    callbackError(error)
            }
            
            // success or failure we keep going
            let newIndex = currentIndex + 1
            if newIndex > allRegionCodes.count - 1 {
                print("Finished downloading all \(allRegionCodes.count) regions")
                
                var riversList: [AWReach] = []
                
                for riverJSON in allRiverJSON {
                    if let riversArray = riverJSON.array {
                        for riverJSON in riversArray {
                            let reach = AWReach(json: riverJSON)
                            riversList.append(reach)
                        }
                    }
                    
                    print("riversList Count: \(riversList.count)")
                }
                
                successCallback(riversList)
            } else {
                // keep er going
                self.fetchReachesRecursively(currentIndex: newIndex, allRegionCodes: allRegionCodes, allRiverJSONdata: allRiverJSON, successCallback: successCallback, callbackError: callbackError)
            }
        }
        
    }
    
    /// Updates reaches based on their IDs. This is great for updating the favorites, and groups of reaches
    public func getReaches(reachIds: [String], callback: @escaping ReachCallback, callbackError: @escaping ReachErrorCallback) {
        if reachIds.isEmpty {
            print("No reach ids sent")
            callback([])
            return
        }
        
        let urlString = baseURL + "River/list/list/\(reachIds.joined(separator: ":"))/.json"
        
        AF.request(urlString).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    var riversList: [AWReach] = []
                                        
                    let json = JSON(value)
                    print("Total JSON Reaches from server: \(json.count)")
                                        
                    if let riversArray = json.array {
                        for riverJSON in riversArray {
                            let reach = AWReach(json: riverJSON)
                            riversList.append(reach)
                        }
                    }
                
                    print("Processed \(riversList.count) rivers.")
                
                    callback(riversList)

                case .failure(let error):
                    print("Failed trying to call: \(urlString)")
                    print("Response: \(response)")
                    print("Response Description: \(response.debugDescription)")
                    print("HTTP Response: \(response.response.debugDescription)")

                    callbackError(error)
            }
            
        }
        
    }

    public func getReaches(regionCodes: [String], callback: @escaping ([AWReach]) -> Void, callbackError: @escaping ReachErrorCallback) {
        fetchReachesRecursively(
            currentIndex: 0,
            allRegionCodes: regionCodes,
            allRiverJSONdata: [],
            successCallback: callback,
            callbackError: callbackError
        )
    }
    
    public func getReachDetail(reachId: Int, callback: @escaping ReachDetailCallback, callbackError: @escaping ReachErrorCallback) {
        let urlString = "\(baseGaugeDetailURL)\(reachId)/.json"
        
        AF.request(urlString).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let reachDetails = AWReachDetail(detailsJson: json)
                    callback(reachDetails)
                case .failure(let error):
                    callbackError(error)
            }
        }
    }
}
