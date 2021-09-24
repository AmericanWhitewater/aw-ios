import Foundation
import GRDB
import CoreLocation

struct Rapid: Identifiable, Codable {
    var id: Int
    var reachId: Int
    var name: String?
    var description: String?
    var classRating: String?
    var isHazard: Bool
    var isPlaySpot: Bool
    var isPortage: Bool
    var isPutIn: Bool
    var isTakeOut: Bool
    var isWaterfall: Bool
    var lat: Double?
    var lon: Double?
    
    var location: CLLocation? {
        get {
            guard
                let lat = lat,
                let lon = lon
            else {
                return nil
            }
            return .init(latitude: lat, longitude: lon)
        }
        set {
            lat = newValue?.coordinate.latitude
            lon = newValue?.coordinate.longitude
        }
    }
    
    // TODO: Association for reach
//    @NSManaged public var reach: Reach?
}

extension Rapid: TableRecord, FetchableRecord, PersistableRecord {
    static let reach = belongsTo(Reach.self)
    
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let reachId = Column(CodingKeys.reachId)
        static let name = Column(CodingKeys.name)
        static let description = Column(CodingKeys.description)
        static let classRating = Column(CodingKeys.classRating)
        static let isHazard = Column(CodingKeys.isHazard)
        static let isPlaySpot = Column(CodingKeys.isPlaySpot)
        static let isPortage = Column(CodingKeys.isPortage)
        static let isPutIn = Column(CodingKeys.isPutIn)
        static let isTakeOut = Column(CodingKeys.isTakeOut)
        static let isWaterfall = Column(CodingKeys.isWaterfall)
        static let lat = Column(CodingKeys.lat)
        static let lon = Column(CodingKeys.lon)
    }
}

extension Reach {
    static let rapids = hasMany(Rapid.self)
    
    var rapids: QueryInterfaceRequest<Rapid> {
        request(for: Reach.rapids)
    }
}
