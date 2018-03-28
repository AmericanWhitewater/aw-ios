//
//  AWApiHelper.swift
//  aw
//
//  Created by Alex Kerney on 3/23/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation
import UIKit

let baseURL = "https://www.americanwhitewater.org/content/"

let riverURL = baseURL + "River/search/.json"

struct AWReach: Codable {
    let difficulty: String
    let condition: String
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
        case id, name, section, unit, state, delta
        case difficulty = "class"
        case condition = "cond"
        case putInLat = "plat"
        case putInLon = "plon"
        case lastGageReading = "last_gauge_reading" // "reading_formatted"
        case takeOutLat = "tlat"
        case takeOutLon = "tlon"
    }
}

struct Condition {
    let name: String
    let color: UIColor
}

struct AWApiHelper {
    typealias ReachCallback = ([AWReach]?) -> Void
    typealias UpdateCallback = () -> Void

    static func conditionFromApi(condition: String) -> Condition {
        switch condition {
        case "low":
            return Condition(name: "Low", color: UIColor(named: "status_yellow")!)
        case "med":
            return Condition(name: "Runnable", color: UIColor(named: "status_green")!)
        case "high":
            return Condition(name: "High", color: UIColor(named: "status_red")!)
        default:
            return Condition(name: "No Info", color: UIColor(named: "status_grey")!)
        }
    }

    static func fetchReachesByRegion(region: String, callback: @escaping ReachCallback) {
        let url_string = riverURL + "?state=\(region)"

        guard let url = URL(string: url_string) else { return }

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
            callback()
        }
    }
}
