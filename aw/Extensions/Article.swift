//
//  Article.swift
//  aw
//
//  Created by Alex Kerney on 3/31/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation

extension Article {
    var abstractCleanedHTML: String? {
        if let abstract = abstract,
            let data = abstract.data(using: .utf8),
            let html = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return html.string
        } else {
            return nil
        }
    }

    var byline: String? {
        guard let date = posted, let author = author else { return nil }

        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.doesRelativeDateFormatting = true

        return "\(author), \(dateFormat.string(from: date))"
    }

    var abstractPhotoURL: String? {
        guard let abstractPhoto = abstractPhoto, let articleID = articleID  else { return nil }
        return "https://www.americanwhitewater.org/resources/images/abstract/\(articleID)-\(abstractPhoto).jpg"
    }
}
