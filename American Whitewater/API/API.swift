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
/// While this isn't 100% true yet, API's methods should be functions without side effects. When called, they should always make a network request, and should call a completion block with an error, or the returned parsed response.
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
    
    // FIXME: Has no completion block, can't report errors or success. Saves result with DefaultsManager, but should return values instead
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
    
    /// Retrieves articles, parses into unpersisted NewsArticles and passes them to its completion block
    public func getArticles(completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        articleHelper.getArticles { results in
            guard let results = results else {
                completion([], nil)
                return
            }
            
            let articles = results.compactMap { a -> NewsArticle? in
                // Don't accept articles with a nil ID, since we must have a primary key to identify with
                guard let id = a.id else {
                    return nil
                }
                
                return NewsArticle(
                    id: id,
                    uid: a.uid,
                    createdAt: Date(),
                    postedDate: self.isoDate(a.postedDate),
                    releaseDate: self.isoDate(a.releaseDate),
                    abstract: a.abstract,
                    abstractImage: a.abstractimage?.uri?.medium, // FIXME: this drops other sizes, Photo is a struct that can hold them all...
                    title: a.title,
                    author: a.author,
                    contents: a.contents,
                    icon: a.icon,
                    image: a.image?.uri?.medium, // FIXME: this drops other sizes, Photo is a struct that can hold them all...
                    shortName: a.shortName
                )
            }
            
            completion(articles, nil)
        } errorCallback: {
            completion(nil, $0)
        }
    }
    
    //
    // MARK: - Dates
    //
    
    private let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
    
    /// Convenience func that formats an optional ISO 8601 date string, returning a Date if possible
    private func isoDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        return dateFormatter.date(from: dateString)
    }
}
