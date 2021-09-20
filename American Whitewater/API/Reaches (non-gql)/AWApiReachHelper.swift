import UIKit
import CoreData
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
    
    private var managedObjectContext: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private func privateQueueContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext
        return context
    }
    
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
                
                    print("Processed \(riversList.count) favorite rivers.")
                
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
    
    //
    // MARK: - Duplicated in ReachUpdater -- remove when done
    //
    
    private func createOrUpdateReaches(newReaches: [AWApiReachHelper.AWReach], context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        for newReach in newReaches {
            let reach = findOrNewReach(newReach: newReach, context: context)
            
            reach.name = newReach.name
            reach.sortName = newReach.section
            reach.putInLat = newReach.plat
            reach.putInLon = newReach.plon
            reach.takeOutLat = newReach.tlat
            reach.takeOutLon = newReach.tlon
            reach.currentGageReading = newReach.gauge_reading // ** check
            reach.lastGageReading = newReach.last_gauge_reading
            reach.id = newReach.id ?? 0
            reach.difficulty = newReach.classRating
            reach.condition = newReach.cond
            reach.unit = newReach.unit
            reach.rc = newReach.rc
            reach.delta = newReach.reading_delta
            reach.gageId = Int32(newReach.gauge_id ?? -1)
            reach.gageMetric = Int16(newReach.gauge_metric ?? -1)
            reach.gageMax = newReach.gauge_max
            reach.gageMin = newReach.gauge_min
            reach.state = newReach.state
            
            reach.altname = newReach.altname
            reach.section = newReach.section
            
            // API returns the total seconds before the present time as a string
            // converting this to a Date
            if let updatedSecondsString = newReach.last_gauge_updated,
               let updatedSecondsAgo = Int(updatedSecondsString) {
                reach.gageUpdated = Date().addingTimeInterval(TimeInterval(-updatedSecondsAgo))
            }
            
            // calculate the distance from the user
            if let distance = newReach.distanceFrom(location: DefaultsManager.shared.location) {
                reach.distance = distance / 1609
            } else {
                reach.distance = 999999
            }
            
            let difficultyRange = DifficultyHelper.parseDifficulty(difficulty: newReach.classRating ?? "")
            if difficultyRange.contains(1) {
                reach.difficulty1 = true
            }
            if difficultyRange.contains(2) {
                reach.difficulty2 = true
            }
            if difficultyRange.contains(3) {
                reach.difficulty3 = true
            }
            if difficultyRange.contains(4) {
                reach.difficulty4 = true
            }
            if difficultyRange.contains(5) {
                reach.difficulty5 = true
            }
        }
    }
    
    private func findOrNewReach(newReach: AWApiReachHelper.AWReach, context: NSManagedObjectContext) -> Reach {
        let request = Reach.reachFetchRequest() as NSFetchRequest<Reach>
        //print("nReach name: \(newReach.name ?? "na") ID: \(NSNumber(value: newReach.id ?? 0))")
        guard let id = newReach.id else {
            print("invalid id: \(newReach.id ?? -1)")
            return Reach(context: context)
        }
        
        request.predicate = NSPredicate(format: "id == %i", id)
                
        guard let result = try? context.fetch(request), result.count > 0 else {
            let reach = Reach(context: context)
            reach.id = newReach.id ?? 0
            return reach
        }

        return result.first!
    }
    
    private func mergeMainContext(completion: @escaping () -> Void, errorCallback: ((Error) -> Void)? = nil) {
        let context = managedObjectContext
        DispatchQueue.main.async {
            context.perform {
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    try context.save()
                    completion()
                } catch {
                    errorCallback?(error)
                }
            }
        }
    }
}
