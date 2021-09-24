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
    private let pool: DatabasePool
    
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
        
        
        return m
    }
}
