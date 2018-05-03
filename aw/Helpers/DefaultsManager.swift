import Foundation

class DefaultsManager {

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

    private static let distanceFilterKey = "distanceFilterKey"
    static var distanceFilter: Float {
        get {
            return UserDefaults.standard.float(forKey: distanceFilterKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: distanceFilterKey)
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
}
