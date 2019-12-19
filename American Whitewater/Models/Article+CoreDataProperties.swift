import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var abstract: String?
    @NSManaged public var abstractPhoto: String?
    @NSManaged public var articleId: String?
    @NSManaged public var author: String?
    @NSManaged public var contact: String?
    @NSManaged public var contents: String?
    @NSManaged public var contentsPhoto: String?
    @NSManaged public var icon: String?
    @NSManaged public var posted: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var shortname: String?
    @NSManaged public var title: String?

}
