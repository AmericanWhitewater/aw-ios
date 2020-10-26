import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import Foundation
import CoreLocation

/*
 This is the main API helper class for retrieving
 Reaches and storing them in core data
*/

class AWApiReachHelper {

    private var fetchedResultsController: NSFetchedResultsController<Reach>?
    
    // setup our singleton for the api helper class
    static let shared = AWApiReachHelper()

    private init() {} // prevent any other default initializer
    
    typealias ReachCallback = ([AWReach]) -> Void
    typealias UpdateCallback = () -> Void
    typealias ReachErrorCallback = (Error?) -> Void
    typealias UpdateReachesCallback = () -> Void
    typealias ReachDetailCallback = (AWReachDetail) -> Void
    
    func fetchReachesByRegion(regionCode: String, callback: @escaping ReachCallback, callbackError: @escaping ReachErrorCallback) {
        print("Fetching Reaches by Region: \(regionCode)")
        let urlString = riverURL + "?state=\(regionCode)"
        
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

    /*
     func fetchReachesRecursively(currentIndex: Int, allRegionCodes: [String],
                                  allRiverJSONdata: [JSON], successCallback: @escaping ReachCallback,
                                  callbackError: @escaping ReachErrorCallback)
     
     This calls each of the regions to be downloaded, then after all are downloaded it
     processes all of them at once which happens very quickly
     
     This is designed to run in the background and update the UI as it goes without delays.
     Users can still pull/refresh individual data while this is happening.
    */
    func fetchReachesRecursively(currentIndex: Int, allRegionCodes: [String], allRiverJSONdata: [JSON], successCallback: @escaping ReachCallback, callbackError: @escaping ReachErrorCallback) {
        
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
    
    /*
     func fetchReachesByIds(reachIds: [String], callback: @escaping ReachCallback,
                            callbackError: @escaping ReachErrorCallback)
     
     This updates reaches based on their IDs. This is great for updating the favorites, and groups of reaches
    */
    func fetchReachesByIds(reachIds: [String], callback: @escaping ReachCallback, callbackError: @escaping ReachErrorCallback) {
        
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
    
    
    func findOrNewReach(newReach: AWReach, context: NSManagedObjectContext) -> Reach {
        let request = Reach.fetchRequest() as NSFetchRequest<Reach>
        //print("nReach name: \(newReach.name ?? "na") ID: \(NSNumber(value: newReach.id ?? 0))")
        guard let id = newReach.id else {
            print("invalid id: \(newReach.id ?? -1)")
            return Reach(context: context)            
        }
        
        request.predicate = NSPredicate(format: "id == %i", id)
                
        guard let result = try? context.fetch(request), result.count > 0 else {
            let reach = Reach(context: context)
            reach.id = Int16(newReach.id ?? 0)
            return reach
        }

        return result.first!
    }

    private func createOrUpdateReaches(newReaches: [AWReach], context: NSManagedObjectContext) {
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
            reach.id = Int16(newReach.id ?? 0)
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
            
            if let altName = newReach.altname, !altName.isEmpty {
                reach.section = altName
            } else {
               reach.section = newReach.section
            }

            // API returns the total seconds before the present time as a string
            // converting this to a Date
            if let updatedSecondsString = newReach.last_gauge_updated,
                let updatedSecondsAgo = Int(updatedSecondsString) {
                reach.gageUpdated = Date().addingTimeInterval(TimeInterval(-updatedSecondsAgo))
            }
            
            // calculate the distance from the user
            if let distance = newReach.distanceFrom(location:
                CLLocation(latitude: DefaultsManager.latitude, longitude: DefaultsManager.longitude)) {
                
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
        
        // now save all the new reaches to the context
        print("Saving after updating reaches")
        do {
            try context.save()
        } catch {
            let error = error as NSError
            print("Unable to save reaches in core data: \(error), \(error.localizedDescription)")
        }
    }

    func updateRegionalReaches(regionCodes: [String], callback: @escaping UpdateReachesCallback, callbackError: @escaping ReachErrorCallback) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard DefaultsManager.fetchingreaches == false else {
            print("Already fetching reaches...");
            callback()
            return
        }
        
        print("Fetching region codes: \(regionCodes.description)")
        
        DefaultsManager.fetchingreaches = true
        let dispatchGroup = DispatchGroup()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dispatchGroup.enter()
        
        fetchReachesRecursively(currentIndex: 0, allRegionCodes: regionCodes, allRiverJSONdata: [], successCallback: { (reaches) in
            // success
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = managedObjectContext

            context.perform {
                print("Processing \(reaches.count) reaches")
                self.createOrUpdateReaches(newReaches: reaches, context: context)

                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    print("Unable to save reaches in coredata: \(error), \(error.localizedDescription)")
                    callbackError(error)
                }
                dispatchGroup.leave()
            }
            
        }) { (error) in
            // pass error forward to callback so we can
            // handle errors on ViewController that called this
            callbackError(error)
            dispatchGroup.leave()
            return
        }
        
        dispatchGroup.notify(queue: .main) {
            managedObjectContext.perform {
                managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    try managedObjectContext.save()
                    print("Saved Global Context")
                    callback()
                } catch {
                    let error = error as NSError
                    print("Unable to save main view context: \(error), \(error.userInfo)")
                    callbackError(error)
                }
            }
            
//            DefaultsManager.lastUpdated = Date()
//            DefaultsManager.favoritesLastUpdated = Date()
            DefaultsManager.fetchingreaches = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func downloadAllReachesInBackground(callback: @escaping UpdateCallback) {
        let codes = Region.all.map { $0.code }

        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dispatchGroup = DispatchGroup()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dispatchGroup.enter()
        
        fetchReachesRecursively(currentIndex: 0, allRegionCodes: codes, allRiverJSONdata: [], successCallback: { (reaches) in
            // success
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = managedObjectContext

            context.perform {
                print("Processing \(reaches.count) reaches")
                self.createOrUpdateReaches(newReaches: reaches, context: context)

                print("Saving context")
                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    print("Unable to save reaches in coredata: \(error), \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
            
        }) { (error) in
            // pass error forward to callback so we can
            // handle errors on ViewController that called this
            print("Error with getting all reaches: \(error?.localizedDescription ?? "Unknown error")")
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Notify .main called")
            managedObjectContext.perform {
                managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    try managedObjectContext.save()
                    print("Saved Global Context")
                    callback()
                } catch {
                    let error = error as NSError
                    print("Unable to save main view context: \(error), \(error.userInfo)")
                }
            }
            
            DefaultsManager.lastUpdated = Date()
            DefaultsManager.favoritesLastUpdated = Date()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }


    func updateReaches(reachIds: [String], callback: @escaping UpdateCallback, callbackError: @escaping ReachErrorCallback) {
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dispatchGroup = DispatchGroup()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dispatchGroup.enter()
        
        fetchReachesByIds(reachIds: reachIds, callback: { (reaches) in
            // success
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = managedObjectContext

            context.perform {
                print("AW reaches \(reachIds) decoded")
                //for reach in reaches {
                self.createOrUpdateReaches(newReaches: reaches, context: context)
                //}
                
                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    print("Unable to save background context \(error) \(error.userInfo)")
                }
                dispatchGroup.leave()
            }

        }) { (error) in
            callbackError(error)
        }
        dispatchGroup.notify(queue: .main) {
            print("Update reaches \(reachIds) complete")
            managedObjectContext.perform {
                managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    try managedObjectContext.save()
                    print("saved view context")
                } catch {
                    let error = error as NSError
                    print("Unable to save view context \(error) \(error.userInfo)")
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            callback()
        }
        
        DefaultsManager.lastUpdated = Date()
    }
    
    func fetchReachDetail(reachId: String,
                          callback: @escaping ReachDetailCallback, callbackError: @escaping ReachErrorCallback) {
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
    
    private func createOrUpdateRapid(awRapid: AWRapid, reach: Reach, context: NSManagedObjectContext) {
        let predicate = NSPredicate(format: "id == %i", awRapid.rapidId)
        let request = Rapid.fetchRequest() as NSFetchRequest<Rapid>
        request.predicate = predicate
        
        let rapid: Rapid
        
        if let result = try? context.fetch(request), result.count > 0, let first = result.first {
            rapid = first
        } else {
            rapid = Rapid(context: context)
            rapid.id = Int32(awRapid.rapidId)
        }
        
        if let lat = awRapid.rapidLatitude, let lon = awRapid.rapidLongitude, let latitude = Double(lat), let longitude = Double(lon) {
            rapid.lat = latitude
            rapid.lon = longitude
        }
        
        rapid.rapidDescription = awRapid.description
        rapid.name = awRapid.name
        rapid.difficulty = awRapid.difficulty
        rapid.isHazard = awRapid.isHazard
        rapid.isPutIn = awRapid.isPutIn
        rapid.isPortage = awRapid.isPortage
        rapid.isTakeOut = awRapid.isTakeOut
        rapid.isPlaySpot = awRapid.isPlaySpot
        rapid.isWaterfall = awRapid.isWaterfall
        
        rapid.reach = reach
    }
    
    func updateDetail(reachId: String, details: AWReachDetail, context: NSManagedObjectContext) {
        
        let request = Reach.fetchRequest() as NSFetchRequest<Reach>
        request.predicate = NSPredicate(format: "id = %@", reachId)
        
        do {
            let reaches = try context.fetch(request)
            
            // update the information if it came back correctly
            if let reach = reaches.first {
                
                reach.avgGradient = Int16(details.detailAverageGradient ?? 0)
                reach.photoId = Int32(details.detailPhotoId ?? 0)
                reach.maxGradient = Int16(details.detailMaxGradient ?? 0)
                reach.length = details.detailLength
                reach.longDescription = details.detailDescription
                reach.shuttleDetails = details.detailShuttleDescription
                reach.gageName = details.detailGageName
                
                // foreach rapid
                // -- create, attach, and store it
                if let rapidsList = details.detailRapids {
                    for rapid in rapidsList {
                        createOrUpdateRapid(awRapid: rapid, reach: reach, context: context)
                    }
                }
                
                do {
                    try context.save()
                    print("Saved Reach Detail Context")
                } catch {
                    let error = error as NSError
                    print("Error saving reach detail context: \(error), \(error.userInfo)")
                }
            } else {
                print("Can't update reach, no matching one found with ID: \(reachId)")
            }
            
        } catch {
            let error = error as NSError
            print("Error updateDetail: \(error), \(error.userInfo)")
        }
    }
    
    func updateReachDetail(reachId: String,
                           callback: @escaping UpdateCallback, callbackError: @escaping ReachErrorCallback) {

        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchReachDetail(reachId: reachId, callback: { (reachDetail) in

            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = managedObjectContext

            context.perform {
                self.updateDetail(reachId: reachId, details: reachDetail, context: context)
                dispatchGroup.leave()
            }
        }) { (error) in
            callbackError(error)
        }
        dispatchGroup.notify(queue: .main) {
            managedObjectContext.perform {
                managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    try managedObjectContext.save()
                    print("Saved Global Context")
                    callback()
                } catch {
                    let error = error as NSError
                    print("Unable to save main view context: \(error), \(error.userInfo)")
                }
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    func updateAllReachDistances(callback: @escaping UpdateCallback) {
        
        if DefaultsManager.latitude == 0.0 || DefaultsManager.longitude == 0.0 {
            print("Unable to update distance - user location is \(DefaultsManager.latitude)x\(DefaultsManager.longitude)")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = Reach.fetchRequest() as NSFetchRequest<Reach>
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let results = try? context.fetch(request), results.count > 0 {
           
            for reach in results {
                guard let lat = reach.putInLat, let latitude = Double(lat),
                    let lon = reach.putInLon, let longitude = Double(lon) else { print("Update: Invalid reach: \(reach.name ?? "?")  location \(reach.putInLat ?? "?")x\(reach.putInLat ?? "?")"); continue; }
            
                let reachCoordinate = CLLocation(latitude: latitude, longitude: longitude)

                guard CLLocationCoordinate2DIsValid(reachCoordinate.coordinate) else { continue }

                let distance = reachCoordinate.distance(from: CLLocation(latitude: DefaultsManager.latitude, longitude: DefaultsManager.longitude))
                print("Distance: \(distance / 1609)")
                reach.distance = distance / 1609
            }
            
            // save changes
            do {
                try context.save()
                print("Saved Global Context")
                callback()
            } catch {
                let error = error as NSError
                print("Unable to save main view context: \(error), \(error.userInfo)")
            }
            
            DefaultsManager.lastUpdated = Date()
        }
    }
}
