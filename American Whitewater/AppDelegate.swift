import UIKit
import netfox
import Firebase
import OneSignal
import OAuthSwift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?    
    var runsListViewController: RunsListViewController? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // setup OneSignal for push notifications (only works on actual devices)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId(AWGC.AWOneSignalKey)

        // Initialize Firebase for crash reporting
        // and analytics of the app
        FirebaseApp.configure()
        
        // This nice library moves text fields out of the way of the keyboard automagically
        IQKeyboardManager.shared.enable = true
        
        // Nav bar appearance incantations to set background color and title color, on both scrolled and scroll edge appearance
        // This wasn't necessary until iOS 15, see this thread for some good background: https://developer.apple.com/forums/thread/682420
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = UIColor(named: "primary")
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "primary")!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        // setup network debugging for debug only
        #if DEBUG
            NFX.sharedInstance().start()
        #endif
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
      if (url.host == "oauth-callback") {
        OAuthSwift.handle(url: url)
      }
      return true
    }
}
