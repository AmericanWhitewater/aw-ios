//
//  API.swift
//  API
//
//  Created by Phillip Kast on 8/8/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation
import UIKit

/// Collects and provides access to fetching data from the network
struct API {
    static let shared = API()
    
    private let reachHelper: AWApiReachHelper
    private let baseURL = "https://www.americanwhitewater.org/content/"
    
    private let graphQLHelper = AWGQLApiHelper()
    private let articleHelper = AWGQLArticleApiHelper.shared
    
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
    
    public func updateReaches(regionCodes: [String], completion: @escaping (Error?) -> Void) {
        reachHelper.updateRegionalReaches(regionCodes: regionCodes) {
            completion(nil)
        } callbackError: {
            completion($0)
        }
    }
    
    public func updateReaches(reachIds: [Int16], completion: @escaping (Error?) -> Void) {
        reachHelper.updateReaches(
            reachIds: reachIds.map { "\($0)" },
            callback: { completion(nil) },
            callbackError: { completion($0) }
        )
    }

    public func updateAllReaches(completion: @escaping () -> Void) {
        reachHelper.downloadAllReachesInBackground(callback: completion)
    }
    
    public func updateReachDetail(reachId: Int16, completion: @escaping (Error?) -> Void) {
        reachHelper.updateReachDetail(reachId: "\(reachId)") {
            completion(nil)
        } callbackError: {
            completion($0)
        }
    }
    
    // FIXME: this should not exist
    public func updateAllReachDistances(completion: @escaping () -> Void) {
        reachHelper.updateAllReachDistances(callback: completion)
    }
    
    //
    // MARK: - GraphQL based
    //
    
    public func updateAccountInfo() {
        graphQLHelper.updateAccountInfo()
    }
    
    public func getAccidentsForReach(
        reach_id: Int,
        first: Int,
        page: Int,
        callback: @escaping AWGQLApiHelper.AccidentCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.getAccidentsForReach(reach_id: reach_id, first: first, page: page, callback: callback, errorCallback: errorCallback)
    }

    public func getAlertsForReach(
        reach_id: Int,
        page: Int,
        page_size: Int,
        callback: @escaping AWGQLApiHelper.AlertsCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.getAlertsForReach(reach_id: reach_id, page: page, page_size: page_size, callback: callback, errorCallback: errorCallback)
    }
    
    public func postAlertFor(
        reach_id: Int,
        message: String,
        callback: @escaping AWGQLApiHelper.AlertPostCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.postAlertFor(reach_id: reach_id, message: message, callback: callback, errorCallback: errorCallback)
    }
    
    public func getGaugeObservationsForReach(
        reach_id: Int,
        page: Int,
        page_size: Int,
        callback: @escaping AWGQLApiHelper.ObservationsCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.getGaugeObservationsForReach(reach_id: reach_id, page: page, page_size: page_size, callback: callback, errorCallback: errorCallback)
    }
    
    public func postGaugeObservationFor(
        reach_id: Int,
        metric_id: Int,
        title: String,
        dateString: String,
        reading: Double,
        callback: @escaping AWGQLApiHelper.PostObservationsCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.postGaugeObservationFor(reach_id: reach_id, metric_id: metric_id, title: title, dateString: dateString, reading: reading, callback: callback, errorCallback: errorCallback)
    }
    
    public func getPhotosForReach(
        reach_id: Int,
        page: Int,
        page_size: Int,
        callback: @escaping AWGQLApiHelper.PhotosCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.getPhotosForReach(reach_id: reach_id, page: page, page_size: page_size, callback: callback, errorCallback: errorCallback)
    }
    
    public func postPhotoForReach(
        photoPostType: PostType = PostType.photoPost,
        image: UIImage,
        reach_id: Int,
        caption: String,
        description: String,
        photoDate: String,
        reachObservation: Double? = nil,
        gauge_id: String? = nil,
        metric_id: Int? = nil,
        reachReading: Double? = nil,
        callback: @escaping AWGQLApiHelper.PhotoUploadCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.postPhotoForReach(image: image, reach_id: reach_id, caption: caption, description: description, photoDate: photoDate, callback: callback, errorCallback: errorCallback)
    }
    
    public func getMetricsForGauge(id: String, metricsCallback: @escaping AWGQLApiHelper.AWMetricsCallback) {
        graphQLHelper.getMetricsForGauge(id: id, metricsCallback: metricsCallback)
    }

    public func getGagesForReach(id: String, gagesInfoCallback: @escaping AWGQLApiHelper.AWGaugesListCallback) {
        graphQLHelper.getGagesForReach(id: id, gagesInfoCallback: gagesInfoCallback)
    }
}
