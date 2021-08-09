//
//  Accident.swift
//  Accident
//
//  Created by Phillip Kast on 8/8/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation

struct Accident: Hashable, Equatable {
    var id: String
    var date: Date?
    var reachId: Int?
    var river: String?
    var section: String?
    var location: String?
    var waterLevel: String?
    var difficulty: String?
    var age: Int?
    var experience: String?
    var description: String?
    var factors: [String]
    var injuries: [String]
    var causes: [String]
    
    init(id: String, date: Date?, reachId: Int?, river: String?, section: String?, location: String?, waterLevel: String?, difficulty: String?, age: Int?, experience: String?, description: String?, factors: [String], injuries: [String], causes: [String]) {
        self.id = id
        self.date = date
        self.reachId = reachId
        self.river = river
        self.section = section
        self.location = location
        self.waterLevel = waterLevel
        self.difficulty = difficulty
        self.age = age
        self.experience = experience
        self.description = description
        self.factors = factors
        self.injuries = injuries
        self.causes = causes
    }
    
    static private let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd hh:mm:ss")
    
    init(datum: ReachAccidentsQuery.Data.Reach.Accident.Datum) {
        self.id = datum.id
       
        if let accidentDate = datum.accidentDate {
            self.date = Self.dateFormatter.date(from: accidentDate)
        } else {
            self.date = nil
        }
        
        if let reachId = datum.reachId {
            self.reachId = Int(reachId)
        } else {
            self.reachId = nil
        }
        
        self.river = datum.river
        self.section = datum.section
        self.location = datum.location
        self.waterLevel = datum.waterLevel
        self.difficulty = datum.difficulty
        self.age = datum.age
        self.experience = datum.experience
        self.description = datum.description
        self.factors = (datum.factors ?? []).compactMap(\.factor)
        self.injuries = (datum.injuries ?? []).compactMap(\.injury)
        self.causes = (datum.causes ?? []).compactMap(\.cause)
    }
}
