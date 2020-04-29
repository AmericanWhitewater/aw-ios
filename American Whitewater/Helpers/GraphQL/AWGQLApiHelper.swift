//
//  AWGQLApiHelper.swift
//  American Whitewater
//
//  Created by David Nelson on 4/27/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import Foundation
import Apollo

class AWGQLApiHelper
{
    typealias AccidentCallback = ([ReachAccidentsQuery.Data.Reach.Accident.Datum]?) -> Void
    typealias AlertsCallback = ([AlertsQuery.Data.Post.Datum]?) -> Void
    typealias AWGraphQLError = (Error) -> Void

    static let shared = AWGQLApiHelper()
    
    private(set) lazy var apollo = ApolloClient(url: URL(string: "http://aw.local/graphql")!)
    
    public func getAccidentsForReach(reach_id: Int, first: Int, page: Int, callback: @escaping AccidentCallback, errorCallback: @escaping AWGraphQLError) {
        
        apollo.fetch(query: ReachAccidentsQuery(reach_id: GraphQLID(reach_id), first: first, page: page)) { result in
            switch result {
                case .success(let graphQLResult):
                    
                    var accidentsList: [ReachAccidentsQuery.Data.Reach.Accident.Datum]?
                    accidentsList = graphQLResult.data?.reach?.accidents?.data
                    if let accidentsList = accidentsList, let accident = accidentsList.first {
                        print("Accident 0: \(accident.river ?? "Unknown River")")
                        print("Accidents Count: \(accidentsList.count)")
                    }
                    
                    callback(graphQLResult.data?.reach?.accidents?.data)
                
                case.failure(let error):
                    
                    print("GraphQL Error: \(error)")
                    errorCallback(error)
            }
                
        }
    }
    
    public func getAlertsForReach(reach_id: Int, page: Int, page_size: Int, callback: @escaping AlertsCallback, errorCallback: @escaping AWGraphQLError) {
        print("Getting alerts for reach: \(reach_id)")
        apollo.fetch(query: AlertsQuery(page_size: page_size, reach_id: "\(reach_id)", page: page, post_types: [PostType.warning])) { result in
            print("finished querying alerts...processing...")
            switch result {
                case .success(let graphQLResult):
                    
                    if let data = graphQLResult.data, let posts = data.posts {                        
                        for item in posts.data {
                            print(item.id ?? 0)
                        }
                    }
                    
                    callback(graphQLResult.data?.posts?.data)
                
                case .failure(let error):
                    print("GraphQL Error: \(error)")
                    errorCallback(error)
            }
        }
    }
    
}
