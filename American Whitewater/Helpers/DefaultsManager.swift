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
    
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private lazy var reachUpdater = ReachUpdater(managedObjectContext: managedObjectContext)
    
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
            
            // .003 degrees of latitude is approx 1000ft.
            if lastDistanceLatitude == 0 ||
                newValue.hasChanged(from: lastDistanceCoordinate, byMoreThan: 0.003) {
                print("Updating distances of reaches")
                
                reachUpdater.updateAllReachDistances{}
                lastDistanceCoordinate = newValue
            }
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
    
    // The last user location we used to update reach distances
    private var lastDistanceCoordinate:CLLocationCoordinate2D {
        get { .init(latitude: lastDistanceLatitude, longitude: lastDistanceLongitude) }
        set {
            lastDistanceLatitude = newValue.latitude
            lastDistanceLongitude = newValue.longitude
        }
    }
    
    private var lastDistanceLatitude: Double {
        get { defaults.double(forKey: Keys.lastDistanceLatitude) }
        set { defaults.set(newValue, forKey: Keys.lastDistanceLatitude) }
    }
    
    private var lastDistanceLongitude: Double {
        get { defaults.double(forKey: Keys.lastDistanceLongitude) }
        set { defaults.set(newValue, forKey: Keys.lastDistanceLongitude) }
    }
    
    //
    // MARK: - Filters
    //
    
    public var filters: Filters {
        get {
            .init(
                filterType: filterType,
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
            
            filterType = newValue.filterType
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
    
    private var filterType: FilterType {
        get {
            let raw = defaults.string(forKey: Keys.filterType) ?? FilterType.region.rawValue
            return FilterType(rawValue: raw)!
        }
        set(newFilterType) {
            let raw = newFilterType.rawValue
            defaults.set(raw, forKey: Keys.filterType)
        }
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
                [1,2,3,4,5]
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
    
    private struct Keys {
        static let appVersion = "appVersionKey"
        static let userAccountId = "userAccountId"
        static let unameId = "uname"
        static let completedFirstRun = "completedFirstRunKey"
        static let onboardingCompleted = "onboardingCompletedKey"
        static let regionsFilter = "regionsFilterKey"
        static let distanceFilter = "distanceFilterKey"
        static let filterType = "filterType"
        static let latitude = "latitudeKey"
        static let longitude = "longitudeKey"
        static let lastDistanceLatitude = "lastDistanceLatitudeKey"
        static let lastDistanceLongitude = "lastDistanceLongitudeKey"
        static let classFilter = "classFilterKey"
        static let runnableFilter = "runnableFilterKey"
        static let updated = "updatedKey"
        static let favoritesUpdated = "favoritesUpdatedKey"
        static let articlesUpdated = "articlesUpdatedKey"
        static let reachAlerts = "reachAlertsKey"
        static let signedInAuth = "signedInUserIdKey"
        static let signInLastShown = "signInLastShownKey"
    }
}
