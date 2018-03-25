//
//  NSPersistentContainer.swift
//  ResinDemoApp
//
//  Created by Alex Kerney on 2/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation

extension NSPersistentContainer {
    func saveContextIfNeeded() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

