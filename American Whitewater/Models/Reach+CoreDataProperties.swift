import Foundation
import CoreData


extension Reach {

    @nonobjc public class func reachFetchRequest() -> NSFetchRequest<Reach> {
        return NSFetchRequest<Reach>(entityName: "Reach")
    }

    @NSManaged public var altname: String?
    @NSManaged public var avgGradient: Int16
    @NSManaged public var maxGradient: Int16
    @NSManaged public var classRating: String?
    @NSManaged public var condition: String?
    @NSManaged public var county: String?
    @NSManaged public var currentGageReading: String?
    @NSManaged public var delta: String?
    @NSManaged public var detailUpdated: Date?
    @NSManaged public var difficulty: String?
    @NSManaged public var difficulty1: Bool
    @NSManaged public var difficulty2: Bool
    @NSManaged public var difficulty3: Bool
    @NSManaged public var difficulty4: Bool
    @NSManaged public var difficulty5: Bool
    @NSManaged public var distance: Double
    @NSManaged public var favorite: Bool
    @NSManaged public var gageId: Int32
    @NSManaged public var gageMax: String?
    @NSManaged public var gageMetric: Int16
    @NSManaged public var gageMin: String?
    @NSManaged public var gageName: String?    
    @NSManaged public var gageUpdated: Date?
    @NSManaged public var id: Int
    @NSManaged public var lastGageReading: String?
    @NSManaged public var length: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var photoId: Int32
    @NSManaged public var putInLat: String?
    @NSManaged public var putInLon: String?
    @NSManaged public var rc: String?
    @NSManaged public var river: String?
    @NSManaged public var section: String?
    @NSManaged public var shuttleDetails: String?
    @NSManaged public var sortName: String?
    @NSManaged public var state: String?
    @NSManaged public var takeOutLat: String?
    @NSManaged public var takeOutLon: String?
    @NSManaged public var unit: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var rapids: NSSet?

}

// MARK: Generated accessors for rapids
extension Reach {

    @objc(addRapidsObject:)
    @NSManaged public func addToRapids(_ value: Rapid)

    @objc(removeRapidsObject:)
    @NSManaged public func removeFromRapids(_ value: Rapid)

    @objc(addRapids:)
    @NSManaged public func addToRapids(_ values: NSSet)

    @objc(removeRapids:)
    @NSManaged public func removeFromRapids(_ values: NSSet)

}
