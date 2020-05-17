import Foundation
import SwiftyJSON
import KeychainSwift

class DefaultsManager {
    
    private static let appVersionKey = "appVersionKey"
    static var appVersion: Double? {
        get {
            return UserDefaults.standard.double(forKey: appVersionKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: appVersionKey)
        }
    }

    private static let completedFirstRunKey = "completedFirstRunKey"
    static var completedFirstRun: Bool {
        get {
            return UserDefaults.standard.bool(forKey: completedFirstRunKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: completedFirstRunKey)
        }
    }
    
    private static let legendFirstRunKey = "legendFirstRunKey"
    static var legendFirstRun: Bool {
        get {
            return UserDefaults.standard.bool(forKey: legendFirstRunKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: legendFirstRunKey)
        }
    }
    
    private static let shouldAutoRefreshKey = "shouldAutoRefresh"
    static var shouldAutoRefresh: Bool? {
        get {
            return UserDefaults.standard.object(forKey: shouldAutoRefreshKey) as? Bool
        }
        set {
            UserDefaults.standard.set(newValue, forKey: shouldAutoRefreshKey)
        }
    }
    
    private static let onboardingCompletedKey = "onboardingCompletedKey"
    static var onboardingCompleted: Bool {
        get {   
            return UserDefaults.standard.bool(forKey: onboardingCompletedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: onboardingCompletedKey)
        }
    }

    
    
    private static let regionsFilterKey = "regionsFilterKey"
    static var regionsFilter: [String] {
        get {
            if let regions = UserDefaults.standard.array(forKey: regionsFilterKey) as? [String] {
                return regions
            } else {
                return []
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: regionsFilterKey)
        }
    }

    private static let regionsUpdatedKey = "regionsUpdatedKey"
    static var regionsUpdated: Bool {
        get {
            return UserDefaults.standard.bool(forKey: regionsUpdatedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: regionsUpdatedKey)
        }
    }

    
    private static let distanceFilterKey = "distanceFilterKey"
    static var distanceFilter: Double {
        get {
            var distanceFilter = UserDefaults.standard.double(forKey: distanceFilterKey)
            if distanceFilter == 0.0 {
                distanceFilter = 100
                UserDefaults.standard.set(distanceFilter, forKey: distanceFilterKey)
            }
            
            return UserDefaults.standard.double(forKey: distanceFilterKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: distanceFilterKey)
        }
    }
    
    private static let showDistanceFilterKey = "showDistanceFilterKey"
    static var showDistanceFilter: Bool {
        get {
            return UserDefaults.standard.bool(forKey: showDistanceFilterKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: showDistanceFilterKey)
        }
    }

    private static let showRegionFilterKey = "showRegionFilterKey"
    static var showRegionFilter: Bool {
        get {
            return UserDefaults.standard.bool(forKey: showRegionFilterKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: showRegionFilterKey)
        }
    }

    
    private static let latitudeKey = "latitudeKey"
    private static let longitudeKey = "longitudeKey"
    static var latitude: Double {
        get {
            return UserDefaults.standard.double(forKey: latitudeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: latitudeKey)
        }
    }
    static var longitude: Double {
        get {
            return UserDefaults.standard.double(forKey: longitudeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: longitudeKey)
        }
    }
    
    private static let classFilterKey = "classFilterKey"
    static var classFilter: [Int] {
        get {
            if let classes = UserDefaults.standard.array(forKey: classFilterKey) as? [Int] {
                return classes
            } else {
                return []
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: classFilterKey)
        }
    }
    
    private static let runnableFilterKey = "runnableFilterKey"
    static var runnableFilter: Bool {
        get {
            return UserDefaults.standard.bool(forKey: runnableFilterKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: runnableFilterKey)
        }
    }
    
    private static let updatedKey = "updatedKey"
    static var lastUpdated: Date? {
        get {
            return UserDefaults.standard.object(forKey: updatedKey) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: updatedKey)
        }
    }
    
    private static let favoritesUpdatedKey = "favoritesUpdatedKey"
    static var favoritesLastUpdated: Date? {
        get {
            return UserDefaults.standard.object(forKey: favoritesUpdatedKey) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: favoritesUpdatedKey)
        }
    }
    
    private static let articlesUpdatedKey = "articlesUpdatedKey"
    static var articlesLastUpdated: Date? {
        get {
            return UserDefaults.standard.object(forKey: articlesUpdatedKey) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: articlesUpdatedKey)
        }
    }
    
    private static let fetchingReachesKey = "fetchingReachesKey"
    static var fetchingreaches: Bool {
        get {
            return UserDefaults.standard.bool(forKey: fetchingReachesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: fetchingReachesKey)
        }
    }
    
    
    // for now we'll store all the users favorites in the preferences
    // eventually we'll move it back over to CoreData
    private static let userFavoritesKey = "userFavoritesKey"
    static var userFavorites: [AWReach] {
        get {
            // grab [String] from user defaults, convert to [AWReach]
            let favStrings = UserDefaults.standard.array(forKey: userFavoritesKey) as? [String]
            var favsArray:[AWReach] = []
            
            if let favStrings = favStrings {
                for fav in favStrings {
                    let favData = fav.data(using: .utf8, allowLossyConversion: false)
                    if let favData = favData {
                        
                        do {
                            let favJSON = try JSON(data: favData)
                            let newReach = AWReach(json: favJSON)
                            favsArray.append(newReach)
                        } catch {
                            print("Can't convert string to json: \(fav)")
                            continue
                        }
                    }
                }
            }
           
            return favsArray
        }
        
        // grab [AWReach] array and convert to [String] for storage
        set {
            
            var userFavStrings:[String] = []
            
            for item in newValue {
                let itemString = item.getString()
                if let itemString = itemString {
                    userFavStrings.append(itemString)
                }
            }
            
            UserDefaults.standard.set(userFavStrings, forKey: userFavoritesKey)
        }
        
    }
    
}
