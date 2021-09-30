import Foundation
import CoreData
import CoreLocation

class ReachUpdater {
    private let api = API.shared
    
    /// The main NSManagedObjectContext this updater will operate on
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    //
    // MARK: - Public API
    //
    
    private static var isFetchingReaches = false
    
    /// Requests reaches matching the given `regionCodes` from the network and creates or updates the local copies
    public func updateReaches(regionCodes: [String], completion: @escaping (Error?) -> Void) {
        guard !Self.isFetchingReaches else {
            completion(Errors.alreadyFetchingReaches)
            return
        }
        
        Self.isFetchingReaches = true
        
        api.getReaches(regionCodes: regionCodes) { awReaches, error in
            guard
                let awReaches = awReaches,
                error == nil
            else {
                completion(error)
                return
            }
            
            let context = self.privateQueueContext()
            context.perform {
                print("Processing \(awReaches.count) reaches")
                                
                do {
                    self.createOrUpdateReaches(newReaches: awReaches, context: context)
                    try context.save()
                    
                    self.mergeMainContext(
                        completion: {
                            DefaultsManager.shared.lastUpdated = Date()
                            completion(nil)
                        },
                        errorCallback: completion
                    )
                    
                    Self.isFetchingReaches = false
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    /// Requests reaches with the given `reachIds` from the network and creates or updates the local copies
    public func updateReaches(reachIds: [Int], completion: @escaping (Error?) -> Void) {
        api.getReaches(reachIds: reachIds) { awReaches, error in
            guard
                let awReaches = awReaches,
                error == nil
            else {
                completion(error)
                return
            }
            
            let context = self.privateQueueContext()
            context.perform {
                do {
                    self.createOrUpdateReaches(newReaches: awReaches, context: context)
                    try context.save()
                    
                    self.mergeMainContext(
                        completion: {
                            DefaultsManager.shared.lastUpdated = Date()
                            
                            // FIXME: This call is used for things other than favorites. This needs to be set elsewhere
                            DefaultsManager.shared.favoritesLastUpdated = Date()

                            completion(nil)
                        },
                        errorCallback: completion
                    )
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    /// Requests reach detail for a single reach, and updates the locally stored Reach
    // TODO: split this into a ReachDetail model
    public func updateReachDetail(reachId: Int, completion: @escaping (Error?) -> Void) {
        api.getReachDetail(reachId: reachId) { detail, error in
            guard
                let detail = detail,
                error == nil
            else {
                completion(error)
                return
            }
            
            let context = self.privateQueueContext()
            context.perform {
                do {
                    try self.updateDetail(reachId: reachId, details: detail, context: context)
                    try context.save()
                    self.mergeMainContext(
                        completion: { completion(nil) },
                        errorCallback: completion
                    )
                } catch {
                    completion(error)
                }
            }
        }
    }
    
    /// Updates local reach distances based on the user's current location. This method should be removed
    public func updateAllReachDistances(completion: @escaping () -> Void) {
        let coord = DefaultsManager.shared.coordinate
        
        guard CLLocationCoordinate2DIsValid(coord) else {
            print("Unable to update distance - user location is \(coord.latitude)x\(coord.longitude)")
            return
        }
        
        let request = Reach.reachFetchRequest() as NSFetchRequest<Reach>
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let results = try? managedObjectContext.fetch(request), results.count > 0 {
            for reach in results {
                guard let lat = reach.putInLat, let latitude = Double(lat),
                      let lon = reach.putInLon, let longitude = Double(lon) else { print("Update: Invalid reach: \(reach.name ?? "?")  location \(reach.putInLat ?? "?")x\(reach.putInLat ?? "?")"); continue; }
                
                let reachLocation = CLLocation(latitude: latitude, longitude: longitude)
                
                guard CLLocationCoordinate2DIsValid(reachLocation.coordinate) else { continue }
                
                let distance = reachLocation.distance(from: DefaultsManager.shared.location)
                print("Distance: \(distance / 1609)")
                reach.distance = distance / 1609
            }
            
            // save changes
            do {
                try managedObjectContext.save()
                print("Saved Global Context")
                completion()
            } catch {
                let error = error as NSError
                print("Unable to save main view context: \(error), \(error.userInfo)")
            }
        }
    }
    
    //
    // MARK: - ManagedObjectContexts and core data mapping
    //
    
    private func privateQueueContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext
        return context
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
    
    private func updateDetail(reachId: Int, details: AWApiReachHelper.AWReachDetail, context: NSManagedObjectContext) throws {
        let request = Reach.reachFetchRequest() as NSFetchRequest<Reach>
        request.predicate = NSPredicate(format: "id = %i", reachId)
        
        let reaches = try context.fetch(request)
        
        // update the information if it came back correctly
        guard let reach = reaches.first else {
            throw Errors.noMatchingReach
        }
        
        reach.avgGradient = Int16(details.detailAverageGradient ?? 0)
        reach.photoId = Int32(details.detailPhotoId ?? 0)
        reach.maxGradient = Int16(details.detailMaxGradient ?? 0)
        reach.length = details.detailLength
        reach.longDescription = details.detailDescription
        reach.shuttleDetails = details.detailShuttleDescription
        reach.gageName = details.detailGageName
        
        if let rapidsList = details.detailRapids {
            for rapid in rapidsList {
                createOrUpdateRapid(awRapid: rapid, reach: reach, context: context)
            }
        }
    }
    
    // FIXME: doesn't look like this handles rapid deletion on the server
    private func createOrUpdateRapid(awRapid: AWApiReachHelper.AWRapid, reach: Reach, context: NSManagedObjectContext) {
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
    
    //
    // MARK: - Errors
    //
    
    enum Errors: Error {
        case alreadyFetchingReaches
        case noMatchingReach
    }
}
