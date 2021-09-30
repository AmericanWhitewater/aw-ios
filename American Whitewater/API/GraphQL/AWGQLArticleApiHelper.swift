import Foundation
import Alamofire
import Apollo
import CoreData

class AWGQLArticleApiHelper
{
    typealias NewsArticlesCallback = ([NewsQuery.Data.Article.Datum]?) -> Void
    typealias AWGraphQLError = (Error?, String?) -> Void
    typealias ErrorCallback = (Error?) -> Void
    typealias UpdatedNewsCallback = () -> Void
    
    private let apollo: ApolloClient
    
    init(apollo: ApolloClient) {
        self.apollo = apollo
    }
        
    public func getArticles(callback: @escaping (NewsArticlesCallback), errorCallback: @escaping (Error) -> Void) {
        apollo.fetch(query: NewsQuery(page_size: 20, page: 0)) { result in
            switch result {
                case .success(let graphQLResult):
                    if let newsArts = graphQLResult.data?.articles?.data {
                        print("Found \(newsArts.count) news articles.")
                    }
                    
                    callback(graphQLResult.data?.articles?.data)

                case.failure(let error):

                    print("GraphQL Error: \(error)")
                    errorCallback(error)
            }
        }
    }
}
