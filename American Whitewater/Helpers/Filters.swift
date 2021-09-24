import Foundation
import GRDB

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
}

// Custom requests to implement filters.
// See https://github.com/groue/GRDB.swift/blob/master/Documentation/GoodPracticesForDesigningRecordTypes.md#define-record-requests
extension DerivableRequest where RowDecoder == Reach {
    func filter(by filters: Filters) -> Self {
        self
            .difficultiesFilter(filters.classFilter)
            .runnableFilter(filters.runnableFilter)
            .distanceFilter(filters.isDistance, filters.distanceFilter)
            .regionsFilter(filters.isRegion, filters.regionsFilter)
    }
    
    
    // based on our filtering settings (distance, region, or class) we request Reaches that
    // match these settings
//    public func combinedPredicate() -> NSPredicate {
//        let subPredicates = [
//            difficultiesPredicate,
//            runnablePredicate,
//            distancePredicate,
//            regionsPredicate
//        ]
//            .compactMap { $0 }
//
//        return NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
//    }
    
    private func runnableFilter(_ onlyRunnable: Bool) -> Self {
        if onlyRunnable {
            return filter(["med", "high"].contains(Reach.Columns.condition))
        } else {
            return self
        }
    }
    
    private func difficultiesFilter(_ classFilter: [Int]) -> Self {
        guard !classFilter.isEmpty else {
            return self
        }
        
        return filter(classFilter
            .map { Column("isClass\($0)") == true }
            .joined(operator: .or)
        )
    }
    
    private func regionsFilter(_ isRegion: Bool, _ regions: [String]) -> Self {
        if !isRegion {
            return self
        }
        
        let states = regions.compactMap { Region.regionByCode(code: $0)?.apiResponse }
        
        guard !states.isEmpty else {
            return self
        }
        
        return filter(states.contains(Reach.Columns.state))
    }
    
    private func distanceFilter(_ isDistance: Bool, _ distanceFilter: Double) -> Self {
        guard
            isDistance,
            distanceFilter > 0
        else {
            return self
        }
        
        // FIXME: put distance filter back using geobox
        return self
//        return [
//            Reach.Columns.distance <= distanceFilter,
//            Reach.Columns.distance != 0
//        ]
//            .joined(operator: .and)
    }
    
    
    //
    // MARK: - Orderings
    //
    
//    var sortByDistanceAndName: Self {
//        .order(Reach.Columns.distance)
//    }
//
//
//    = [
//        NSSortDescriptor(key: "distance", ascending: true),
//        NSSortDescriptor(key: "name", ascending: true)
//    ]
//
//    public static let sortByName = [
//        NSSortDescriptor(key: "name", ascending: true),
//        NSSortDescriptor(key: "section", ascending: true)
//    ]
//
//    public var sortDescriptors: [NSSortDescriptor] {
//        if isDistance, distanceFilter > 0 {
//            return Self.sortByDistanceAndName
//        } else {
//            return Self.sortByName
//        }
//    }
}
