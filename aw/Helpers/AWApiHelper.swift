import CoreData
import Foundation
import MapKit
import UIKit

let baseURL = "https://www.americanwhitewater.org/content/"

let riverURL = baseURL + "River/search/.json"

struct AWApiHelper {
    typealias ReachCallback = ([AWReach]?) -> Void
    typealias UpdateCallback = () -> Void
    typealias ReachDetailCallback = (AWReachDetailResponse.Sub) -> Void
    typealias GageDetailCallback = (AWGageResponse) -> Void

    static func fetchReachesByRegion(region: String, callback: @escaping ReachCallback) {
        let urlString = riverURL + "?state=\(region)"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("Data retrieved from AW API for \(region), decoding reaches")

            let decoder = JSONDecoder()
            guard let data = data, let reaches = try? decoder.decode([AWReach].self, from: data) else { return }

            callback(reaches)
        }
        task.resume()
    }

    static func fetchReachesByIds(reachIds: [String], callback: @escaping ReachCallback) {
        let urlString = baseURL + "River/list/list/\( reachIds.joined(separator: ":") )/.json"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("Data retrieved from AW API for \( reachIds ), decoding reaches")

            let decoder = JSONDecoder()
            guard let data = data, let reaches = try? decoder.decode([AWReach].self, from: data) else { return }

            callback(reaches)
        }
        task.resume()
    }

    static func createOrUpdateReaches(newReaches: [AWReach], context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        var reaches: [Reach] = []

        for newReach in newReaches {
            let reach = self.findOrNewReach(byID: newReach.id, inContext: context)
            self.setupReach(reach, newReach: newReach)
            reaches.append(reach)
        }

        do {
            try context.save()
        } catch {
            fatalError("Failure to save \(newReaches.count) reaches context: \(error)")
        }
    }

    //swiftlint:disable:next identifier_name
    static func findOrNewReach(byID id: Int, inContext context: NSManagedObjectContext) -> Reach {
        let predicate = NSPredicate(format: "id == %i", id)
        let request: NSFetchRequest<Reach> = Reach.fetchRequest()
        request.predicate = predicate

        guard let result = try? context.fetch(request), result.count > 0 else {
            let reach = Reach(context: context)
            reach.id = Int16(id)
            return reach
        }

        return result.first!
    }

    static fileprivate func setupReach(_ reach: Reach, newReach: AWReach) {
        let difficultyRange = DifficultyHelper.parseDifficulty(difficulty: newReach.difficulty)

        var region: Region!

        if let state = newReach.state {
            region = Region.apiDict[state]
            reach.state = region.title
        }

        if let altName = newReach.altName, !altName.isEmpty {
            reach.section = altName
        } else {
            reach.section = newReach.section
        }

        //reach.section = newReach.section
        //reach.section = newReach.altName != "" ? newReach.altName : newReach.section
        reach.putInLat = newReach.putInLat
        reach.putInLon = newReach.putInLon
        reach.name = newReach.name
        reach.lastGageReading = newReach.lastGageReading ?? "n/a"
        reach.id = Int16(newReach.id)
        reach.difficulty = newReach.difficulty
        reach.condition = newReach.condition
        reach.unit = newReach.unit
        reach.takeOutLat = newReach.takeOutLat
        reach.takeOutLon = newReach.takeOutLon
        reach.rc = newReach.rc
        reach.delta = newReach.delta
        reach.gageId = Int32(newReach.gageId ?? 0)
        reach.gageMetric = Int16(newReach.gageMetric ?? 0)

        // API returns seconds before present as a string
        // that needs to be changed to a date
        if let updatedSecondsString = newReach.lastGageUpdated,
            let updatedSecondsAgo = Int(updatedSecondsString) {

            reach.gageUpdated = Date().addingTimeInterval(
                TimeInterval(-updatedSecondsAgo))
        }

        if let distance = newReach.distanceFrom(
            location: CLLocation(
                latitude: DefaultsManager.latitude,
                longitude: DefaultsManager.longitude)) {
            reach.distance = distance / 1609
        }
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

    static func updateRegions(viewContext: NSManagedObjectContext, callback: @escaping UpdateCallback) {
        let regions = Region.all
        let dispatchGroup = DispatchGroup()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        for region in regions {
            dispatchGroup.enter()
            fetchReachesByRegion(region: region.code) { (reaches) in
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                context.parent = viewContext

                context.perform {
                    print("aw reaches decoded for \(region.code)")
                    if let reaches = reaches {
                        self.createOrUpdateReaches(newReaches: reaches, context: context)
                    }
                    do {
                        try context.save()
                        print("background context saved")
                    } catch {
                        let error = error as NSError
                        print("unable to save background context \(error) \(error.userInfo)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("update regions complete")
            viewContext.perform {
                viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    try viewContext.save()
                    print("saved view context")
                } catch {
                    let error = error as NSError
                    print("unable to save view context \(error) \(error.userInfo)")
                }
            }
            DefaultsManager.lastUpdated = Date()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            callback()
        }
    }

    static func updateReaches(reachIds: [String], viewContext: NSManagedObjectContext, callback: @escaping UpdateCallback) {
        let dispatchGroup = DispatchGroup()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dispatchGroup.enter()
        fetchReachesByIds(reachIds: reachIds) { (reaches) in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = viewContext

            context.perform {
                print("AW reaches \(reachIds) decoded")
                if let reaches = reaches {
                    self.createOrUpdateReaches(newReaches: reaches, context: context)
                }
                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    print("Unable to save background context \(error) \(error.userInfo)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("Update reaches \(reachIds) complete")
            viewContext.perform {
                viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    try viewContext.save()
                    print("saved view context")
                } catch {
                    let error = error as NSError
                    print("Unable to save view context \(error) \(error.userInfo)")
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            callback()
        }
    }

    static func fetchReachDetail(reachID: String, callback: @escaping ReachDetailCallback) {
        let url = URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\(reachID)/.json")!

        let task = URLSession.shared.dataTask(with: url) { dataOptional, response, error in
            let decoder = JSONDecoder()

            guard let data = dataOptional else {
                print("Can't unwrap data optional from API")
                return

            }
            do {
                let detail = try decoder.decode(AWReachDetailResponse.self, from: data)
                //print(detail.view)
                callback(detail.view)
            } catch {
                print("Unable to decode \(reachID): \(error)")
            }
        }
        task.resume()
    }

    static func fetchGageDetail(gageId: Int, callback: @escaping GageDetailCallback) {
        guard gageId != 0,
            let url = URL(string: "https://www.americanwhitewater.org/content/Gauge2/detail/id/\(gageId)/.json")
            else { return }

        let task = URLSession.shared.dataTask(with: url) { dataOptional, response, error in
            let decoder = JSONDecoder()

            guard let data = dataOptional else {
                print("Can't unwrap data from API for \(gageId)")
                return
            }
            do {
                let gageDetail = try decoder.decode(AWGageResponse.self, from: data)
                callback(gageDetail)
            } catch {
                print("Unable to decode \(gageId): \(error)")
            }
        }
        task.resume()
    }

    private static func createOrUpdateRapid(awRapid: AWRapid, reach: Reach, context: NSManagedObjectContext) {
        let predicate = NSPredicate(format: "id == %i", awRapid.rapidid)
        let request: NSFetchRequest<Rapid> = Rapid.fetchRequest()
        request.predicate = predicate

        let rapid: Rapid

        if let result = try? context.fetch(request), result.count > 0, let first = result.first {
            rapid = first
        } else {
            rapid = Rapid(context: context)
            rapid.id = Int32(awRapid.rapidid)
        }

        if let lat = awRapid.rlat, let lon = awRapid.rlon, let latitude = Double(lat), let longitude = Double(lon) {
            rapid.lat = latitude
            rapid.lon = longitude
        }
        rapid.rapidDescription = awRapid.description
        rapid.name = awRapid.name
        rapid.difficulty = awRapid.difficulty

        rapid.reach = reach
    }

    fileprivate static func updateDetail(reachID: String, info: AWReachInfo, rapids: [AWRapid], context: NSManagedObjectContext) {
        let request: NSFetchRequest<Reach> = Reach.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", reachID)

        do {
            let reaches = try context.fetch(request)
            if let reach = reaches.first {
                if let avgGradient = info.avgGradient {
                    reach.avgGradient = avgGradient
                } else { print("Can't unwrap avgGradient")}
                if let photoId = info.photoId {
                    reach.photoId = photoId
                } else { print("Can't unwrap photoId")}
                if let maxGradient = info.maxGradient {
                    reach.maxGradient = maxGradient
                } else { print("Can't unwrap maxGradient") }
                reach.length = info.length
                reach.abstract = info.abstract
                reach.longDescription = info.description
                reach.shuttleDetails = info.shuttleDetails
                reach.zipcode = info.zipcode
                reach.detailUpdated = Date()
                for rapid in rapids {
                    print(rapid)
                    createOrUpdateRapid(awRapid: rapid, reach: reach, context: context)
                }
                do {
                    try context.save()
                    print("Reach detail background context saved")
                } catch {
                    let error = error as NSError
                    print("unable to save background context \(error) \(error.userInfo)")
                }

            } else {
                print("no reach found")
            }
        } catch {
            print("Unable to fetch reach")
        }
    }

    static func updateReachDetail(reachID: String,
                                  viewContext: NSManagedObjectContext,
                                  callback: @escaping UpdateCallback) {

        // check for last update time
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchReachDetail(reachID: reachID) { (awReachDetail) in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = viewContext

            let info = awReachDetail.main.info
            let rapids = awReachDetail.rapids.rapids

            context.perform {
                updateDetail(reachID: reachID,
                             info: info,
                             rapids: rapids,
                             context: context)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            viewContext.perform {
                print("update reach detail complete")
                viewContext.perform {
                    viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    do {
                        try viewContext.save()
                        print("saved view context")
                    } catch {
                        let error = error as NSError
                        print("unable to save view context \(error) \(error.userInfo)")
                    }
                }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                callback()
            }
        }
    }

    static func updateDistances(viewContext: NSManagedObjectContext) {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = viewContext

        let dispatchGroup = DispatchGroup()
        let location = CLLocation(latitude: DefaultsManager.latitude, longitude: DefaultsManager.longitude)
        dispatchGroup.enter()
        context.perform {
            let request: NSFetchRequest<Reach> = Reach.fetchRequest()
            do {
                let reaches = try context.fetch(request)

                for reach in reaches {
                    reach.distance = CLLocation(
                        latitude: reach.coordinate.latitude,
                        longitude: reach.coordinate.longitude
                        ).distance(from: location) / 1609
                }

                do {
                    try context.save()
                    print("Saved distance updates in background context")
                } catch {
                    let error = error as NSError
                    print("Unable to save distances in background context \(error) \(error.userInfo)")
                }
            } catch {
                print("Unable to fetch reaches")
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            viewContext.perform {
                viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

                do {
                    try viewContext.save()
                    print("saved view context")
                } catch {
                    let error = error as NSError
                    print("unable to save view context \(error) \(error.userInfo)")
                }
            }
        }
    }
}
