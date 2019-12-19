//
//  AppDelegate.swift
//  American Whitewater
//
//  Updated by David Nelson on 7/4/19.
//  Copyright © 2019 American Whitewater. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import OneSignal
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // setup CoreData functions and properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AmericanWhitewaterV2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error {
                fatalError("Unresolved Error: \(error), \(error.localizedDescription)")
            }
        })
        
        return container
    }()
    
    func saveAWContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // setup OneSignal for push notifications
        // NOTE: only works on actual devices!
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions, appId: "fd159b28-68c6-465e-9301-1bf712f6c435",
                                        handleNotificationAction: nil, settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // Initialize Firebase for crash reporting
        // and analytics of the app
        FirebaseApp.configure()
        
        // This nice library moves text fields out of the way of the keyboard automagically
        IQKeyboardManager.shared.enable = true
        
        // in case of crash reset the flag saying we are finding reaches
        DefaultsManager.fetchingreaches = false

        // setting first values for first run
        if !DefaultsManager.completedFirstRun {
            DefaultsManager.showRegionFilter = true
            DefaultsManager.showDistanceFilter = false
            DefaultsManager.distanceFilter = 100
            DefaultsManager.classFilter = [1,2,3,4,5]            
        }
        
        // make Status Bar white
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "primary")!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
}

