//
//  ArticleUpdater.swift
//  American Whitewater
//
//  Created by Phillip Kast on 9/21/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation
import GRDB

class ArticleUpdater {
    private let api = API.shared
    
    /// Retrieves and updates news articles. Must not be called from within a DB write block
    public func updateArticles(completion: @escaping (Error?) -> Void) {
        api.getArticles { articles, error in
            guard
                let articles = articles,
                error == nil
            else {
                completion(error)
                return
            }
            
            do {
                try DB.shared.write { db in
                    for a in articles {
                        // We're no longer going to accept articles with a nil ID, since we must have a primary key to identify with
                        guard let id = a.id else {
                            continue
                        }
                        
                        // Create and save the article
                        // It's not necessary to retrieve local copies, because on conflict the new version will replace
                        let newsArticle = NewsArticle(
                            id: id,
                            uid: a.uid,
                            createdAt: Date(),
                            postedDate: self.isoDate(a.postedDate),
                            releaseDate: self.isoDate(a.releaseDate),
                            abstract: a.abstract,
                            abstractImage: a.abstractimage?.uri?.medium, // FIXME: this drops other sizes, Photo is a struct that can hold them all...
                            title: a.title,
                            author: a.author,
                            contents: a.contents,
                            icon: a.icon,
                            image: a.image?.uri?.medium, // FIXME: this drops other sizes, Photo is a struct that can hold them all...
                            shortName: a.shortName
                        )
                        
                        try newsArticle.save(db)
                    }
                }
                
                DefaultsManager.shared.articlesLastUpdated = Date()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    //
    // MARK: - Dates
    //
    
    private lazy var dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
    
    /// Convenience func that formats an optional ISO 8601 date string, returning a Date if possible
    private func isoDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        return dateFormatter.date(from: dateString)
    }
}
