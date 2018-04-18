import Foundation

struct AWArticle: Codable {
    let abstract: String
    let abstractPhoto: String
    let articleID: String
    let author: String
    let contact: String
    let contents: String
    let contentsPhoto: String
    let posted: String
    let title: String

    // make date as a computed property
    var date: Date? {
        if let posted = Double(posted) {
            return Date(timeIntervalSince1970: posted)
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case abstract
        case articleID = "articleid"
        case author
        case contact
        case contents
        case abstractPhoto = "abstract_photo"
        case contentsPhoto = "contents_photo"
        case posted = "postedepoch"
        case title

    }
}

struct AWArticleSubresponse: Codable {
    let articles: [AWArticle]

    enum CodingKeys: String, CodingKey {
        case articles = "CArticleGadgetJSON_view_list"
    }
}

struct AWArticleResponse: Codable {
    let articles: AWArticleSubresponse
}
