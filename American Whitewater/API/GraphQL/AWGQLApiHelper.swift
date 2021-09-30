import Foundation
import KeychainSwift
import Alamofire
import Apollo

class AWGQLApiHelper
{
    typealias AccidentCallback = ([ReachAccidentsQuery.Data.Reach.Accident.Datum]?) -> Void
    typealias AlertsCallback = ([AlertsQuery.Data.Post.Datum]?) -> Void
    typealias AlertPostCallback = (PostAlertMutation.Data.PostUpdate) -> Void
    typealias PhotosCallback = ([PhotosQuery.Data.Post.Datum]?) -> Void
    //typealias PhotoUploadCallback = (UploadPhotoFileMutation.Data.PhotoFileCreate) -> Void
    typealias PhotoFileUploadCallback = ()->Void // (PostPhotoWithFileMutation.Data.PhotoFileUpdate, PostPhotoMutation.Data) -> Void
    typealias PhotoUploadCallback = (PhotoUploadWithPropsMutation.Data.PhotoFileUpdate, PhotoPostUpdateMutation.Data.PostUpdate) -> Void
    typealias ObservationsCallback = ([Observations2Query.Data.Post.Datum]?) -> Void
    typealias PostObservationsCallback = (PostObservationMutation.Data.PostUpdate) -> Void
    typealias PostPhotoObservationCallback = (PostObservationPhotoMutation.Data.PhotoFileUpdate, PostObservationMutation.Data) -> Void
    typealias AWGraphQLError = (Error) -> Void
    
    enum Errors: Error, LocalizedError {
        case notSignedIn
        case graphQLError(message: String)
        
        // localizedDescription is called on these errors all over the place.
        // This makes it return the message:
        var errorDescription: String? {
            switch self {
            case .notSignedIn:
                return "Not signed in."
            case .graphQLError(let message):
                return message
            }
        }
    }

    private let apollo: ApolloClient
    private let keychain: KeychainSwift
    
    init(apollo: ApolloClient, keychain: KeychainSwift = .init()) {
        self.apollo = apollo
        self.keychain = keychain
    }
    
    // FIXME: fire and forget, has no way to report errors or result
    public func updateAccountInfo() {
        apollo.fetch(query: UserInfoQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                if let userResult = graphQLResult.data?.me {
                    DefaultsManager.shared.userAccountId = userResult.uid
                    DefaultsManager.shared.uname = userResult.uname
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
                    callback(graphQLResult.data?.reach?.accidents?.data)
                case.failure(let error):
                    errorCallback(error)
            }
        }
    }
    
    public func getAlertsForReach(reach_id: Int, page: Int, page_size: Int, callback: @escaping AlertsCallback, errorCallback: @escaping AWGraphQLError) {
        apollo.fetch(query: AlertsQuery(page_size: page_size, reach_id: "\(reach_id)", page: page, post_types: [PostType.warning])) { result in
            switch result {
                case .success(let graphQLResult):
                    callback(graphQLResult.data?.posts?.data)
                case .failure(let error):
                    errorCallback(error)
            }
        }
    }
    
    public func postAlertFor(reach_id: Int, message: String, callback: @escaping AlertPostCallback, errorCallback: @escaping AWGraphQLError) {
        let newID = NanoID.new(alphabet: .allLettersAndNumbers, size: 21)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        let newAlert = PostInput(
            title: nil,
            detail: message,
            postType: PostType.warning,
            postDate: dateString,
            reachId: "\(reach_id)",
            gaugeId: nil,
            userId: nil,
            metricId: nil,
            reading: nil
        )
        
        if keychain.get(AWGC.AuthKeychainToken) != nil {
            apollo.perform(mutation: PostAlertMutation(id: newID, post: newAlert)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data, let postUpdate = data.postUpdate {
                        callback(postUpdate)
                    } else {
                        // FIXME: is this what's intended? A human readable list of error messages that can be passed up then displayed:
                        let errorMessages = graphQLResult.errors?.map { $0.localizedDescription }.joined(separator: ", ") ?? "Unknown Error"
                        let error = Errors.graphQLError(message: errorMessages)
                        errorCallback(error)
                    }
                case .failure(let error):
                    errorCallback(error)
                }
            }
        } else {
            errorCallback(Errors.notSignedIn)
        }
    }
    

    public func getGaugeObservationsForReach(reach_id: Int, page: Int, page_size: Int, callback: @escaping ObservationsCallback, errorCallback: @escaping AWGraphQLError) {
        apollo.fetch(query: Observations2Query(page_size: page_size, reach_id: "\(reach_id)", page: page, post_types: [PostType.gaugeObservation])) { result in
            switch result {
            case .success(let graphQLResult):
                callback(graphQLResult.data?.posts?.data)
            case .failure(let error):
                errorCallback(error)
            }
        }
    }
    
    public func postGaugeObservationFor(reach_id: Int, gauge_id: Int?, metric_id: Int, observation: Double?, title: String?, dateString: String, reading: Double, callback: @escaping PostObservationsCallback, errorCallback: @escaping AWGraphQLError) {
        let newID = NanoID.new(alphabet: .allLettersAndNumbers, size: 21)

        let newObservation = PostInput(
            title: title,
            detail: nil,
            postType: PostType.gaugeObservation,
            postDate: dateString,
            reachId: "\(reach_id)",
            gaugeId: gauge_id != nil ? "\(gauge_id)" : nil,
            userId: nil,
            metricId: metric_id,
            reading: reading,
            observation: observation
        )

        if keychain.get(AWGC.AuthKeychainToken) != nil {
            apollo.perform(mutation: PostObservationMutation(id: newID, post: newObservation)) { result in
                switch result {
                case .success(let graphQLResult):
                    if let postUpdate = graphQLResult.data?.postUpdate {
                        callback(postUpdate)
                    } else {
                        // FIXME: is this actually a success? can the server succeed and not return data.postUpdate
                        errorCallback(Errors.graphQLError(message: "No update returned"))
                    }
                case .failure(let error):
                    errorCallback(error)
                }
            }
        } else {
            errorCallback(Errors.notSignedIn)
        }
    }
    
    public func getPhotosForReach(reach_id: Int, page: Int, page_size: Int, callback: @escaping PhotosCallback, errorCallback: @escaping AWGraphQLError) {
        apollo.fetch(query: PhotosQuery(page_size: page_size, reach_id: "\(reach_id)", page: page, post_types: [PostType.photoPost, PostType.journal])) { result in
            switch result {
            case .success(let graphQLResult):
                callback(graphQLResult.data?.posts?.data)
            case .failure(let error):
                errorCallback(error)
            }
        }
    }
    
    public func postPhotoForReach(
        photoPostType: PostType = PostType.photoPost,
        image: UIImage,
        reach_id: Int,
        caption: String?,
        description: String,
        photoDate: String,
        reachObservation: Double? = nil,
        gauge_id: String? = nil,
        metric_id: Int? = nil,
        reachReading: Double? = nil,
        callback: @escaping PhotoUploadCallback,
        errorCallback: @escaping AWGraphQLError
    ) {
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
        if let usrId = DefaultsManager.shared.userAccountId { userId = usrId }

        var author:String? = nil
        if let authorString = DefaultsManager.shared.uname { author = authorString }
                            
        let photoInput = PhotoInput(caption: caption, description: description, postId: newID, subject: caption, author: author, poiName: nil, poiId: nil, photoDate: nowString)
        
        // postInput - used for updating the post after the photo uploads to "complete" the posting
        // this is a server requirement and not a redundent step
        let postInput = PostInput(title: caption, detail: description, postType: photoPostType, postDate: nowString, reachId: "\(reach_id)", gaugeId: gauge_id, userId: userId, metricId: metric_id, reading: reachReading, observation: reachObservation)
        // AWTODO: ask what the difference between a PostInput reading vs observation is? Should Observation be a string? Why Double?
        // is this a mistake on the server?
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            errorCallback(Errors.graphQLError(message: "Can't read image data"))
            return
        }
        
        let file = GraphQLFile(fieldName: "file", originalName: photoName, mimeType: "image/jpeg", data: imageData)
        
        apollo.upload(operation: PhotoUploadWithPropsMutation(id: newID, file: photoName, photoSectionType: PhotoSectionsType.post, photoTypeId: newID, photoInput: photoInput), files: [file]) { result in
            
            switch result {
            case .success(let graphQLResult):
                if let photoFileUpdate = graphQLResult.data?.photoFileUpdate {
                    self.updatePhotoPost(
                        postId: newID,
                        postInput: postInput,
                        photoResult: photoFileUpdate,
                        callback: callback,
                        errorCallback: errorCallback
                    )
                } else {
                    errorCallback(Errors.graphQLError(message: graphQLResult.errors?.debugDescription ?? "n/a"))
                }
            case .failure(let error):
                errorCallback(error)
            }
            
        }
    }
    
    private func updatePhotoPost(postId: GraphQLID, postInput: PostInput, photoResult: PhotoUploadWithPropsMutation.Data.PhotoFileUpdate,
                                 callback: @escaping PhotoUploadCallback, errorCallback: @escaping AWGraphQLError) {
        
        apollo.perform(mutation: PhotoPostUpdateMutation(id: postId, post: postInput)) { postUpdateResult in
            switch postUpdateResult {
                case .success(let graphQLResult):
                    if let postUpdate = graphQLResult.data?.postUpdate {
                        callback(photoResult, postUpdate)
                    } else {
                        errorCallback(Errors.graphQLError(message: "Unable to update post after photo upload"))
                    }
                case .failure(let error):
                    errorCallback(error)
            }
        }
    }
    
    public func getMetricsForGauge(id: String, metricsCallback: @escaping ([GuageMetricsQuery.Data.Gauge.Update.Metric]?, Error?) -> Void) {
        apollo.fetch(query: GuageMetricsQuery(gauge_id: id) ) { result in
            switch result {
            case .success(let result):
                let metrics = result.data?.gauge?.updates?.compactMap { $0?.metric } ?? []
                metricsCallback(metrics, nil)
            case .failure(let error):
                metricsCallback(nil, error)
            }
        }
    }
    
    public func getGagesForReach(id: String, callback: @escaping ([GagesForReachQuery.Data.Gauge.Gauge]?, Error?) -> Void) {
        apollo.fetch(query: GagesForReachQuery(reach_id: id)) { result in
            switch result {
            case .success(let result):
                let gauges = result.data?.gauges?.gauges?.compactMap({ $0 }) ?? []
                callback(gauges, nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
}
