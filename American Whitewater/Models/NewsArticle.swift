//
//  NewsArticle+CoreDataProperties.swift
//  
//
//  Created by David Nelson on 10/5/20.
//
//

import Foundation
import CoreData

public class NewsArticle: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticle> {
        return NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
    }

    @NSManaged public var abstract: String?
    @NSManaged public var abstractImage: String?
    @NSManaged public var author: String?
    @NSManaged public var contents: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var postedDate: String?
    @NSManaged public var shortName: String?
    @NSManaged public var title: String?
    @NSManaged public var uid: String?
    @NSManaged public var releaseDate: String?

}
