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
    private init() {}

    private var reachHelper = AWApiReachHelper()
    
    //
    // MARK: - Reaches
    //
    
    public func fetchReachesByRegion(
        regionCode: String,
        callback: @escaping ([AWReach]) -> Void,
        callbackError: @escaping (Error) -> Void
    ) {
        reachHelper.fetchReachesByRegion(
            regionCode: regionCode,
            callback: callback,
            callbackError: callbackError
        )
    }
    
    public func updateRegionalReaches(
        regionCodes: [String],
        callback: @escaping () -> Void,
        callbackError: @escaping (Error) -> Void
    ) {
        reachHelper.updateRegionalReaches(
            regionCodes: regionCodes,
            callback: callback,
            callbackError: callbackError
        )
    }
    
    public func updateReaches(
        reachIds: [String],
        callback: @escaping () -> Void,
        callbackError: @escaping (Error) -> Void
    ) {
        reachHelper.updateReaches(reachIds: reachIds,
                                  callback: callback,
                                  callbackError: callbackError
        )
    }

    
    public func downloadAllReachesInBackground(callback: @escaping () -> Void) {
        reachHelper.downloadAllReachesInBackground(callback: callback)
    }
    
    public func updateReachDetail(
        reachId: String,
        callback: @escaping () -> Void,
        callbackError: @escaping (Error) -> Void
    ) {
        reachHelper.updateReachDetail(
            reachId: reachId,
            callback: callback,
            callbackError: callbackError
        )
    }
    
    public func updateAllReachDistances(callback: @escaping () -> Void) {
        reachHelper.updateAllReachDistances(callback: callback)
    }
}
