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
    static let shared = AWApiHelper()
    
    typealias ReachCallback = ([AWReach]?) -> Void
    
    func fetchReaches(callback: @escaping ReachCallback) {
        
        guard let url = URL(string: riverURL) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("Data retrieved from AW API, decoding reaches")
            let decoder = JSONDecoder()
            guard let data = data, let reaches = try? decoder.decode([AWReach].self, from: data) else { return }
            
            callback(reaches)
        }
        task.resume()
    }
    
    func fetchReachesByRegion(region: String, callback: @escaping ReachCallback) {
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
    
    func conditionFromApi(condition: String) -> Condition {
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
    
    func findOrNewReach(byID id: Int, inContext context: NSManagedObjectContext) -> Reach {
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
    
    fileprivate func setupReach(_ reach: Reach, newReach: AWReach) {
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
    
    func createOrUpdateReach(newReach: AWReach, context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        context.persist {
            let reach = self.findOrNewReach(byID: newReach.id, inContext: context)
            self.setupReach(reach, newReach: newReach)
        }
    }
    
    
    func createOrUpdateReaches(newReaches: [AWReach], context: NSManagedObjectContext) {
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
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func createOrUpdateReach(newReach: AWReach) {
        DispatchQueue.main.async(qos: .utility) {
            let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            
            let context = container.viewContext

            //container.performBackgroundTask { (context) in
            self.createOrUpdateReach(newReach: newReach, context: context)
            //}
        }
    }
    
    
    func updateReaches() {
        fetchReaches() { (reaches) in
            guard let reaches = reaches else { return }
            
            print("reaches fetched from API:", reaches.count)
            /*
            for reach in reaches {
                self.createOrUpdateReach(newReach: reach)
            }
            */
            
        }
    }
    
    
    func updateReachesForAllRegions() {
        for region in Region.all {
            self.fetchReachesByRegion(region: region.code) { (reaches) in
                guard let reaches = reaches else { return }
                
                print("reaches fetched from API for \(region.title): \(reaches.count)")
                
                for reach in reaches {
                    self.createOrUpdateReach(newReach: reach)
                }
                /*
                DispatchQueue.main.async(qos: .utility) {
                    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
                    
                    let context = container.viewContext
                    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    
                    privateMOC.perform {
                        self.createOrUpdateReaches(newReaches: reaches, context: privateMOC)
                        do {
                            try privateMOC.save()
                            context.performAndWait {
                                do {
                                    try context.save()
                                } catch {
                                    fatalError("Failure to save viewContext: \(error)")
                                }
                            }
                        } catch {
                            fatalError("Failure to save private context: \(error)")
                        }
                    }
                }
                */
            }
        }
    }
    
    func updateReachesForAllRegionsAsync() {
        DispatchQueue.global(qos: .utility).async {
            self.updateReachesForAllRegions()
        }
    }
}
