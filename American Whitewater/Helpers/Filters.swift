//
//  Filters.swift
//  Filters
//
//  Created by Phillip Kast on 7/28/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation

struct Filters {
    // FIXME: currently it appears that the app tries to treat these as a toggle, i.e. if showDistanceFilter = true, showRegionFilter must be false and vice versa. So why have both? Or should it be an enum?
    // (See below, the predicates mostly
    var showDistanceFilter: Bool
    var showRegionFilter: Bool
    
    var regionsFilter: [String]
    var distanceFilter: Double
    var classFilter: [Int]
    var runnableFilter: Bool
    
    //
    // MARK: - Some defaults for first run or resetting
    //
    
    static let defaultByRegionFilters = Filters(        
        showDistanceFilter: false,
        showRegionFilter: true,
        regionsFilter: [], // FIXME?
        distanceFilter: 100,
        classFilter: [1,2,3,4,5],
        runnableFilter: false
    )
}

//
// MARK: - Predicates
//

extension Filters {
    private var runnablePredicate: NSPredicate? {
        guard runnableFilter else {
            return nil
        }
        
        return NSPredicate(format: "condition == %@ || condition == %@", "med", "high")
    }
    
    private var difficultiesPredicate: NSCompoundPredicate? {
        guard !classFilter.isEmpty else {
            return nil
        }
        
        let classPredicates = classFilter.map {
            NSPredicate(format: "difficulty\($0) == TRUE")
        }

        return NSCompoundPredicate(orPredicateWithSubpredicates: classPredicates)
    }
    
    private var regionsPredicate: NSPredicate? {
        // if we are filtering by distance then ignore regions
        // FIXME: surely this should be changed to `guard showRegionFilter else { return nil }`? (but see fixme above about these props)
        if showDistanceFilter {
            return nil
        }
        
        let states = regionsFilter.compactMap {
            Region.regionByCode(code: $0)?.apiResponse
        }
        
        guard !states.isEmpty else {
            return nil
        }
        
        return NSPredicate(format: "state IN[cd] %@", states)
    }

    private var distancePredicate: NSPredicate? {
        guard
            showDistanceFilter,
            distanceFilter > 0
        else {
            return nil
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "distance <= %lf", distanceFilter),
            NSPredicate(format: "distance != 0") // hide invalid distances
        ])
    }
    
    // based on our filtering settings (distance, region, or class) we request Reaches that
    // match these settings
    public func combinedPredicate() -> NSPredicate {
        let subPredicates = [
            difficultiesPredicate,
            runnablePredicate,
            distancePredicate,
            regionsPredicate
        ]
            .compactMap { $0 }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
    }
}

//
// MARK: - Sort descriptors
//
    
extension Filters {
    public static let sortByDistanceAndName = [
        NSSortDescriptor(key: "distance", ascending: true),
        NSSortDescriptor(key: "name", ascending: true)
    ]
    
    public static let sortByName = [
        NSSortDescriptor(key: "name", ascending: true),
        NSSortDescriptor(key: "sortName", ascending: true)
    ]
    
    public var sortDescriptors: [NSSortDescriptor] {
        if showDistanceFilter, distanceFilter > 0 {
            return Self.sortByDistanceAndName
        } else {
            return Self.sortByName
        }
    }
}
