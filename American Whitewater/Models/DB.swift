//
//  DB.swift
//  American Whitewater
//
//  Created by Phillip Kast on 9/18/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import Foundation
import GRDB

class DB {
    static let shared = try! DB()
    
    static let defaultDbName = "aw.sqlite"
    
    init(dbName: String = defaultDbName) throws {
        url = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        
        pool = try DatabasePool(path: url.path)
        
        try migrate()
    }
    
    let url: URL
    let pool: DatabasePool
    
    //
    // MARK: - read/write
    //
    
    public func read<T>(_ block: (Database) throws -> T) throws -> T {
        try pool.read(block)
    }
    
    @discardableResult public func write<T>(_ block: (Database) throws -> T) throws -> T {
        try pool.write(block)
    }
    
    
    //
    // MARK: - Migration
    //
    
    /// Migrates the database schema to the current version
    private func migrate() throws {
        try migrator.migrate(pool)
    }
    
    private var migrator: DatabaseMigrator {
        var m = DatabaseMigrator()
        
        m.registerMigration("create-newsArticle") { db in
            try db.create(table: "newsArticle") { t in
                t.column("id", .text) // String
                    .notNull()
                    .primaryKey(onConflict: .replace)
                
                t.column("uid", .text)
                
                t.column("createdAt", .datetime)
                    .notNull().defaults(sql: "CURRENT_TIMESTAMP")
                t.column("postedDate", .datetime)
                t.column("releaseDate", .datetime)

                t.column("abstract", .text)
                t.column("abstractImage", .text) // FIXME: should be/reference a Photo
                t.column("title", .text)
                t.column("author", .text)
                t.column("contents", .text)
                t.column("icon", .text)
                t.column("image", .text)  // FIXME: should be/reference a Photo
                t.column("shortName", .text)
            }
        }
        
        m.registerMigration("create-reach-rapid") { db in
            try db.create(table: "reach") { t in
                t.column("id", .integer) // Int
                    .notNull()
                    .primaryKey()
                    .unique(onConflict: .replace)
                
                t.column("createdAt", .datetime).notNull().defaults(sql: "CURRENT_TIMESTAMP")
                t.column("altname", .text) // String?
                t.column("avgGradient", .integer).defaults(to: 0).notNull() // Int
                t.column("maxGradient", .integer).defaults(to: 0).notNull() // Int
                t.column("condition", .text) // String?
                t.column("county", .text) // String?
                t.column("classRating", .text) // String?
                t.column("isClass1", .boolean).notNull().defaults(to: false) // Bool
                t.column("isClass2", .boolean).notNull().defaults(to: false) // Bool
                t.column("isClass3", .boolean).notNull().defaults(to: false) // Bool
                t.column("isClass4", .boolean).notNull().defaults(to: false) // Bool
                t.column("isClass5", .boolean).notNull().defaults(to: false) // Bool
                t.column("description", .text) // String?
                t.column("detailUpdated", .datetime)
                t.column("length", .double) // Double?
                t.column("name", .text) // String?
                t.column("photoId", .integer) // Int
                t.column("rc", .text) // String?
                t.column("river", .text) // String?
                t.column("section", .text) // String?
                t.column("shuttleDetails", .text) // String?
                t.column("state", .text) // String?
                t.column("putInLat", .double) // Double?
                t.column("putInLon", .double) // Double?
                t.column("takeOutLat", .double) // Double?
                t.column("takeOutLon", .double) // Double?
                t.column("zipcode", .text) // String?
                t.column("currentGageReading", .text) // String?
                t.column("gageId", .integer) // Int
                t.column("gageMax", .text) // String?
                t.column("gageMetric", .integer) // Int
                t.column("gageMin", .text) // String?
                t.column("gageUpdated", .datetime) // Date?
                t.column("lastGageReading", .text) // String?
                t.column("unit", .text) // String?
                t.column("delta", .text) // String?
                t.column("favorite", .boolean) // Bool
            }
            
            try db.create(table: "rapid", body: { t in
                t.column("id", .integer) // Int
                    .notNull()
                    .primaryKey()
                    .unique(onConflict: .replace)
                
                t.column("reachId") // Int
                    .notNull()
                    .indexed()
                    .references("reach", onDelete: .cascade)
                
                t.column("name", .text) // String?
                t.column("description", .text) // String?
                t.column("classRating", .text) // String?
                t.column("photoId", .text) // String?
                t.column("isHazard", .boolean) // Bool
                t.column("isPlaySpot", .boolean) // Bool
                t.column("isPortage", .boolean) // Bool
                t.column("isPutIn", .boolean) // Bool
                t.column("isTakeOut", .boolean) // Bool
                t.column("isWaterfall", .boolean) // Bool
                t.column("lat", .double) // Double
                t.column("lon", .double) // Double
            })
            
            // Distance queries search by lat/lon:
            try db.create(index: "putin", on: "reach", columns: ["putInLat", "putInLon"])
        }

        
        
        return m
    }
}
