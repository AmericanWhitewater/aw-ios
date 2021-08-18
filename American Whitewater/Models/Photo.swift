import Foundation

extension URL {
    init?(string: String?) {
        guard let string = string else {
            return nil
        }
        
        self.init(string: string)
    }
}

struct Photo {
    var id: String
    var author: String?
    var date: Date?
    var caption: String?
    var description: String?
    
    // URLs to the actual underlying images:
    private var thumbPath: String?
    private var mediumPath: String?
    private var bigPath: String?
    
    var thumbURL: URL? {
        guard let thumbPath = thumbPath else { return nil }
        return URL(string: "\(AWGC.AW_BASE_URL)\(thumbPath)")
    }
    
    var mediumURL: URL? {
        guard let mediumPath = mediumPath else { return nil }
        return URL(string: "\(AWGC.AW_BASE_URL)\(mediumPath)")
    }
    
    var bigURL: URL? {
        guard let bigPath = bigPath else { return nil }
        return URL(string: "\(AWGC.AW_BASE_URL)\(bigPath)")
    }
    
    static private let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
    
    init(id: String, author: String?, date: Date?, caption: String?, description: String?, thumbPath: String?, mediumPath: String?, bigPath: String?) {
        self.id = id
        self.author = author
        self.date = date
        self.caption = caption
        self.description = description
        self.thumbPath = thumbPath
        self.mediumPath = mediumPath
        self.bigPath = bigPath
    }

    init(photo: PhotosQuery.Data.Post.Datum.Photo) {
        id = photo.id
        author = photo.author
        date = Self.dateFormatter.date(from: photo.photoDate ?? "")
        caption = photo.caption
        description = photo.description
        thumbPath = photo.image?.uri?.thumb
        mediumPath = photo.image?.uri?.medium
        bigPath = photo.image?.uri?.big
    }
}
