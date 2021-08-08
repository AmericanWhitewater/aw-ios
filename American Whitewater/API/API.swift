//
//  API.swift
//  API
//
//  Created by Phillip Kast on 8/8/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation

/// Collects and provides access to fetching data from the network
struct API {
    static let shared = API()
    
    private let reachHelper: AWApiReachHelper
    private let baseURL = "https://www.americanwhitewater.org/content/"
    
    private init() {
        reachHelper = .init(
            baseURL: baseURL + "/content",
            riverURL: baseURL + "/content/River/search/.json",
            baseGaugeDetailURL: baseURL + "/content/River/detail/id/"
        )
    }
    
    //
    // MARK: - Reaches
    //
    
    public func updateRegionalReaches(regionCodes: [String], completion: @escaping (Error?) -> Void) {
        reachHelper.updateRegionalReaches(regionCodes: regionCodes) {
            completion(nil)
        } callbackError: {
            completion($0)
        }

    }
    
    public func updateReaches(reachIds: [String], completion: @escaping (Error?) -> Void) {
        reachHelper.updateReaches(reachIds: reachIds) {
            completion(nil)
        } callbackError: {
            completion($0)
        }

    }

    public func downloadAllReachesInBackground(completion: @escaping () -> Void) {
        reachHelper.downloadAllReachesInBackground(callback: completion)
    }
    
    public func updateReachDetail(reachId: String, completion: @escaping (Error?) -> Void) {
        reachHelper.updateReachDetail(reachId: reachId) {
            completion(nil)
        } callbackError: {
            completion($0)
        }
    }
    
    public func updateAllReachDistances(completion: @escaping () -> Void) {
        reachHelper.updateAllReachDistances(callback: completion)
    }
}
