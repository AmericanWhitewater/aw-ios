//
//  API.swift
//  API
//
//  Created by Phillip Kast on 8/8/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation
import UIKit
import Apollo

/// Collects and provides access to fetching data from the network
struct API {
    static let shared = API()
    
    private let reachHelper: AWApiReachHelper
    private let baseURL = AWGC.AW_BASE_URL
    
    private let apollo: ApolloClient
    private let graphQLHelper: AWGQLApiHelper
    private let articleHelper: AWGQLArticleApiHelper
    
    private init() {
        reachHelper = .init(
            baseURL: baseURL + "/content",
            riverURL: baseURL + "/content/River/search/.json",
            baseGaugeDetailURL: baseURL + "/content/River/detail/id/"
        )
        
        let store = ApolloStore()
        
        apollo = ApolloClient(
            networkTransport: RequestChainNetworkTransport(
                interceptorProvider: NetworkInterceptorProvider(
                    client: URLSessionClient(),
                    store: store
                ),
                endpointURL: URL(string: "\(baseURL)/graphql")!
            ),
            store: ApolloStore()
        )
        
        graphQLHelper = AWGQLApiHelper(apollo: apollo)
        articleHelper = AWGQLArticleApiHelper(apollo: apollo)
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
    
    public func updateReaches(reachIds: [Int], completion: @escaping (Error?) -> Void) {
        reachHelper.updateReaches(
            reachIds: reachIds.map { "\($0)" },
            callback: { completion(nil) },
            callbackError: { completion($0) }
        )
    }

    public func updateAllReaches(completion: @escaping () -> Void) {
        reachHelper.downloadAllReachesInBackground(callback: completion)
    }
    
    public func updateReachDetail(reachId: Int, completion: @escaping (Error?) -> Void) {
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
    
    public func getAccidents(
        reachId: Int,
        first: Int,
        page: Int,
        completion: @escaping ([Accident]?, Error?) -> Void
    ) {
        graphQLHelper.getAccidentsForReach(
            reach_id: reachId,
            first: first,
            page: page,
            callback: {
                let accidents = ($0 ?? []).map { Accident(datum: $0) }
                completion(accidents, nil)
            },
            
            // TEMP: fix error callbacks, but for now:
            errorCallback: { completion(nil, $0 ?? NSError(domain: $1 ?? "Unknown error", code: 0, userInfo: nil)) }
        )
    }

    public func getAlerts(
        reachId: Int,
        page: Int,
        pageSize: Int,
        callback: @escaping AWGQLApiHelper.AlertsCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.getAlertsForReach(reach_id: reachId, page: page, page_size: pageSize, callback: callback, errorCallback: errorCallback)
    }
    
    public func postAlert(
        reachId: Int,
        message: String,
        callback: @escaping AWGQLApiHelper.AlertPostCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.postAlertFor(reach_id: reachId, message: message, callback: callback, errorCallback: errorCallback)
    }
    
    public func getGaugeObservations(
        reachId: Int,
        page: Int,
        pageSize: Int,
        callback: @escaping AWGQLApiHelper.ObservationsCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.getGaugeObservationsForReach(reach_id: reachId, page: page, page_size: pageSize, callback: callback, errorCallback: errorCallback)
    }
    
    // FIXME: this doesn't take a gaugeId. Shouldn't it need one to post a gauge observation?!
    public func postGaugeObservation(
        reachId: Int,
        metricId: Int,
        title: String,
        dateString: String,
        reading: Double,
        callback: @escaping AWGQLApiHelper.PostObservationsCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.postGaugeObservationFor(reach_id: reachId, metric_id: metricId, title: title, dateString: dateString, reading: reading, callback: callback, errorCallback: errorCallback)
    }
    
    public func getPhotos(
        reachId: Int,
        page: Int,
        pageSize: Int,
        callback: @escaping AWGQLApiHelper.PhotosCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.getPhotosForReach(reach_id: reachId, page: page, page_size: pageSize, callback: callback, errorCallback: errorCallback)
    }
    
    public func postPhoto(
        photoPostType: PostType = PostType.photoPost,
        image: UIImage,
        reachId: Int,
        caption: String,
        description: String,
        photoDate: String,
        reachObservation: Double? = nil,
        gaugeId: Int? = nil,
        metricId: Int? = nil,
        reachReading: Double? = nil,
        callback: @escaping AWGQLApiHelper.PhotoUploadCallback,
        errorCallback: @escaping AWGQLApiHelper.AWGraphQLError
    ) {
        graphQLHelper.postPhotoForReach(
            photoPostType: photoPostType,
            image: image,
            reach_id: reachId,
            caption: caption,
            description: description,
            photoDate: photoDate,
            reachObservation: reachObservation,
            gauge_id: gaugeId != nil ? "\(gaugeId!)" : nil,
            metric_id: metricId,
            reachReading: reachReading,
            callback: callback,
            errorCallback: errorCallback
        )
    }
    
    public func getMetrics(gaugeId: Int, metricsCallback: @escaping AWGQLApiHelper.AWMetricsCallback) {
        graphQLHelper.getMetricsForGauge(
            id: "\(gaugeId)",
            metricsCallback: metricsCallback
        )
    }

    public func getGauges(reachId: Int, gagesInfoCallback: @escaping AWGQLApiHelper.AWGaugesListCallback) {
        graphQLHelper.getGagesForReach(
            id: "\(reachId)",
            gagesInfoCallback: gagesInfoCallback
        )
    }
    
    
    //
    // MARK: - GraphQL Articles
    //
    
    public func updateArticles(
        callback: @escaping AWGQLArticleApiHelper.UpdatedNewsCallback,
        errorCallback: @escaping AWGQLArticleApiHelper.ErrorCallback
    ) {
        articleHelper.updateArticles(callback: callback, errorCallback: errorCallback)
    }
    
}
