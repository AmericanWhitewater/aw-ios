//
//  AWApiHelper.swift
//  aw
//
//  Created by Alex Kerney on 3/23/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation
import MapKit
import UIKit

let baseURL = "https://www.americanwhitewater.org/content/"

let riverURL = baseURL + "River/search/.json"

struct AWReach: Codable {
    let difficulty: String
    let condition: String
    //swiftlint:disable:next identifier_name
    let id: Int
    let name: String
    let putInLat: String?
    let putInLon: String?
    let lastGageReading: String?
    let section: String
    let unit: String?
    let takeOutLat: String?
    let takeOutLon: String?
    let state: String?
    let delta: String?

    enum CodingKeys: String, CodingKey {
        //swiftlint:disable:next identifier_name
        case id, name, section, unit, state, delta
        case difficulty = "class"
        case condition = "cond"
        case putInLat = "plat"
        case putInLon = "plon"
        case lastGageReading = "last_gauge_reading" // "reading_formatted"
        case takeOutLat = "tlat"
        case takeOutLon = "tlon"
    }

    func distanceFrom(location: CLLocation) -> Double? {
        guard let lat = putInLat, let latitude = Double(lat),
            let lon = putInLon, let longitude = Double(lon) else { return nil }

        let reachCoordinate = CLLocation(latitude: latitude, longitude: longitude)

        guard CLLocationCoordinate2DIsValid(reachCoordinate.coordinate) else { return nil }

        return reachCoordinate.distance(from: location)
    }
}

struct Condition {
    let name: String
    let color: UIColor
    let icon: UIImage?
}

struct AWReachInfo: Codable {
    //swiftlint:disable:next identifier_name
    let id: Int //
    let abstract: String? //
    let avgGradient: Int16? //
    let photoId: Int32? //
    let length: String? //
    let maxGradient: Int16? //
    let description: String? //
    let shuttleDetails: String? //
    let zipcode: String? //

    enum CodingKeys: String, CodingKey {
        //swiftlint:disable:next identifier_name
        case id, abstract, length, description, zipcode
        case avgGradient = "avggradient"
        case photoId = "photoid"
        case maxGradient = "maxgradient"
        case shuttleDetails = "shuttledetails"
    }
}

struct AWReachMain: Codable {
    let info: AWReachInfo
}

struct AWReachDetailSubResponse: Codable {
    let main: AWReachMain

    enum CodingKeys: String, CodingKey {
        case main = "CRiverMainGadgetJSON_main"
    }
}

struct AWReachDetailResponse: Codable {
    let view: AWReachDetailSubResponse

    enum CodingKeys: String, CodingKey {
        case view = "CContainerViewJSON_view"
    }
}

struct AWApiHelper {
    typealias ReachCallback = ([AWReach]?) -> Void
    typealias UpdateCallback = () -> Void
    typealias ReachDetailCallback = (AWReachMain) -> Void

    static func conditionFromApi(condition: String) -> Condition {
        switch condition {
        case "low":
            return Condition(name: "Low",
                             color: UIColor(named: "status_yellow")!,
                             icon: UIImage(named: "lowPin"))
        case "med":
            return Condition(name: "Runnable",
                             color: UIColor(named: "status_green")!,
                             icon: UIImage(named: "runnablePin"))
        case "high":
            return Condition(name: "High",
                             color: UIColor(named: "status_red")!,
                             icon: UIImage(named: "highPin"))
        default:
            return Condition(name: "No Info",
                             color: UIColor(named: "status_grey")!,
                             icon: UIImage(named: "noinfoPin"))
        }
    }

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
        }

        reach.section = newReach.section
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
        reach.state = region.title
        reach.delta = newReach.delta

        if let distance = newReach.distanceFrom(location: CLLocation(latitude: DefaultsManager.latitude, longitude: DefaultsManager.longitude)) {
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

    static func fetchReachDetail(reachID: String, callback: @escaping ReachDetailCallback) {
        let url = URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\(reachID)/.json")!

        let task = URLSession.shared.dataTask(with: url) { dataOptional, response, error in
            let decoder = JSONDecoder()

            guard let data = dataOptional,
                let detail = try? decoder.decode(AWReachDetailResponse.self, from: data) else {
                    print("Unable to decode \(reachID)")
                    if let data = dataOptional, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("info:")
                        print(json)
                    } else {
                        print("JSONSerilization can't unwrap it")
                    }
                    return

            }
            callback(detail.view.main)
        }
        task.resume()
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

            let info = awReachDetail.info

            context.perform {
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
                        do {
                            try context.save()
                            print("Reach detail background context saved")
                        } catch {
                            let error = error as NSError
                            print("unable to save background context \(error) \(error.userInfo)")
                        }
                        dispatchGroup.leave()
                    } else {
                        print("no reach found")
                    }
                } catch {
                    print("Unable to fetch reach")
                }
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
}
