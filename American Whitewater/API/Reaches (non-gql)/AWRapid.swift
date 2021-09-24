import Foundation
import SwiftyJSON
import CoreLocation

extension AWApiReachHelper {
    class AWRapid {
        let rapidId: Int?
        let name: String?
        let description: String?
        let difficulty: String?
        let rapidLatitude: String?
        let rapidLongitude: String?
        let photoId: String?
        var isHazard = false
        var isPlaySpot = false
        var isPortage = false
        var isPutIn = false
        var isTakeOut = false
        var isWaterfall = false
        
        init(json:JSON) {
            rapidId = Int(json["id"].string ?? "")
            name = json["name"].string
            description = json["description"].string
            rapidLatitude = json["rlat"].string
            rapidLongitude = json["rlon"].string
            
            // Often the API appears to return "0" to indicate no photo...
            if let photoId = json["photo_id"].string, photoId != "0" {
                self.photoId = photoId
            } else {
                self.photoId = nil
            }
            
            difficulty = json["difficulty"].string
            
            isHazard = (json["ishazard"].int ?? 0) == 1 ? true : false
            isPlaySpot = (json["isplayspot"].int ?? 0) == 1 ? true : false
            isPortage = (json["isportage"].int ?? 0) == 1 ? true : false
            isPutIn = (json["isputin"].int ?? 0) == 1 ? true : false
            isTakeOut = (json["istakeout"].int ?? 0) == 1 ? true : false
            isWaterfall = (json["iswaterfall"].int ?? 0) == 1 ? true : false
        }
    }
    
    /*
     // Format of Rapid JSON from server
     {
     "photoid" : 12214,
     "deleted" : false,
     "rlon" : "0",
     "description" : "Wesley Surfing @768 cfs @ Big Rock",
     "iswaterfall" : 0,
     "approximate" : false,
     "isaccess" : 0,
     "revision" : 2288,
     "isplayspot" : 1,
     "ishazard" : 0,
     "distance" : "0",
     "rapidid" : 2063,
     "istakeout" : 0,
     "reachid" : 1768,
     "videoid" : null,
     "rlat" : "0",
     "name" : "Big Rock",
     "isputin" : 0,
     "difficulty" : "II+",
     "isportage" : 0,
     "created_at" : "2019-01-24 22:28:08.308291",
     "rloc" : null,
     "is_final" : true
     }
     */
}
