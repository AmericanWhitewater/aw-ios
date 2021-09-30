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
    
    private let isoFormatter = ISO8601DateFormatter()
    
    private init() {
        reachHelper = .init(
            baseURL: baseURL + "/content/",
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
    
    /// Retrieves a list of reaches from the network
    // TODO: For now, while CoreData is being used, this must return [AWReach], intended to be a private type, because it needs a non-uniqued and non-persisted type to return
    public func getReaches(regionCodes: [String], completion: @escaping ([AWApiReachHelper.AWReach]?, Error?) -> Void) {
        reachHelper.getReaches(regionCodes: regionCodes) {
            completion($0, nil)
        } callbackError: {
            completion(nil, $0)
        }
    }
    
    public func getReaches(reachIds: [Int], completion: @escaping ([AWApiReachHelper.AWReach]?, Error?) -> Void) {
        reachHelper.getReaches(
            reachIds: reachIds.map { "\($0)" },
            callback: { completion($0, nil) },
            callbackError: { completion(nil, $0) }
        )
    }
    
    public func getReachDetail(reachId: Int, completion: @escaping (AWApiReachHelper.AWReachDetail?, Error?) -> Void) {
        reachHelper.getReachDetail(reachId: reachId) {
            completion($0, nil)
        } callbackError: {
            completion(nil, $0)
        }
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
            errorCallback: { completion(nil, $0) }
        )
    }

    public func getAlerts(
        reachId: Int,
        page: Int,
        pageSize: Int,
        completion: @escaping ([Alert]?, Error?) -> Void
    ) {
        graphQLHelper.getAlertsForReach(
            reach_id: reachId,
            page: page,
            page_size: pageSize,
            callback: {
                let alerts = ($0 ?? []).map { Alert(datum: $0) }
                completion(alerts, nil)
            },
            errorCallback: { completion(nil, $0) }
        )
    }
    
    public func postAlert(
        reachId: Int,
        message: String,
        completion: @escaping (Alert?, Error?) -> Void
    ) {
        graphQLHelper.postAlertFor(
            reach_id: reachId,
            message: message,
            callback: { completion(Alert(postUpdate: $0), nil) },
            errorCallback: { completion(nil, $0) }
        )
    }
    
    public func getGaugeObservations(
        reachId: Int,
        page: Int,
        pageSize: Int,
        completion: @escaping ([GaugeObservation]?, Error?) -> Void
    ) {
        graphQLHelper.getGaugeObservationsForReach(
            reach_id: reachId,
            page: page,
            page_size: pageSize,
            callback: { obs in
                let flows = (obs ?? []).map { GaugeObservation(datum: $0) }
                completion(flows, nil)
            },
            errorCallback: { completion(nil, $0) }
        )
    }
    
    // FIXME: this doesn't take a gaugeId. Shouldn't it need one to post a gauge observation?!
    public func postGaugeObservation(
        reachId: Int,
        gaugeId: Int?,
        metricId: Int,
        observation: Double?,
        title: String?,
        dateString: String,
        reading: Double,
        completion: @escaping (GaugeObservation?, Error?) -> Void
    ) {
        graphQLHelper.postGaugeObservationFor(
            reach_id: reachId,
            gauge_id: gaugeId,
            metric_id: metricId,
            observation: observation,
            title: title,
            dateString: dateString,
            reading: reading,
            callback: {
                let obs = GaugeObservation(postUpdate: $0)
                completion(obs, nil)
            },
            errorCallback: {
                completion(nil, $0)
            }
        )
    }
    
    public func getPhotos(
        reachId: Int,
        page: Int,
        pageSize: Int,
        completion: @escaping ([Photo]?, Error?) -> Void
    ) {
        graphQLHelper.getPhotosForReach(
            reach_id: reachId,
            page: page,
            page_size: pageSize,
            callback: { result in
                let photos = (result ?? []).flatMap { post in
                    post.photos.map {
                        Photo(photo: $0)
                    }
                }
                
                completion(photos, nil)
            },
            errorCallback: { completion(nil, $0) }
        )
    }
    
    public func postPhoto(
        photoPostType: PostType = PostType.photoPost,
        image: UIImage,
        reachId: Int,
        caption: String?,
        description: String,
        photoDate: String,
        reachObservation: Double? = nil,
        gaugeId: Int? = nil,
        metricId: Int? = nil,
        reachReading: Double? = nil,
        completion: @escaping (Photo?, Error?) -> Void
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
            callback: { (photoFileUpdate, photoPostUpdate) in
                let photo = Photo(
                    id: photoFileUpdate.id,
                    author: photoFileUpdate.author,
                    date: self.isoFormatter.date(from: photoFileUpdate.photoDate ?? ""),
                    caption: photoFileUpdate.caption,
                    description: photoFileUpdate.description,
                    thumbPath: photoFileUpdate.image?.uri?.thumb,
                    mediumPath: photoFileUpdate.image?.uri?.medium,
                    bigPath: photoFileUpdate.image?.uri?.big
                )
                
                completion(photo, nil)
            },
            errorCallback: {
                completion(nil, $0)
            }
        )
    }
    
    public func getMetrics(gaugeId: Int, metricsCallback: @escaping ([Metric]?, Error?) -> Void) {
        graphQLHelper.getMetricsForGauge(id: "\(gaugeId)") { result, error in
            guard let result = result, error == nil else {
                metricsCallback(nil, error)
                return
            }
            
            let metrics = result.compactMap { m -> Metric? in
                guard let id = m.id, let name = m.name, let unit = m.unit else {
                    return nil
                }
                
                return Metric(id: id, name: name, unit: unit)
            }
            
            metricsCallback(metrics, nil)
        }
    }
    
    public func getGauges(reachId: Int, completion: @escaping ([Gauge]?, Error?) -> Void) {
        graphQLHelper.getGagesForReach(id: "\(reachId)") { (data, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            let gauges = data.compactMap { Gauge(datum: $0) }
            completion(gauges, nil)
        }
    }
    
    /// Gets data points for a gauge over a particular date interval, suitable for use in a chart or other detailed display
    public func getGaugeGraphData(gaugeId: Int, dateInterval: DateInterval, resolution: Int, completion: @escaping ([GaugeDataPoint]?, Error?) -> Void) {
        GaugeGraphData.get(gaugeId: gaugeId, dateInterval: dateInterval, resolution: resolution, completion: completion)
    }
    
    
    //
    // MARK: - GraphQL Articles
    //
    
    // FIXME: passes an internal graphql type (that is not uniqued) rather than creating another temp type to work around CoreData's needs
    public func getArticles(completion: @escaping ([NewsQuery.Data.Article.Datum]?, Error?) -> Void) {
        articleHelper.getArticles { articles in
            completion(articles, nil)
        } errorCallback: {
            completion(nil, $0)
        }
    }
    
    enum Errors: Error {
        case missingData
    }
}
