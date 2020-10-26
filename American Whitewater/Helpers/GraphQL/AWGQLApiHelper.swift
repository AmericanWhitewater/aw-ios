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
    //typealias PhotoUploadCallback = (UploadPhotoFileMutation.Data.PhotoFileCreate) -> Void
    typealias PhotoFileUploadCallback = ()->Void // (PostPhotoWithFileMutation.Data.PhotoFileUpdate, PostPhotoMutation.Data) -> Void
    typealias PhotoUploadCallback = (PhotoUploadWithPropsMutation.Data.PhotoFileUpdate, PhotoPostUpdateMutation.Data.PostUpdate) -> Void
    typealias ObservationsCallback = ([Observations2Query.Data.Post.Datum]?) -> Void
    typealias PostObservationsCallback = (PostObservationMutation.Data.PostUpdate?) -> Void
    typealias PostPhotoObservationCallback = (PostObservationPhotoMutation.Data.PhotoFileUpdate, PostObservationMutation.Data) -> Void
    typealias AWMetricsCallback = ([String:String]) -> Void
    typealias AWGraphQLError = (Error?, String?) -> Void
    
    static let shared = AWGQLApiHelper()
    
    private(set) lazy var apollo: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(url: URL(string: "\(AWGC.AW_BASE_URL)/graphql")!)
        print("Using URL:", "\(AWGC.AW_BASE_URL)/graphql")
        httpNetworkTransport.delegate = self
        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
    
    private let keychain = KeychainSwift()
    
    public func getAccountInfo() {
        
        apollo.fetch(query: UserInfoQuery()) { result in
            switch result {
                case .success(let graphQLResult):
                    if let userResult = graphQLResult.data?.me {
                        DefaultsManager.userAccountId = userResult.uid
                        DefaultsManager.uname = userResult.uname
                        print("Stored uid: \(userResult.uid) and uname: \(userResult.uname)")
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
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
                            print("Received nil response: " +
                                " \(graphQLResult.data == nil ? "data is nil" : "data is not nil: \(graphQLResult.data.debugDescription)") " +
                                " \(graphQLResult.data?.postUpdate == nil ? "postUpdate is nil" : "postUpdate is not nil") " +
                                "GraphQLResult is: \(graphQLResult)")
                            var errorMessages = ""
                            let _ = graphQLResult.errors?.map { errorMessages = errorMessages + "\($0)"}
                            
                            print("Errors Returned: \(errorMessages)")
                            
                            errorCallback(nil, errorMessages.count > 0 ? errorMessages : "Unknown Error")
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
    

    public func getGaugeObservationsForReach(reach_id: Int, page: Int, page_size: Int, callback: @escaping ObservationsCallback, errorCallback: @escaping AWGraphQLError) {
        print("Getting observations for reach: \(reach_id)")
        apollo.fetch(query: Observations2Query(page_size: page_size, reach_id: "\(reach_id)", page: page, post_types: [PostType.gaugeObservation])) { result in
            print("finished querying Observations...processing...")
            switch result {
                case .success(let graphQLResult):

                    if let data = graphQLResult.data, let posts = data.posts {
                        for item in posts.data {
                            print("Observation:", item.id ?? 0, item.title ?? "no title")
                        }
                    }

                    callback(graphQLResult.data?.posts?.data)

                case .failure(let error):
                    print("GraphQL Error: \(error)")
                    errorCallback(error, nil)
            }
        }
    }
    
// -----
    
    
    public func postGaugeObservationFor(reach_id: Int, metric_id: Int, title: String, dateString: String, reading: Double, callback: @escaping PostObservationsCallback, errorCallback: @escaping AWGraphQLError) {

        let newID = NanoID.new(alphabet: .allLettersAndNumbers, size: 21)

        let newObservation = PostInput(title: title,
                                detail: nil,
                              postType: PostType.gaugeObservation,
                              postDate: dateString,
                               reachId: "\(reach_id)",
                                userId: nil,
                              metricId: metric_id,
                               reading: reading)

        if keychain.get(AWGC.AuthKeychainToken) != nil {
            apollo.perform(mutation: PostObservationMutation(id: newID, post: newObservation)) { result in
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
        apollo.fetch(query: PhotosQuery(page_size: page_size, reach_id: "\(reach_id)", page: page, post_types: [PostType.photoPost, PostType.journal])) { result in
            print("finished querying alerts...processing...")
            switch result {
                case .success(let graphQLResult):
                    callback(graphQLResult.data?.posts?.data)
                
                case .failure(let error):
                    print("GraphQL Error: \(error)")
                    errorCallback(error, nil)
            }
        }
    }
    
    public func postPhotoForReach(photoPostType: PostType = PostType.photoPost, image: UIImage, reach_id: Int, caption: String, description: String, photoDate: String,
                                         reachObservation: Double? = nil, gauge_id: String? = nil, metric_id: Int? = nil, reachReading: Double? = nil,
                                         callback: @escaping PhotoUploadCallback, errorCallback: @escaping AWGraphQLError) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var nowString = ""
        if photoDate.count == 0 {
            nowString = dateFormatter.string(from: Date())
        } else {
            nowString = photoDate
        }
        
        let photoName = "photo_\(NanoID.new(alphabet: .allLettersAndNumbers, size: 10))"
        
        let newID = NanoID.new(alphabet: .allLettersAndNumbers, size: 21)
        
        var userId:String? = nil
        if let usrId = DefaultsManager.userAccountId { userId = usrId }

        var author:String? = nil
        if let authorString = DefaultsManager.uname { author = authorString }
                            
        let photoInput = PhotoInput(caption: caption, description: description, postId: newID, subject: caption, author: author, poiName: nil, poiId: nil, photoDate: nowString)
        
        // postInput - used for updating the post after the photo uploads to "complete" the posting
        // this is a server requirement and not a redundent step
        let postInput = PostInput(title: caption, detail: description, postType: photoPostType, postDate: nowString, reachId: "\(reach_id)", gaugeId: gauge_id, userId: userId, metricId: metric_id, reading: reachReading, observation: reachObservation)
        // AWTODO: ask what the difference between a PostInput reading vs observation is? Should Observation be a string? Why Double?
        // is this a mistake on the server?
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { print("can't get image data from UIImage for gallery post"); return; }
        
        let file = GraphQLFile(fieldName: "file", originalName: photoName, mimeType: "image/jpeg", data: imageData)
        
        apollo.upload(operation: PhotoUploadWithPropsMutation(id: newID, file: photoName, photoSectionType: PhotoSectionsType.post, photoTypeId: newID, photoInput: photoInput), files: [file]) { result in
            
            switch result {
                case .success(let graphQLResult):
                    print("Successful upload!")
                    print("GQL Result:", graphQLResult)
                    if let photoFileUpdate = graphQLResult.data?.photoFileUpdate {
                        print("Post id: \(photoFileUpdate.postId ?? "n/a") and \(photoFileUpdate.post.debugDescription)")
                                                
                        //callback(photoFileUpdate)
                        self.updatePhotoPost(postId: newID, postInput: postInput, photoResult: photoFileUpdate, callback: callback, errorCallback: errorCallback);
                    } else {
                        errorCallback(nil, graphQLResult.errors?.debugDescription ?? "n/a")
                    }
                case .failure(let error):
                    print("Error uploading:", error)
                    errorCallback(error, nil)
            }
            
        }
    }
    
    private func updatePhotoPost(postId: GraphQLID, postInput: PostInput, photoResult: PhotoUploadWithPropsMutation.Data.PhotoFileUpdate,
                                 callback: @escaping PhotoUploadCallback, errorCallback: @escaping AWGraphQLError) {
        
        apollo.perform(mutation: PhotoPostUpdateMutation(id: postId, post: postInput)) { postUpdateResult in
            switch postUpdateResult {
                case .success(let graphQLResult):
                    print("updatePhotoPost:", graphQLResult)
                    if let postUpdate = graphQLResult.data?.postUpdate {
                        callback(photoResult, postUpdate)
                    } else {
                        errorCallback(nil, "Unable to update post after photo upload")
                    }
                case .failure(let error):
                    print("Error:", error)
            }
        }
        
    }
    

    func getMetricsForGauge(id: String, metricsCallback: @escaping AWMetricsCallback) {
                
        apollo.fetch(query: GuageMetricsQuery(gauge_id: id) ) { result in
            switch result {
                case .success(let graphQLResult):
                    print(graphQLResult)
                    
                    if let data = graphQLResult.data, let gauge = data.gauge {
                        print(gauge.id ?? "no id")
                        print(gauge.name ?? "no name")
                        print(gauge.source ?? "no source")
                     
                        var availableMetrics = [String:String]()
                        if let updates = gauge.updates {
                            for update in updates {
                                print("Metric Name: \(update?.metric?.name ?? "no metric name")")
                                print("Metric ID: \(update?.metric?.id ?? "no metric id")")
                                print("Metric Format: \(update?.metric?.format ?? "no metric format")")
                                print("Metric Unit: \(update?.metric?.unit ?? "no metric unit")")
                                if let update = update, let metric = update.metric, let unit = metric.unit, let id = metric.id {
                                    availableMetrics[unit] = id
                                }
                            }
                        }
                        
                        metricsCallback(availableMetrics)
                    }
                
                case .failure(let error):
                    print("GraphQL Error: \(error)")
                    //errorCallback(error, nil)
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
