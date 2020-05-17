/*
 This represents the JSON that is returned from Alamofire and
 is used to create the CoreData values. This is modified
 from the original app design
*/

import Foundation
import SwiftyJSON
import CoreLocation

class AWReachDetail {

    var detailDescription: String?
    var detailShuttleDescription: String?
    var detailLength: String?
    var detailGaugeInfo: String?
    var detailAverageGradient: Int?
    var detailRapidsListString: String?
    var detailRapidsList: [JSON]?
    var detailPhotoId: Int?
    var detailPhotoUrl: String?
    var detailMaxGradient: Int?
    var detailGageName: String?
    
    var detailRapids: [AWRapid]?
    
    init(detailsJson:JSON) {
        //print(detailsJson.debugDescription)
        // now set reach details
        if let CContainerViewJSON_view = detailsJson["CContainerViewJSON_view"].dictionary,
           let CRiverMainGadgetJSON_main = CContainerViewJSON_view["CRiverMainGadgetJSON_main"]?.dictionary,
           let info = CRiverMainGadgetJSON_main["info"]?.dictionary {
            detailDescription = info["description"]?.string
            detailShuttleDescription = info["shuttledetails"]?.string
            detailLength = info["length"]?.string
            detailGaugeInfo = info["gaugeinfo"]?.string
            detailAverageGradient = info["avggradient"]?.int
            detailMaxGradient = info["maxgradient"]?.int
            detailPhotoId = info["photoid"]?.int
            detailPhotoUrl = info["photourl"]?.string
            
            
            if let gadgetSummary = CRiverMainGadgetJSON_main["guagesummary"] {
                if let summary = gadgetSummary.dictionary {
                    //print("class: \(summary["default_class"]?.string ?? "n/a")")
                    if let rangesJSON = summary["ranges"] {
                        if let ranges = rangesJSON.array {
                            if let gauge = ranges.first {
                                let name = gauge["gauge_name"].string ?? "n/a"
                                //print("Gage Name: \(name)")
                                detailGageName = name
                            }
                        }
                    }
                }
            }
            
            //print(CContainerViewJSON_view.debugDescription)
            if let CRiverRapidsGadgetJSON_view_rapids = CContainerViewJSON_view["CRiverRapidsGadgetJSON_view-rapids"] {
                if let rapids = CRiverRapidsGadgetJSON_view_rapids["rapids"].array {
                    //print(rapids)
                    detailRapidsList = rapids
                    detailRapidsListString = rapids.description
                    
                    // Create AWRapid objects for later processing
                    detailRapids = []
                    for rapid in rapids {
                        detailRapids?.append(AWRapid(json: rapid))
                    }
                }
            }
            
        }

    }

    
}
