
// This was the web-based / non-CoreData version
// of the API Helper class
//
//import Foundation
//import Alamofire
//import SwiftyJSON
//import CoreLocation
//
//protocol AWApiHelperDelegate: AnyObject {
//    func awApiDidReceiveRiverData(_ riverData:[AWReach])
//    func awApiDidReceiveRiverDetailsData(_ riverDetailData:AWReach)
//    func awApiDidReceiveNewsData(_ newsArticles:[AWArticle])
//    func awApiDidReceiveError(_ error: Error?, customMessage: String?)
//}
//
//// set static address assets
////let baseURL = "https://www.americanwhitewater.org/content/"
////let riverURL = baseURL + "River/search/.json"
////let articleURL = baseURL + "News/all/type/frontpagenews/subtype//page/0/.json"
////let baseGaugeDetailURL = baseURL + "River/detail/id/"
////https://www.americanwhitewater.org/content/News/all/type/frontpagenews/subtype//page/0/.json
//
//
//class AWApiHelper {
//    
//    // setup our singleton for the api helper class
//    static let shared = AWApiHelper()
//    
//    //private let geoCoder = CLGeocoder();
//    
//    private init() {} // prevent any other default initializer
//    
//    // setup delegate that we'll use for messaging
//    weak var delegate: AWApiHelperDelegate?
//    
//    private var articlesList:[AWArticle] = []
//    private var riversList:[AWReach] = []
//    
//    private var usersFavorites:[AWReach] = []
//        
//    // any class wanting feedback from this singleton can opt-in by implementing the api delegate
//    // but they must register as the delegate
//    func setDelegate(delegate: AWApiHelperDelegate) {
//        self.delegate = delegate
//    }
//    
//    public func getCurrentRiversList(responseDelegate: AWApiHelperDelegate) {
//        self.delegate = responseDelegate
//        
//        if riversList.count == 0 {
//            self.fetchRegionalReaches()
//        } else {
//            if let delegate = self.delegate {
//                delegate.awApiDidReceiveRiverData(riversList)
//            }
//        }
//    }
//    
//    private func fetchReachesByRegion(region: String) {
//        let urlString = riverURL + "?state=\(region)"
//        
//        Alamofire.request(urlString).responseJSON { (response) in
//            
//            switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    //print("\(json.debugDescription)")
//                    self.processRiverData(json: json)
//                    
//                case .failure(let error):
//                    print("Error! with call: \(error.localizedDescription)")
//                    DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.localizedDescription)
//            }
//        }
//    }
//    
//    // Switch to Recursive call to get data one call at a time
//    // Right now if you select all regions it's going to kill the calls
//    // and we risk timeouts if on a slower connection
//    func fetchRegionalReaches() {
//        let regionCodes = DefaultsManager.regionsFilter
//        
//        if regionCodes.count == 0 {
//            if let delegate = self.delegate {
//                delegate.awApiDidReceiveError(nil, customMessage: "Please Select a Region in Filters.")
//                return
//            }
//        }
//        
//        print("There are \(regionCodes.count) region codes")
//        var regions:[Region] = []
//        
//        for regionCode in regionCodes {
//            
//            // build our list of regions
//            let region = Region.regionByCode(code: regionCode)
//            if let region = region {
//                regions.append(region)
//            }
//            
//            fetchReachRecursive(currentIndex: 0, allRegions: regions, allRiverJSONData: [])
//            
////            print("Fetching Region Code: \(regionCode)")
////            self.fetchReachesByRegion(region: regionCode)
//        }
//    }
//    
//    
//    func fetchReachDetail(reachId: Int) {
//        let detailsUrlString = "\(baseGaugeDetailURL)\(reachId)/.json"
//        //print("Calling: \(detailsUrlString)")
//        
//        Alamofire.request(detailsUrlString).responseJSON { (response) in
//            
//            switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    
//                    guard let updatedReach = self.processRiverDetailsData(reachId: reachId, json: json) else { return }
//                    
//                    if let delegate = self.delegate {
//                        delegate.awApiDidReceiveRiverDetailsData(updatedReach)
//                    }
//                                
//                case .failure(let error):
//                    print("Error with gauge detail call: \(error.localizedDescription)")
//                DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.localizedDescription)
//            }
//            
//        }
//    }
//
//    func fetchAllReaches() {
//        self.fetchReachRecursive(currentIndex: 0, allRegions: Region.all, allRiverJSONData: [])
//    }
//    
//    func fetchReachRecursive(currentIndex: Int, allRegions: [Region], allRiverJSONData: [JSON]) {
//        
//        let nextRegion = allRegions[currentIndex]
//        
//        let urlString = riverURL + "?state=\(nextRegion.code)"
//
//        print("Downloading Region at: \(urlString)")
//        
//        var allRiverJSON = allRiverJSONData
//        
//        Alamofire.request(urlString).responseJSON { (response) in
//            switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    //print("\(json.debugDescription)")
//                    //self.processRiverData(json: json)
//                    allRiverJSON.append(json)
//                    print("AllRiverJSON count: \(allRiverJSON.count)")
//                
//                case .failure(let error):
//                    print("Error! with call: \(error.localizedDescription)")
//                    //DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.localizedDescription)
//            }
//
//            // success or fail, keep it going
//            let newIndex = currentIndex + 1
//            if newIndex > allRegions.count - 1 {
//                print("Finished downloading all regions: processing data...")
//                
//                self.riversList = []
//                
//                for riverJSON in allRiverJSONData {
//                    if let riversArray = riverJSON.array {
//                        for riverJSON in riversArray {
//                            let reach = AWReach(json: riverJSON)
//                            self.riversList.append(reach)
//                        }
//                    }
//                    
//                    print("riversList Count: \(self.riversList.count)")
//                }
//                
//                // set our updated key so we always know when we last updated the data
//                DefaultsManager.lastUpdated = Date()
//                
//                if let delegate = self.delegate {
//                    delegate.awApiDidReceiveRiverData(self.riversList)
//                }
//
//                print("Finished processing, reloading table view")
//                
//            } else {
//                self.fetchReachRecursive(currentIndex: newIndex, allRegions: allRegions, allRiverJSONData: allRiverJSON)
//            }
//        }
//    }
//    
//    func updateRegions() {
//        
//        if let region = Region.regionByTitle(title: "Tennessee") {
//            fetchReachesByRegion(region: region.title)
//        } else {
//            print("Unknown region: Tennessee")
//        }
//        
//    }
//   
//    func processRiverDetailsData(reachId: Int, json: JSON) -> AWReach? {
//        // find the reach matching this id
//        let results = riversList.filter { $0.id == reachId }
//        
//        if let reach = results.first {
//            reach.setDetails(detailsJson: json)
//            return reach
//        }
//        
//        return nil
//    }
//    
//    func processRiverData(json:JSON) {
//        
//        if let riversArray = json.array {
//            riversList = []
//            
//            for riverJSON in riversArray {
//                let reach = AWReach(json: riverJSON)
//                riversList.append(reach)
//            }
//            
//            //print("Rivers list now has: \(riversList.count)")
//        }
//        
//        // set our updated key so we always know when we last updated the data
//        DefaultsManager.lastUpdated = Date()
//        
//        if let delegate = self.delegate {
//            delegate.awApiDidReceiveRiverData(riversList)
//        }
//    }
//    
//    
//    
//    func fetchArticles() {
//        Alamofire.request(articleURL).responseJSON { (response) in
//            
//            switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    
//                    //print("\(json.debugDescription)")
//                    self.processArticles(json: json)
//                
//                case .failure(let error):
//                    //print("Error! with cell: \(error.localizedDescription)")
//                    if let delegate = self.delegate {
//                        delegate.awApiDidReceiveError(error)
//                    }
//            }
//            
//        }
//    }
//    
//    
//    
//    private func processArticles(json: JSON) {
//    
//        
//        if let articles = json["articles"].dictionary {
//            
//            articlesList = []
//            
//            // first get heading article
//            if let mainArticle = articles["CArticleGadgetJSON_view"] {
//                let awTopArticle = AWArticle.init(json: mainArticle)
//                articlesList.append(awTopArticle)
//            }
//
//            
//            // then get the list of articles
//            if let articlesArray = articles["CArticleGadgetJSON_view_list"]?.array {
//                // add each article into our data model and store them
//                for item in articlesArray {
//                    let awArticle = AWArticle.init(json: item)
//                    articlesList.append(awArticle)
//                }
//            }
//            
//            //print("Total number of articles is: \(articlesList.count)")
//            
//            if let delegate = self.delegate {
//                delegate.awApiDidReceiveNewsData(articlesList)
//            }
//        }
//    }
//    
//    // Handle the addition or removeal of the users favorites listing
//    func addRemoveUserFavorite(favorite: AWReach) {
//        // check if it exists, if not add it and save to user defaults
//        var storedFavorites = DefaultsManager.userFavorites
//        let results = storedFavorites.filter { $0.id == favorite.id }
//        if results.count == 0 {
//            storedFavorites.append(favorite)
//            DefaultsManager.userFavorites = storedFavorites
//            //print("Saved favroite: \(favorite.name ?? "unknown")")
//        } else {
//            storedFavorites.removeAll { $0.id == favorite.id }
//            DefaultsManager.userFavorites = storedFavorites
//            //print("Removed favroite: \(favorite.name ?? "unknown")")
//        }
//    }
//    
//    func isUserFavorite(favorite: AWReach) -> Bool {
//        let storedFavorites = DefaultsManager.userFavorites
//        let results = storedFavorites.filter { $0.id == favorite.id }
//        if results.count == 0 {
//            return false
//        } else {
//            return true
//        }
//    }
//}
//
//
//
//// this extension allows our protocol methods to be 'optional' without @objc requirements
//// which results in cleaner code when we need optional use of a delegate
//// (i.e. we need to use articles but not river data response)
//extension AWApiHelperDelegate {
//    func awApiDidReceiveRiverData(_ riverData:[AWReach]) {}
//    func awApiDidReceiveRiverDetailsData(_ riverDetailData:AWReach) {}
//    func awApiDidReceiveNewsData(_ newsArticles:[AWArticle]) {}
//    func awApiDidReceiveError(_ error: Error) {}
//    func awApiDidReceiveError(_ error: Error?, customMessage: String?) {}
//}
