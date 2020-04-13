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
        
        // setup OneSignal for push notifications (only works on actual devices)
        let oneSignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "[insert OneSignal Key Here]",
                                        handleNotificationAction: nil, settings: oneSignalInitSettings)
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
}

