//
//  Alert.swift
//  Alert
//
//  Created by Phillip Kast on 8/8/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation

struct Alert: Hashable, Equatable {
    var id: String?
    var title: String?
    var date: Date?
    var reachId: String?
    var revision: Int?
    var message: String?
    var poster: String?
    
    init(id: String?, title: String?, date: Date?, reachId: String?, revision: Int?, detail: String?, userName: String?) {
        self.id = id
        self.title = title
        self.date = date
        self.reachId = reachId
        self.revision = revision
        self.message = detail
        self.poster = userName
    }
    
    static private let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
    
    init(datum: AlertsQuery.Data.Post.Datum) {
        self.id = datum.id
        self.title = datum.title
        if let date = datum.postDate {
            self.date = Self.dateFormatter.date(from: date)
        } else {
            self.date = nil
        }
        self.reachId = datum.reachId
        self.revision = datum.revision
        self.message = datum.detail
        self.poster = datum.user?.uname
    }
}

// This extension maintains compatibility with the previous, UserDefaults based persistence for alerts.
// FIXME: That should go away. UserDefaults is not an appropriate place to store this kind of data
extension Alert {
    var dictionary: [String: String] {
        let postDate: String
        if let date = date {
            postDate = Self.dateFormatter.string(from: date)
        } else {
            postDate = ""
        }
        
        return [
            "postDate": postDate,
            "message": message ?? "",
            "poster": poster ?? ""
        ]
    }
    
    init(dict: [String: String]) {
        self.id = nil
        self.title = nil
        self.date = Self.dateFormatter.date(from: dict["postDate"] ?? "") ?? nil
        self.reachId = nil
        self.revision = nil
        self.message = dict["message"]
        self.poster = dict["poster"]
    }
}
