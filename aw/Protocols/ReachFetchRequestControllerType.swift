//
//  ReachFetchRequestControllerType.swift
//  aw
//
//  Created by Alex Kerney on 3/30/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation

protocol ReachFetchRequestControllerType {
    var managedObjectContext: NSManagedObjectContext? { get set }
    var fetchedResultsController: NSFetchedResultsController<Reach>? { get set }
    var predicates: [NSPredicate] { get set }
}

extension ReachFetchRequestControllerType {
    func initializeFetchedResultController() -> NSFetchedResultsController<Reach>? {
        guard let moc = managedObjectContext else { return nil }

        let request = NSFetchRequest<Reach>(entityName: "Reach")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: moc,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }

    func difficultiesPredicate() -> NSCompoundPredicate {
        var classPredicates: [NSPredicate] = []

        for difficulty in DefaultsManager.classFilter {
            classPredicates.append(NSPredicate(format: "difficulty\(difficulty) == TRUE"))
        }
        return NSCompoundPredicate(orPredicateWithSubpredicates: classPredicates)
    }

    func regionsPredicate() -> NSCompoundPredicate {
        var regionPredicates: [NSPredicate] = []

        for region in DefaultsManager.regionsFilter {
            regionPredicates.append(NSPredicate(format: "state = %@", region))
        }
        return NSCompoundPredicate(orPredicateWithSubpredicates: regionPredicates)
    }

    func distancePredicate() -> NSPredicate {
        let distance = DefaultsManager.distanceFilter
        return NSPredicate(format: "distance <= %lf", distance)
    }
}
