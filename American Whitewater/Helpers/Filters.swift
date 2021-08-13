import Foundation

enum FilterType: String {
    case region
    case distance
}

struct Filters: Equatable {
    var filterType: FilterType
    
    var regionsFilter: [String]
    var distanceFilter: Double
    var classFilter: [Int]
    var runnableFilter: Bool
    
    //
    // MARK: - Some defaults for first run or resetting
    //
    
    static let defaultByRegionFilters = Filters(
        filterType: .region,
        regionsFilter: [], // FIXME?
        distanceFilter: 100,
        classFilter: [1,2,3,4,5],
        runnableFilter: false
    )
    
    static let defaultByDistanceFilters = Filters(
        filterType: .distance,
        regionsFilter: [],
        distanceFilter: 100,
        classFilter: [1,2,3,4,5],
        runnableFilter: false
    )
    public var isRegion: Bool {
        return filterType == .region
    }
    
    public var isDistance: Bool {
        return filterType == .distance
    }
    
    //
    // MARK: - Predicates
    //
    
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
        if !isRegion {
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
            isDistance,
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
    
    //
    // MARK: - Sort descriptors
    //
    
    public static let sortByDistanceAndName = [
        NSSortDescriptor(key: "distance", ascending: true),
        NSSortDescriptor(key: "name", ascending: true)
    ]
    
    public static let sortByName = [
        NSSortDescriptor(key: "name", ascending: true),
        NSSortDescriptor(key: "sortName", ascending: true)
    ]
    
    public var sortDescriptors: [NSSortDescriptor] {
        if isDistance, distanceFilter > 0 {
            return Self.sortByDistanceAndName
        } else {
            return Self.sortByName
        }
    }
}
