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
    
    public func updateReaches(regionCodes: [String], completion: @escaping (Error?) -> Void) {
        api.updateReaches(regionCodes: regionCodes, completion: completion)
    }
    
    public func updateReaches(reachIds: [Int], completion: @escaping (Error?) -> Void) {
        api.updateReaches(reachIds: reachIds, completion: completion)
    }
    
    public func updateAllReaches(completion: @escaping () -> Void) {
        api.updateAllReaches(completion: completion)
    }
    
    public func updateReachDetail(reachId: Int, completion: @escaping (Error?) -> Void) {
        api.updateReachDetail(reachId: reachId, completion: completion)
    }
    
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
            
            DefaultsManager.shared.lastUpdated = Date()
        }
    }
    
    //
    // MARK: - ManagedObjectContexts
    //
    
    private func privateQueueContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext
        return context
    }
}
