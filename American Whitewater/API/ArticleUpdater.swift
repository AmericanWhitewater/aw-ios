//
//  ArticleUpdater.swift
//  American Whitewater
//
//  Created by Phillip Kast on 9/21/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation
import CoreData

class ArticleUpdater {
    private let api = API.shared
    
    /// The main NSManagedObjectContext this updater will operate on
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    private func getExistingOrNewArticle(id: String?, context: NSManagedObjectContext) -> NewsArticle {
        let request = NewsArticle.fetchRequest() as NSFetchRequest<NewsArticle>
        request.predicate = NSPredicate(format: "id == %@", id ?? "")
        
        guard
            let result = try? context.fetch(request),
                let fetchedNewsArticle = result.first
        else {
            // no article found
            let newNewsArticle = NewsArticle(context: context)
            newNewsArticle.id = id
            return newNewsArticle
        }
        
        return fetchedNewsArticle
    }
    
    public func updateArticles(completion: @escaping (Error?) -> Void) {
        api.getArticles { articles, error in
            guard
                let articles = articles,
                error == nil
            else {
                completion(error)
                return
            }
            
            // TODO: saves on the main context, make a private queue child context, do the work there and merge?
            // This is what ReachUpdater does, but probably unnecessary here (presumably this only gets a few news articles not 1000s)
            let context = self.managedObjectContext
            
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
                    DefaultsManager.shared.articlesLastUpdated = Date()
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }
}
