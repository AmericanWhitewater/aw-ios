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
    
    static let shared = AWGQLArticleApiHelper()
    
    // Use the same client as the main AWGLApiHelper
    // This previously created a new client (with copy pasted base URL setting and auth handling)
    // NB: sharing will mean a shared cache for the requests here and in the main helper, see AWGQLApiHelper.shared.apollo
    private(set) lazy var apollo: ApolloClient = AWGQLApiHelper.shared.apollo
        
    private func fetchArticles(callback: @escaping NewsArticlesCallback, errorCallback: @escaping AWGraphQLError) {
        apollo.fetch(query: NewsQuery(page_size: 20, page: 0)) { result in
            switch result {
                case .success(let graphQLResult):
                    if let newsArts = graphQLResult.data?.articles?.data {
                        print("Found \(newsArts.count) news articles.")
                    }
                    
                    callback(graphQLResult.data?.articles?.data)

                case.failure(let error):

                    print("GraphQL Error: \(error)")
                    errorCallback(error, nil)
            }
        }
    }
    
   
    
    private func getExistingOrNewArticle(id: String?, context: NSManagedObjectContext) -> NewsArticle {
        let request = NewsArticle.fetchRequest() as NSFetchRequest<NewsArticle>
        request.predicate = NSPredicate(format: "id == %@", id ?? "")
        
        guard let result = try? context.fetch(request), let fetchedNewsArticle = result.first else {
            // no article found
            let newNewsArticle = NewsArticle(context: context)
            newNewsArticle.id = id
            return newNewsArticle
        }
        
        return fetchedNewsArticle
    }

    private func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    public func updateArticles(callback: @escaping UpdatedNewsCallback, errorCallback: @escaping ErrorCallback) {

        fetchArticles { (articles) in
            
            guard let articles = articles else {
                // handle error? errorCallback?
                return
            }
            
            print("news articles count: \(articles.count)")
            
            // process articles
            let context = self.getContext()
            let dispatchGroup = DispatchGroup()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            dispatchGroup.enter()
            
            context.perform {
                for article in articles {
                    let newsArticle = self.getExistingOrNewArticle(id: article.id, context: context)
                    newsArticle.abstract = article.abstract
                    newsArticle.abstractImage = article.abstractimage?.uri?.medium
                    newsArticle.author = article.author
                    newsArticle.contents = article.contents
                    newsArticle.icon = article.icon
                    newsArticle.image = article.image?.uri?.medium
                    newsArticle.postedDate = article.postedDate
                    newsArticle.releaseDate = article.releaseDate
                    newsArticle.shortName = article.shortName
                    newsArticle.title = article.title
                    newsArticle.uid = article.uid
                }
                
                do {
                    try context.save()
                    print("saved news article context")
                } catch {
                    let error = error as NSError
                    print("Unable to save news articles: \(error), \(error.userInfo)")
                    errorCallback(error)
                }
                
                dispatchGroup.leave()
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DefaultsManager.shared.articlesLastUpdated = Date()
            
            callback()

        } errorCallback: { (error, errorMessage) in
            print("Error with fetching news articles: \(error?.localizedDescription ?? errorMessage ?? "No error message available")")
            errorCallback(error) // AWTODO is this correct?
        }
    }
}
