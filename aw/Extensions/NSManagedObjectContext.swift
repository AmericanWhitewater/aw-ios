//
//  NSManagedObjectContext.swift
//  ResinDemoApp
//
//  Created by Alex Kerney on 2/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    func persist(block: @escaping () -> Void) {
        perform {
            block()
            
            do {
                try self.save()
            } catch let nserror as NSError {
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                self.rollback()
            }
        }
    }
}

