//
//  AWArticleAPIHelper.swift
//  aw
//
//  Created by Alex Kerney on 3/31/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation
import UIKit

struct AWArticleResponse: Codable {
    struct AWArticleSubresponse: Codable {
        let articles: [AWArticle]

        enum CodingKeys: String, CodingKey {
            case articles = "CArticleGadgetJSON_view_list"
        }
    }
    let articles: AWArticleSubresponse
}

struct AWArticle: Codable {
    let abstract: String
    let abstractPhoto: String
    let articleID: String
    let author: String
    let contact: String
    let contents: String
    let contentsPhoto: String
    let posted: String

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

    }
}

struct AWArticleAPIHelper {
    typealias ArticlesCallback = ([AWArticle]) -> Void
    typealias UpdateCallback = () -> Void

    static func fetchArticles(callback: @escaping ArticlesCallback) {
        let url = URL(string: "https://www.americanwhitewater.org/content/News/all/type/frontpagenews/subtype//page/0/.json?limit=10")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let decoder = JSONDecoder()
            guard let data = data, let json = try? decoder.decode(AWArticleResponse.self, from: data) else {
                print("Unable to decode articles")
                return
            }
            callback(json.articles.articles)
        }
        task.resume()
    }

    private static func findOnNewArticle(newArticle: AWArticle, context: NSManagedObjectContext) -> Article {
        let request: NSFetchRequest<Article> = Article.fetchRequest()
        request.predicate = NSPredicate(format: "articleID == %@", newArticle.articleID)

        guard let result = try? context.fetch(request), let fetchedArticle = result.first else {
            let article = Article(context: context)
            article.articleID = newArticle.articleID
            return article
        }
        return fetchedArticle
    }

    private static func createOrUpdateArticle(newArticle: AWArticle, context: NSManagedObjectContext) {
        let article = findOnNewArticle(newArticle: newArticle, context: context)

        article.abstract = newArticle.abstract
        article.abstractPhoto = newArticle.abstractPhoto
        article.author = newArticle.author
        article.contact = newArticle.contact
        article.contents = newArticle.contents
        article.contentsPhoto = newArticle.contentsPhoto
        article.posted = newArticle.date
    }

    static func updateArticles(viewContext: NSManagedObjectContext, callback: @escaping UpdateCallback) {
        let dispatchGroup = DispatchGroup()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dispatchGroup.enter()
        fetchArticles { (newArticles) in
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = viewContext

            context.perform {
                for newArticle in newArticles {
                    createOrUpdateArticle(newArticle: newArticle, context: context)
                }
                do {
                    try context.save()
                    print("background context saved")
                } catch {
                    let error = error as NSError
                    print("Unable to save background context \(error) \(error.userInfo)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            viewContext.perform {
                viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

                do {
                    try viewContext.save()
                    print("Saved view context")
                } catch {
                    let error = error as NSError
                    print("Unable to save view context \(error) \(error.userInfo)")
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            callback()
        }
    }
}

