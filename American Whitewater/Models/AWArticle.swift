
/*
 This represents the JSON that is returned from Alamofire and
 is used to create the CoreData values. This is modified
 from the original app design
*/

import Foundation
import SwiftyJSON

class AWArticle {
    
    var uid: Int?
    var contact: String?
    var articleid: String?
    var icon: String?
    var contentsPhoto: String?
    var abstractPhoto: String?
    var shortname: String?
    var author: String?
    var title: String?
    var abstract: String?
    var contents: String?
    var isoposted: String?
    var posted: String?
    var releasedate: String?
    var releaseepoch: String?
    var hascontents: Int?
    var postedepoch: String?
    var postedDate: String?
    var deleted: Int?
    
    init(json:JSON) {
        // first articleid reports as Integer
        // list show articleid as string
        let articleidInt: String? = json["article_id"].string
        
        uid = json["uid"].int
        contact = json["contact"].string
        articleid = articleidInt != nil ? "\(articleidInt!)" : json["id"].string
        icon = json["icon"].string
        contentsPhoto = json["contents_photo"].string
        abstractPhoto = json["abstract_photo"].string
        shortname = json["short_name"].string
        author = json["author"].string
        title = json["title"].string
        abstract = json["abstract"].string
        contents = json["contents"].string
        isoposted = json["isoposted"].string
        posted = json["posted"].string
        releasedate = json["release_date"].string
        releaseepoch = json["releaseepoch"].string
        hascontents = json["hascontents"].int
        postedepoch = json["postedepoch"].string
        deleted = json["deleted"].int
     
        //print("ArticleID: \(String(describing: articleid)) Author: \(String(describing: author)) Title: \(title ?? "Unknown")")
    }
    
    init(id: String?, posted_date: String?, short_name: String?, contents: String?, title: String?, abstract: String?, author: String?, icon: String?, abstract_image: String?) {
        
        self.articleid = id
        self.postedDate = posted_date
        self.shortname = short_name
        self.contents = contents
        self.title = title
        self.abstract = abstract
        self.author = author
        self.icon = icon
        self.abstractPhoto = abstract_image
    }        
}
