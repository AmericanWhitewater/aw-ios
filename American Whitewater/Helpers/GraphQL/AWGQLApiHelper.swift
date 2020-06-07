//
//  AWGQLApiHelper.swift
//  American Whitewater
//
//  Created by David Nelson on 4/27/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire
import Apollo

class AWGQLApiHelper
{
    typealias AccidentCallback = ([ReachAccidentsQuery.Data.Reach.Accident.Datum]?) -> Void
    typealias AlertsCallback = ([AlertsQuery.Data.Post.Datum]?) -> Void
    typealias AlertPostCallback = (PostAlertMutation.Data.PostUpdate?) -> Void
    typealias PhotosCallback = ([PhotosQuery.Data.Post.Datum]?) -> Void
    typealias PhotoUploadCallback = (UploadPhotoFileMutation.Data.PhotoFileCreate) -> Void
    typealias AWGraphQLError = (Error?, String?) -> Void
    
    static let shared = AWGQLApiHelper()
    
    private(set) lazy var apollo: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(url: URL(string: "\(AWGC.AW_BASE_URL)/graphql")!)
        print("Using URL:", "\(AWGC.AW_BASE_URL)/graphql")
        httpNetworkTransport.delegate = self
        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
    
    private let keychain = KeychainSwift()
    
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
                    errorCallback(error, nil)
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
                    errorCallback(error, nil)
            }
        }
    }

    public func postAlertFor(reach_id: Int, message: String, callback: @escaping AlertPostCallback, errorCallback: @escaping AWGraphQLError) {

        let newID = NanoID.new(alphabet: .allLettersAndNumbers, size: 21)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        let newAlert = PostInput(title: nil,
                                detail: message,
                              postType: PostType.warning,
                              postDate: dateString,
                               reachId: "\(reach_id)",
                               gaugeId: nil,
                                userId: nil,
                              metricId: nil,
                               reading: nil)
        
        
        if keychain.get(AWGC.AuthKeychainToken) != nil {
            apollo.perform(mutation: PostAlertMutation(id: newID, post: newAlert)) { result in
                print("Posting alert with gql...")
                switch result {
                    case .success(let graphQLResult):
                        if let data = graphQLResult.data, let postUpdate = data.postUpdate {
                            print("PostUpdate: ", postUpdate)
                            callback(postUpdate)
                        } else {
                            print("nil response: \(graphQLResult)")
                        }
                    case .failure(let error):
                        print("GraphQL Error: \(error)")
                        errorCallback(error, nil)
                }
            }
        } else {
            // user is not signed in
            // AWTODO: Add option to sign in
            DuffekDialog.shared.showOkDialog(title: "Sign In Required", message: "You must sign in before sumbitting an alert.")
        }
    }
    
    
    public func getPhotosForReach(reach_id: Int, page: Int, page_size: Int, callback: @escaping PhotosCallback, errorCallback: @escaping AWGraphQLError) {
        print("Getting alerts for reach: \(reach_id)")
        apollo.fetch(query: PhotosQuery(page_size: page_size, reach_id: "\(reach_id)", page: page, post_types: [PostType.photoPost])) { result in
            print("finished querying alerts...processing...")
            switch result {
                case .success(let graphQLResult):
                    
//                    if let dataMap = graphQLResult.data {
//                        print("Json:")
//                        print(dataMap.jsonObject)
//                    }
                    
                    if let data = graphQLResult.data, let posts = data.posts {
                        print("Photos Count:")
                        for item in posts.data {
                            print(item.photos.count)
                        }
                    }
                    
                    callback(graphQLResult.data?.posts?.data)
                
                case .failure(let error):
                    print("GraphQL Error: \(error)")
                    errorCallback(error, nil)
            }
        }
    }
    
    public func postPhotoFor(reach_id: Int, image: UIImage, caption: String, callback: @escaping PhotoUploadCallback, errorCallback: @escaping AWGraphQLError) {

        let newID = NanoID.new(alphabet: .allLettersAndNumbers, size: 21)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        let newPhotoPost = PostInput(title: "newPhotoPost Title: \(NanoID.new(6))",
                                    detail: caption,
                                  postType: PostType.photoPost,
                                  postDate: dateString,
                                   reachId: "\(reach_id)",
                                   gaugeId: nil,
                                    userId: nil,
                                  metricId: nil,
                                   reading: nil)
        
        
        if keychain.get(AWGC.AuthKeychainToken) != nil {
            apollo.perform(mutation: PostPhotoMutation(id: newID, post: newPhotoPost)) { result in
                switch result {
                    case .success(let graphQLResult):
                        if let data = graphQLResult.data, let postUpdate = data.postUpdate {
                            //print("Photo PostUpdate: ", postUpdate)
                            print("Photo Post ID: \(postUpdate.id ?? "id n/a")")
                            print("Calling Create Photo File")
                            
                            if let postId = postUpdate.id {
                                self.postPhotoForReach(image: image, reach_id: reach_id, post_id: postId, caption: caption, callback: callback, errorCallback: errorCallback)
                            } else {
                                print("Unable to get newly created post id")
                            }
                        } else {
                            print("nil response: \(graphQLResult)")
                            errorCallback(nil, "PhotoPost: Invalid Data Returned")
                        }
                    case .failure(let error):
                        print("GraphQL Error: \(error)")
                        errorCallback(error, nil)
                }
            }
        } else {
            // user is not signed in
            // AWTODO: Add option to sign in
            DuffekDialog.shared.showOkDialog(title: "Sign In Required", message: "You must sign in before sumbitting an alert.")
        }
    }
    
    public func postPhotoForReach(image: UIImage, reach_id: Int, post_id: String, caption: String? = nil, description: String? = nil, subject: String? = nil, author: String? = nil, callback: @escaping PhotoUploadCallback, errorCallback: @escaping AWGraphQLError) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = dateFormatter.string(from: Date())
        
        let photoName = "photo_\(NanoID.new(alphabet: .allLettersAndNumbers, size: 10))"
        
        let photoInput = PhotoInput(caption: caption, description: description, postId: post_id, subject: subject, author: author, poiName: nil, poiId: nil, photoDate: now)
        
        guard let imgData = image.jpegData(compressionQuality: 1) else { print("can't get image data from UIImage sent"); return }
        
        print("Creating aw photo file on server")
        
        let file = GraphQLFile(fieldName: "file", originalName: photoName, mimeType: "image/jpeg", data: imgData)
        print("creating photo for reach:", reach_id)
        apollo.upload(operation: UploadPhotoFileMutation(file: photoName, reach_id: "\(reach_id)",
            type: PhotoSectionsType.reach, photo: photoInput), files: [file]) { result in
            
            switch result {
                case .success(let graphQLResult):
                    print("Success called")
                    if let photoResult = graphQLResult.data?.photoFileCreate {
                        print("Photo Result id: \(photoResult.id ?? "no id")")
                        if let image = photoResult.image, let uri = image.uri {
                            print("URI: \(uri.thumb ?? "no thumb") ")
                            print("URI: \(uri.medium ?? "no medium") ")
                            print("URI: \(uri.big ?? "no big") ")
                        }
                        
                        callback(photoResult)
                    } else {
                        print("Error with data returned")
                        errorCallback(nil, "Photo Result: Invalid Data Returned")
                    }
                    
                case .failure(let error):
                    print("UploadPhotoFileMutation Error: ", error.localizedDescription)
                    errorCallback(error, nil)
            }
        }
    }
}


extension AWGQLApiHelper: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        if let token = keychain.get(AWGC.AuthKeychainToken) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}
