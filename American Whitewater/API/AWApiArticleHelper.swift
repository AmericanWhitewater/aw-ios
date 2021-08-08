import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import Foundation

class AWApiArticleHelper {

    private var fetchedResultsController: NSFetchedResultsController<Article>?
    
    // setup our singleton for the api helper class
    static let shared = AWApiArticleHelper()

    private init() {} // prevent any other default initializer
    
    typealias ArticlesFetchedCallback = ([AWArticle]) -> Void
    typealias UpdateCallback = () -> Void
    typealias ArticlesErrorCallback = (Error?) -> Void
    
    func fetchArticles(callback: @escaping ArticlesFetchedCallback, callbackError: @escaping ArticlesErrorCallback) {
        print("Fetching articles from server...")
                
        AF.request(articleURL).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //print(json.debugDescription)
                    var articlesList:[AWArticle] = []
                    
                    if let articles = json["articles"].dictionary {
                        
                        // first get heading article
                        if let mainArticle = articles["CArticleGadgetJSON_view"] {                            
                            let awTopArticle = AWArticle.init(json: mainArticle)
                            articlesList.insert(awTopArticle, at: 0)
                        }

                        
                        // then get the list of articles
                        if let articlesArray = articles["CArticleGadgetJSON_view_list"]?.array {
                            // add each article into our data model and store them
                            for item in articlesArray {
                                let awArticle = AWArticle.init(json: item)
                                articlesList.append(awArticle)
                            }
                        }
                    }

                    print("Fetched \(articlesList.count) articles from server")
                    
                    // send the created objects to the callback
                    callback(articlesList)
                case .failure(let error):
                    callbackError(error)
            }
        }
    }
    
    func findOrNewArticle(newArticle: AWArticle, context: NSManagedObjectContext) -> Article {
        let request = Article.fetchRequest() as NSFetchRequest<Article>
        request.predicate = NSPredicate(format: "articleId == %@", newArticle.articleid ?? "")
        
        
        guard let result = try? context.fetch(request), let fetchedArticle = result.first else {
            //print("Found a new article with id: \(newArticle.articleid ?? "unknown") ")
            let article = Article(context: context)
            article.articleId = newArticle.articleid
            return article
        }
        
        //print("Article with id: \(newArticle.articleid ?? "unknown") exists")
        return fetchedArticle
    }

    private func createOrUpdateArticle(newArticle: AWArticle, context: NSManagedObjectContext) {
        let article = findOrNewArticle(newArticle: newArticle, context: context)

        //print("Updating/adding article data")
        article.abstract = newArticle.abstract
        article.abstractPhoto = newArticle.abstractPhoto
        article.author = newArticle.author
        article.contact = newArticle.contact
        article.contents = newArticle.contents
        article.contentsPhoto = newArticle.contentsPhoto
        article.posted = newArticle.posted
        article.title = newArticle.title
    }
    
    func updateArticles(callback: @escaping UpdateCallback, callbackError: @escaping ArticlesErrorCallback) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchArticles(callback: { (articles) in
            
            //print("Articles fetched... updating context")
                        
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = managedObjectContext
            
            context.perform {
                for newArticle in articles {
                    self.createOrUpdateArticle(newArticle: newArticle, context: managedObjectContext)
                }
                
                do {
                    try context.save()
                    //print("Saved articles in background")
                } catch {
                    let error = error as NSError
                    print("Unable to save articles: \(error), \(error.userInfo)")
                    callbackError(error)
                }
                dispatchGroup.leave()
            }
            
        }) { (error) in
            // handle error
            if let error = error {
                print("Error updating articles: \(error), \(error.localizedDescription)")
                callbackError(error)
            }
            
            dispatchGroup.leave()
            
            return
        }
        
        dispatchGroup.notify(queue: .main) {
            managedObjectContext.perform {
                managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                print("Saving context")
                do {
                    try managedObjectContext.save()
                } catch {
                    let error = error as NSError
                    print("Unable to save main view context: \(error), \(error.userInfo)")
                    callbackError(error)
                }
            }

            DefaultsManager.shared.articlesLastUpdated = Date()
            callback()
        }
    }
}
