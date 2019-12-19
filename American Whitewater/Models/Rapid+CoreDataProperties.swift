import Foundation
import CoreData


extension Rapid {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rapid> {
        return NSFetchRequest<Rapid>(entityName: "Rapid")
    }

    @NSManaged public var difficulty: String?
    @NSManaged public var id: Int32
    @NSManaged public var isHazard: Bool
    @NSManaged public var isPlaySpot: Bool
    @NSManaged public var isPortage: Bool
    @NSManaged public var isPutIn: Bool
    @NSManaged public var isTakeOut: Bool
    @NSManaged public var isWaterfall: Bool
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var rapidDescription: String?
    @NSManaged public var reach: Reach?

}
