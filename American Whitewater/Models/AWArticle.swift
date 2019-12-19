
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

/*
 

 {

 
 "uid" : 7113,
 "contact" : "7113",
 "articleid" : "34294",
 "icon" : null,
 "contentsphoto" : "34294.jpg",
 "abstractphoto" : "34294.jpg",
 "contents_photo" : "34294.jpg",
 "abstract_photo" : "34294.jpg",
 "shortname" : "",
 "author" : "Evan Stafford"
 "title" : "Submit Your Best Images For the 2020 American Whitewater Calendar!",
 "abstract" : "<p><a href=\"https:\/\/bit.ly\/2020AWCalendarSubmissions\" target=\"_blank\">Submit your best photos for the American Whitewater Calendar! <\/a>Many of the best whitewater rivers in this country are on public lands, but our rivers on public lands also face a number of challenges. For our 2020 calendar we're celebrating these incredible rivers that belong to all of us in an effort to encourage your enjoyment of them and their protection. Images that feature rivers on public lands will be given the highest consideration and bonus points for images that feature current, past or future American Whitewater projects.&nbsp;<\/p>",
 "contents" : "<p><a href=\"https:\/\/bit.ly\/2020AWCalendarSubmissions\" target=\"_blank\" style=\"color: rgb(71, 125, 202);\">Submit your best photos for the American Whitewater Calendar!<\/a>&nbsp;Many of the best whitewater rivers in this country are on public lands, but our rivers on public lands also face a number of challenges. For our 2020 calendar we're celebrating these incredible rivers that belong to all of us in an effort to encourage your enjoyment of them and their protection. Images that feature rivers on public lands will be given the highest consideration and bonus points for images that feature current, past or future American Whitewater projects.&nbsp;The deadline for submission is Aug 23rd, 2019. Thank you!<\/p>",

 "isoposted" : "2019-08-07 19:08:43-04",
 "posted" : "2019-08-07 19:08:43-04",
 "releasedate" : "2019-08-07 19:08:43-04",

 "releaseepoch" : "1565219323",
 "hascontents" : 1,
 "postedepoch" : "1565219323",
 "deleted" : 0,

 
 },
 
 
 */
