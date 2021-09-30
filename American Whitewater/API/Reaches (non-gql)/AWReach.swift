
/*
 This represents the JSON that is returned from Alamofire and
 is used to create the CoreData values. This is modified
 from the original app design
 */


import Foundation
import SwiftyJSON
import CoreLocation

extension AWApiReachHelper {
    class AWReach {
        var id: Int?
        var name: String?
        var section: String?
        var river: String?
        var altname: String?
        var classRating: String?
        
        var county: String?
        var state: String?
        
        var reading_formatted: String?
        var reading_delta: String?
        var last_gauge_reading: String?
        var gauge_reading: String?
        var gauge_min: String?
        
        var unit: String?
        var cond: String?
        
        var zipcode: String?
        var plat: String?
        var plon: String?
        var tlat: String?
        var tlon: String?
        
        var updated: String?
        var gauge_metric: Int?
        var status: String?
        var range_comment: String?
        var gauge_estimated: Bool?
        var skid: Int?
        var rid: Int?
        var gauge_id: Int?
        var rc: String?
        var last_journal_update: String?
        var obs_id: Int64?
        var reading: String?
        var huc: String?
        var gauge_perfect: String?
        var abstract: String?
        var adjusted_reach_class: String?
        var color: String?
        var gauge_data: String?
        var river_data: String?
        var units: String?
        var last_gauge_updated: String?
        var gauge_max: String?
        var gauge_comment: String?
        var gauge_important: String?
        var ploc: String?
        var tloc: String?
        
        // key river details added in details lookup
        // note: not all fields are here
        var detailDescription: String?
        var detailShuttleDescription: String?
        var detailLength: String?
        var detailGaugeInfo: String?
        var detailAverageGradient: Int?
        var detailRapidsListString: String?
        var detailRapidsList: [JSON]?
        
        // storing the original JSON for reference in case we need it later
        var origJSON: JSON?
        var origDetailsJSON: JSON?
        
        // store the location from the user for speedy look up
        // this is updated on location change events
        var distanceToUser: Double?
        
        
        init(json:JSON) {
            // store original json
            origJSON = json
            
            id = json["id"].int
            name = json["name"].string
            section = json["section"].string
            river = json["river"].string
            altname = json["altname"].string
            classRating = json["class"].string
            county = json["county"].string
            state = json["state"].string
            reading_formatted = json["reading_formatted"].string
            reading_delta = json["reading_delta"].string
            last_gauge_reading = json["last_gauge_reading"].string
            gauge_reading = json["gauge_reading"].string
            gauge_min = json["gauge_min"].string
            unit = json["unit"].string
            cond = json["cond"].string
            zipcode = json["zipcode"].string
            plat = json["plat"].string
            plon = json["plon"].string
            tlat = json["tlat"].string
            tlon = json["tlon"].string
            updated = json["updated"].string
            gauge_metric = json["gauge_metric"].int
            status = json["status"].string
            range_comment = json["range_comment"].string
            gauge_estimated = json["gauge_estimated"].bool
            skid = json["skid"].int
            rid = json["rid"].int
            gauge_id = json["gauge_id"].int
            rc = json["rc"].string
            last_journal_update = json["last_journal_update"].string
            obs_id = json["obs_id"].int64
            reading = json["reading"].string
            huc = json["huc"].string
            gauge_perfect = json["gauge_perfect"].string
            abstract = json["abstract"].string
            adjusted_reach_class = json["adjusted_reach_class"].string
            color = json["color"].string
            gauge_data = json["gauge_data"].string
            river_data = json["river_data"].string
            units = json["units"].string
            last_gauge_updated = json["last_gauge_updated"].string
            gauge_max = json["gauge_max"].string
            gauge_comment = json["gauge_comment"].string
            gauge_important = json["gauge_important"].string
            ploc = json["ploc"].string
            tloc = json["tloc"].string
        }
        
        
        func setDetails(detailsJson: JSON) {
            
            // save original JSON
            origDetailsJSON = detailsJson
            //print(origDetailsJSON.debugDescription)
            
            // now set reach details
            if let CContainerViewJSON_view = detailsJson["CContainerViewJSON_view"].dictionary,
               let CRiverMainGadgetJSON_main = CContainerViewJSON_view["CRiverMainGadgetJSON_main"]?.dictionary,
               let info = CRiverMainGadgetJSON_main["info"]?.dictionary {
                
                detailDescription = info["description"]?.string
                detailShuttleDescription = info["shuttledetails"]?.string
                detailLength = info["length"]?.string
                detailGaugeInfo = info["gaugeinfo"]?.string
                detailAverageGradient = info["avggradient"]?.int
                
                //print(CContainerViewJSON_view.debugDescription)
                if let CRiverRapidsGadgetJSON_view_rapids = CContainerViewJSON_view["CRiverRapidsGadgetJSON_view-rapids"] {
                    if let rapids = CRiverRapidsGadgetJSON_view_rapids["rapids"].array {
                        //print(rapids)
                        detailRapidsList = rapids
                        detailRapidsListString = rapids.description
                    }
                }
            }
        }
        
        
        func getString() -> String? {
            if let origJSON = origJSON {
                if let jsonString = origJSON.rawString() {
                    print("\(jsonString)")
                    return jsonString
                }
                
                return nil
            }
            
            return nil
        }
        
        
        func distanceFrom(location: CLLocation) -> Double? {
            guard let lat = plat, let latitude = Double(lat),
                  let lon = plon, let longitude = Double(lon) else { return nil }
            
            let reachCoordinate = CLLocation(latitude: latitude, longitude: longitude)
            
            guard CLLocationCoordinate2DIsValid(reachCoordinate.coordinate) else { return nil }
            
            return reachCoordinate.distance(from: location)
        }
        
    }
}
