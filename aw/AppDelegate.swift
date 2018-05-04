//
//  AppDelegate.swift
//  aw
//
//  Created by Alex Kerney on 3/21/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 print(persistentContainer.persistentStoreCoordinator.persistentStores.first?.url as Any)

        globalStyles()

        if var initialVC = window?.rootViewController as? MOCViewControllerType {
            initialVC.managedObjectContext = persistentContainer.viewContext
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AmericanWhitewater")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving Support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func globalStyles() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "primary")
        UINavigationBar.appearance().tintColor = UIColor(named: "white")
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor(named: "white")]
        UISearchBar.appearance().tintColor = UIColor.black

        UITabBar.appearance().tintColor = UIColor(named: "primary")
    }
}
