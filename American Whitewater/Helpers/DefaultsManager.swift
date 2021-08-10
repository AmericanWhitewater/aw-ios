import Foundation
import SwiftyJSON
import KeychainSwift
import CoreLocation

extension Notification.Name {
    static let filtersDidChange = Notification.Name("filtersDidChange")
}

class DefaultsManager {
    public static let shared = DefaultsManager()
    
    private let defaults: UserDefaults
    
    private init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }
    
    var appVersion: Double? {
        get { defaults.double(forKey: Keys.appVersion) }
        set { defaults.set(newValue, forKey: Keys.appVersion) }
    }
    
    var userAccountId: String? {
        get { defaults.string(forKey: Keys.userAccountId) }
        set { defaults.set(newValue, forKey: Keys.userAccountId) }
    }
    
    var uname: String? {
        get { defaults.string(forKey: Keys.unameId) }
        set { defaults.set(newValue, forKey: Keys.unameId) }
    }
    
    /// Used for two things: to set default filters (see AppDelegate),
    /// and to decide whether to request all reaches from the API (see RunsListViewController)
    var completedFirstRun: Bool {
        get { defaults.bool(forKey: Keys.completedFirstRun) }
        set { defaults.set(newValue, forKey: Keys.completedFirstRun) }
    }
    
    var legendFirstRun: Bool {
        get { defaults.bool(forKey: Keys.legendFirstRun) }
        set { defaults.set(newValue, forKey: Keys.legendFirstRun) }
    }
    
    var onboardingCompleted: Bool {
        get { defaults.bool(forKey: Keys.onboardingCompleted) }
        set { defaults.set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    //
    // MARK: - Location
    //
    
    /// Get the last saved location as a CLLocation for convenience (since that's generally what's wanted)
    /// this is get only to make it clear that we're not saving any of the other stuff on CLLocation (altitude, heading, etc)
    /// set coordinate instead
    public var location: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
    
    public var coordinate: CLLocationCoordinate2D {
        get { .init(latitude: latitude, longitude: longitude) }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }

    private var latitude: Double {
        get { defaults.double(forKey: Keys.latitude) }
        set { defaults.set(newValue, forKey: Keys.latitude) }
    }
    
    private var longitude: Double {
        get { defaults.double(forKey: Keys.longitude) }
        set { defaults.set(newValue, forKey: Keys.longitude) }
    }
    
    //
    // MARK: - Filters
    //
    
    public var filters: Filters {
        get {
            .init(
                showDistanceFilter: showDistanceFilter,
                showRegionFilter: showRegionFilter,
                regionsFilter: regionsFilter,
                distanceFilter: distanceFilter,
                classFilter: classFilter,
                runnableFilter: runnableFilter
            )
        }
        
        set {
            // Don't set/notify on duplicates:
            guard newValue != filters else {
                return
            }
            
            showDistanceFilter = newValue.showDistanceFilter
            showRegionFilter = newValue.showRegionFilter
            regionsFilter = newValue.regionsFilter
            distanceFilter = newValue.distanceFilter
            classFilter = newValue.classFilter
            runnableFilter = newValue.runnableFilter
            
            // Post a notification to make it easier to respond to a change in filters
            // This could be also be done with combine (filters could be @Published)
            // but this is a smaller change to the app:
            NotificationCenter.default.post(name: .filtersDidChange, object: newValue)
        }
    }
    
    private var showDistanceFilter: Bool {
        get { defaults.bool(forKey: Keys.showDistanceFilter) }
        set { defaults.set(newValue, forKey: Keys.showDistanceFilter) }
    }

    private var showRegionFilter: Bool {
        get { defaults.bool(forKey: Keys.showRegionFilter) }
        set { defaults.set(newValue, forKey: Keys.showRegionFilter) }
    }
    
    private var regionsFilter: [String] {
        get {
            (defaults.array(forKey: Keys.regionsFilter) as? [String]) ??
            []
        }
        set { defaults.set(newValue, forKey: Keys.regionsFilter) }
    }

    private var distanceFilter: Double {
        get {
            (defaults.object(forKey: Keys.distanceFilter) as? Double) ??
            100
        }
        set {
            defaults.set(newValue, forKey: Keys.distanceFilter)
        }
    }
    
    private var classFilter: [Int] {
        get {
            (defaults.array(forKey: Keys.classFilter) as? [Int]) ??
            []
        }
        set { defaults.set(newValue, forKey: Keys.classFilter) }
    }
    
    private var runnableFilter: Bool {
        get { defaults.bool(forKey: Keys.runnableFilter) }
        set { defaults.set(newValue, forKey: Keys.runnableFilter) }
    }
    
    //
    // MARK: -
    //
    
    var lastUpdated: Date? {
        get { defaults.object(forKey: Keys.updated) as? Date }
        set { defaults.set(newValue, forKey: Keys.updated) }
    }
    
    var favoritesLastUpdated: Date? {
        get { defaults.object(forKey: Keys.favoritesUpdated) as? Date }
        set { defaults.set(newValue, forKey: Keys.favoritesUpdated) }
    }
    
    var articlesLastUpdated: Date? {
        get { defaults.object(forKey: Keys.articlesUpdated) as? Date }
        set { defaults.set(newValue, forKey: Keys.articlesUpdated) }
    }
    
    var reachAlerts: [String: [ [String: String]] ] {
        get {
            (defaults.dictionary(forKey: Keys.reachAlerts) as? [String: [ [String:String]] ]) ??
            [String: [ [String:String]] ]()
        }
        set { defaults.set(newValue, forKey: Keys.reachAlerts) }
    }
    
    var signedInAuth: String? {
        get { defaults.string(forKey: Keys.signedInAuth) }
        set { defaults.set(newValue, forKey: Keys.signedInAuth) }
    }
    
    var signInLastShown: Date? {
        get { defaults.object(forKey: Keys.signInLastShown) as? Date }
        set { defaults.set(newValue, forKey: Keys.signInLastShown) }
    }
    
    // for now we'll store all the users favorites in the preferences
    // eventually we'll move it back over to CoreData
    var userFavorites: [AWReach] {
        get {
            // grab [String] from user defaults, convert to [AWReach]
            let favStrings = defaults.array(forKey: Keys.userFavorites) as? [String]
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
            
            defaults.set(userFavStrings, forKey: Keys.userFavorites)
        }
        
    }
    
    private struct Keys {
        static let appVersion = "appVersionKey"
        static let userAccountId = "userAccountId"
        static let unameId = "uname"
        static let completedFirstRun = "completedFirstRunKey"
        static let legendFirstRun = "legendFirstRunKey"
        static let onboardingCompleted = "onboardingCompletedKey"
        static let regionsFilter = "regionsFilterKey"
        static let distanceFilter = "distanceFilterKey"
        static let showDistanceFilter = "showDistanceFilterKey"
        static let showRegionFilter = "showRegionFilterKey"
        static let latitude = "latitudeKey"
        static let longitude = "longitudeKey"
        static let classFilter = "classFilterKey"
        static let runnableFilter = "runnableFilterKey"
        static let updated = "updatedKey"
        static let favoritesUpdated = "favoritesUpdatedKey"
        static let articlesUpdated = "articlesUpdatedKey"
        static let reachAlerts = "reachAlertsKey"
        static let signedInAuth = "signedInUserIdKey"
        static let signInAlertCount = "signInAlertCountKey"
        static let signInLastShown = "signInLastShownKey"
        static let userFavorites = "userFavoritesKey"
    }
}
