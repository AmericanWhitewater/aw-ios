//
//  MOCViewControllerType.swift
//  ResinDemoApp
//
//  Created by Alex Kerney on 2/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import Foundation

protocol MOCViewControllerType {
    var managedObjectContext: NSManagedObjectContext? { get set }
}

