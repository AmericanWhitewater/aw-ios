import Foundation

struct GaugeObservation: Hashable, Equatable {
    struct Photo: Hashable, Equatable {
        let thumb: String?
        let med: String?
        let big: String?
    }
    
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
    
        self.photos = datum.photos.compactMap { photo in
            guard
                let image = photo.image,
                let uri = image.uri,
                let thumb = uri.thumb,
                let medium = uri.medium,
                let big = uri.big
            else {
                return nil
            }
            
            return Photo(thumb: thumb, med: medium, big: big)
        }
    }
    
    init(postUpdate: PostObservationMutation.Data.PostUpdate) {
        self.id = postUpdate.id
        self.title = postUpdate.title
        self.detail = postUpdate.detail
        self.uid = postUpdate.uid
        self.author = postUpdate.user?.uname
        if let date = postUpdate.postDate {
            self.date = Self.dateFormatter.date(from: date)
        } else {
            self.date = nil
        }
        self.reachId = postUpdate.reachId
        self.gaugeId = postUpdate.gaugeId
        self.metric = postUpdate.metric?.unit
        self.reading = postUpdate.reading
    
        self.photos = postUpdate.photos.compactMap { photo in
            guard
                let image = photo.image,
                let uri = image.uri,
                let thumb = uri.thumb,
                let medium = uri.medium,
                let big = uri.big
            else {
                return nil
            }
            
            return Photo(thumb: thumb, med: medium, big: big)
        }
    }
    
}
