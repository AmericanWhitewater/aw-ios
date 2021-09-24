import Foundation
import GRDB

struct NewsArticle: Identifiable, Codable {
    var id: String
    var uid: String?
    var createdAt: Date
    var postedDate: Date?
    var releaseDate: Date?
    var abstract: String?
    var abstractImage: String?
    var title: String?
    var author: String?
    var contents: String?
    var icon: String?
    var image: String?
    var shortName: String?
}

extension NewsArticle: FetchableRecord, TableRecord, PersistableRecord {
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let uid = Column(CodingKeys.uid)
        static let createdAt = Column(CodingKeys.createdAt)
        static let postedDate = Column(CodingKeys.postedDate)
        static let releaseDate = Column(CodingKeys.releaseDate)
        static let abstract = Column(CodingKeys.abstract)
        static let abstractImage = Column(CodingKeys.abstractImage)
        static let title = Column(CodingKeys.title)
        static let author = Column(CodingKeys.author)
        static let contents = Column(CodingKeys.contents)
        static let icon = Column(CodingKeys.icon)
        static let image = Column(CodingKeys.image)
        static let shortName = Column(CodingKeys.shortName)        
    }
}
