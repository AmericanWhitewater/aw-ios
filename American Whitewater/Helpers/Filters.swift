import Foundation
import GRDB
import CoreLocation
import MapKit

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
    func filter(by filters: Filters, from userLocation: CLLocationCoordinate2D? = nil) -> Self {
        self
            .difficultiesFilter(filters.classFilter)
            .runnableFilter(filters.runnableFilter)
            .distanceFilter(max: filters.isDistance ? filters.distanceFilter : nil, from: userLocation)
            .regionsFilter(filters.isRegion, filters.regionsFilter)
    }
    
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
    
    /// Appproximate distance predicate: returns a predicate for reaches in a bounding box with sides roughly `distance` away from `coordinate`.
    private func distanceFilter(max miles: Double?, from coordinate: CLLocationCoordinate2D?) -> Self {
        guard
            let coordinate = coordinate,
            let miles = miles
        else {
            return self
        }
        
        let meters = Measurement(value: miles, unit: UnitLength.miles)
            .converted(to: UnitLength.meters)
            .value
        
        // Use MapKit to get a region thats 2x distance on each side, centered on location
        // FIXME: What I'm doing here is not quite right: it doesn't handle crossing the prime meridian or wrapping over a pole. Should be mostly OK for spans of a few 100 miles in the continental US, but my experience has been that stuff like this tends to come back and bite you -- should revisit.
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: meters * 2,
            longitudinalMeters: meters * 2
        )
        
        // subtract to get bounding box
        let minLat = coordinate.latitude - (region.span.latitudeDelta / 2)
        let maxLat = coordinate.latitude + (region.span.latitudeDelta / 2)
        let minLon = coordinate.longitude - (region.span.longitudeDelta / 2)
        let maxLon = coordinate.longitude + (region.span.longitudeDelta / 2)
                
        // Check that put in is withing bounding box
        return filter(
            Reach.Columns.putInLat >= minLat &&
            Reach.Columns.putInLon >= minLon &&
            Reach.Columns.putInLat <= maxLat &&
            Reach.Columns.putInLon <= maxLon
        )
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
