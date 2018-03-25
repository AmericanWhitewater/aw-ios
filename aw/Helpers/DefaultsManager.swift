//
//  DefaultsManager.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

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
            if let regions = UserDefaults.standard.array(forKey: regionsFilterKey) {
                return regions as! [String]
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
    
    private static let classFilterKey = "classFilterKey"
}
