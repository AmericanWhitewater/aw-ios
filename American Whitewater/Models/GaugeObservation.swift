import Foundation

struct GaugeObservation: Hashable, Equatable {
    var id: String?
    var title: String?
    var detail: String?
    var uid: String?
    var author: String?
    var date: Date?
    var reachId: String?
    var gaugeId: String?
    var metric: String?
    var reading: Double?
    var photos: [Photo]
    
    private static let dateFormatter = DateFormatter(dateFormat: "YYYY-MM-DD hh:mm:ss")
    
    init(datum: Observations2Query.Data.Post.Datum) {
        self.id = datum.id
        self.title = datum.title
        self.detail = datum.detail
        self.uid = datum.uid
        self.author = datum.user?.uname
        if let date = datum.postDate {
            self.date = Self.dateFormatter.date(from: date)
        } else {
            self.date = nil
        }
        self.reachId = datum.reachId
        self.gaugeId = datum.gaugeId
        self.metric = datum.metric?.unit
        self.reading = datum.reading
    
        let postDate = datum.postDate != nil ? Self.dateFormatter.date(from: datum.postDate!) : nil
        self.date = postDate
        
        self.photos = datum.photos.compactMap {
            Photo(
                id: $0.id,
                author: nil,
                date: postDate,
                caption: nil,
                description: nil,
                thumbPath: $0.image?.uri?.thumb,
                mediumPath: $0.image?.uri?.medium,
                bigPath: $0.image?.uri?.big
            )
        }
    }
    
    init(postUpdate: PostObservationMutation.Data.PostUpdate) {
        id = postUpdate.id
        title = postUpdate.title
        detail = postUpdate.detail
        uid = postUpdate.uid
        author = postUpdate.user?.uname
        reachId = postUpdate.reachId
        gaugeId = postUpdate.gaugeId
        metric = postUpdate.metric?.unit
        reading = postUpdate.reading
    
        let postDate = postUpdate.postDate != nil ? Self.dateFormatter.date(from: postUpdate.postDate!) : nil
        self.date = postDate
        
        photos = postUpdate.photos.map {
            Photo(
                id: $0.id,
                author: $0.author,
                date: postDate,
                caption: $0.caption,
                description: $0.description,
                thumbPath: $0.image?.uri?.thumb,
                mediumPath: $0.image?.uri?.medium,
                bigPath: $0.image?.uri?.big
            )
        }
    }
    
}
