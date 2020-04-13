
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
    var contentsphoto: String?
    var abstractphoto: String?
    var contents_photo: String?
    var abstract_photo: String?
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
    var deleted: Int?
    
    init(json:JSON) {
        
        // first articleid reports as Integer
        // list show articleid as string
        let articleidInt: Int? = json["articleid"].int
        
        uid = json["uid"].int
        contact = json["contact"].string
        articleid = articleidInt != nil ? "\(articleidInt!)" : json["articleid"].string
        icon = json["icon"].string
        contentsphoto = json["contentsphoto"].string
        abstractphoto = json["abstractphoto"].string
        contents_photo = json["contents_photo"].string
        abstract_photo = json["abstract_photo"].string
        shortname = json["shortname"].string
        author = json["author"].string
        title = json["title"].string
        abstract = json["abstract"].string
        contents = json["contents"].string
        isoposted = json["isoposted"].string
        posted = json["posted"].string
        releasedate = json["releasedate"].string
        releaseepoch = json["releaseepoch"].string
        hascontents = json["hascontents"].int
        postedepoch = json["postedepoch"].string
        deleted = json["deleted"].int
     
        //print("ArticleID: \(String(describing: articleid)) Author: \(String(describing: author)) Title: \(title ?? "Unknown")")
    }
    
}
