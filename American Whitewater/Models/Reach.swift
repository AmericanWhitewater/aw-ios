import Foundation
import GRDB
import CoreLocation

struct Reach: Identifiable, Codable {
    var id: Int
    var createdAt: Date
    
    var altname: String?
    var avgGradient: Int
    var maxGradient: Int
    var condition: String?
    var county: String?
    var currentGageReading: String?
    var delta: String?
    var description: String?
    var detailUpdated: Date?
    var classRating: String?
    var isClass1: Bool
    var isClass2: Bool
    var isClass3: Bool
    var isClass4: Bool
    var isClass5: Bool
    var favorite: Bool // TODO: move out of this model
    var gageId: Int?
    var gageMax: String?
    var gageMetric: Int
    var gageMin: String?
    var gageUpdated: Date?
    var lastGageReading: String?
    var length: Double?
    var name: String?
    var photoId: Int
    var putInLat: Double?
    var putInLon: Double?
    var takeOutLat: Double?
    var takeOutLon: Double?
    var rc: String?
    var river: String?
    var section: String?
    var shuttleDetails: String?
    var state: String?
    var unit: String?
    var zipcode: String?
    
    var putIn: CLLocation? {
        get {
            guard let lat = putInLat, let lon = putInLon else {
                return nil
            }
            
            return .init(latitude: lat, longitude: lon)
        }
        
        set {
            putInLat = newValue?.coordinate.latitude
            putInLon = newValue?.coordinate.longitude
        }
    }
    
    var takeOut: CLLocation? {
        get {
            guard let lat = takeOutLat, let lon = takeOutLon else {
                return nil
            }
            
            return .init(latitude: lat, longitude: lon)
        }
        
        set {
            takeOutLat = newValue?.coordinate.latitude
            takeOutLon = newValue?.coordinate.longitude
        }
    }
}

extension Reach: TableRecord, FetchableRecord, PersistableRecord {
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let createdAt = Column(CodingKeys.createdAt)
        static let altname = Column(CodingKeys.altname)
        static let avgGradient = Column(CodingKeys.avgGradient)
        static let maxGradient = Column(CodingKeys.maxGradient)
        static let condition = Column(CodingKeys.condition)
        static let county = Column(CodingKeys.county)
        static let currentGageReading = Column(CodingKeys.currentGageReading)
        static let delta = Column(CodingKeys.delta)
        static let description = Column(CodingKeys.description)
        static let detailUpdated = Column(CodingKeys.detailUpdated)
        static let classRating = Column(CodingKeys.classRating)
        static let isClass1 = Column(CodingKeys.isClass1)
        static let isClass2 = Column(CodingKeys.isClass2)
        static let isClass3 = Column(CodingKeys.isClass3)
        static let isClass4 = Column(CodingKeys.isClass4)
        static let isClass5 = Column(CodingKeys.isClass5)
        static let favorite = Column(CodingKeys.favorite)
        static let gageId = Column(CodingKeys.gageId)
        static let gageMax = Column(CodingKeys.gageMax)
        static let gageMetric = Column(CodingKeys.gageMetric)
        static let gageMin = Column(CodingKeys.gageMin)
        static let gageUpdated = Column(CodingKeys.gageUpdated)
        static let lastGageReading = Column(CodingKeys.lastGageReading)
        static let length = Column(CodingKeys.length)
        static let name = Column(CodingKeys.name)
        static let photoId = Column(CodingKeys.photoId)
        static let putInLat = Column(CodingKeys.putInLat)
        static let putInLon = Column(CodingKeys.putInLon)
        static let takeOutLat = Column(CodingKeys.takeOutLat)
        static let takeOutLon = Column(CodingKeys.takeOutLon)
        static let rc = Column(CodingKeys.rc)
        static let river = Column(CodingKeys.river)
        static let section = Column(CodingKeys.section)
        static let shuttleDetails = Column(CodingKeys.shuttleDetails)
        static let state = Column(CodingKeys.state)
        static let unit = Column(CodingKeys.unit)
        static let zipcode = Column(CodingKeys.zipcode)
    }
}

extension DerivableRequest where RowDecoder == Reach {
    func isFavorite() -> Self {
        filter(Reach.Columns.favorite == true)
    }
    
    func search(_ query: String?) -> Self {
        guard let query = query, !query.isEmpty else {
            return self
        }
        
        let like = "%\(query)%"
        
        return filter(literal: "name LIKE \(like) OR section LIKE \(like)")
    }
}

extension Array where Element == Reach {
    func sortedByDistance(from location: CLLocation?) -> [Reach] {
        guard let location = location else {
            return self
        }
        
        // Map to a tuple of (distance, reach)
        return map {
            ($0.putIn?.distance(from: location), $0)
        }
        // Sort by distance asc, with nils last
        .sorted { ($0.0 ?? 99999) <= ($1.0 ?? 99999) }
        // Extract reach for return
        .map(\.1)
    }
}
