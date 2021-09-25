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
            
            // Save the articles
            // It's not necessary to retrieve local copies and merge, because on conflict the new versions will replace the old
            do {
                try DB.shared.write { db in
                    for article in articles {
                        try article.save(db)
                    }
                }
                
                DefaultsManager.shared.articlesLastUpdated = Date()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
