import UIKit

extension UINavigationController {
    /// Defaults to displaying a light content status bar. By default, UINavigationController sets its own status bar style based on it's navigation bar configuration, which is awkward to work with.
    /// Note that the UIViewController's implementation of preferredStatusBarStyle returns .default, so this extension means that view controllers will need to explicitly set .lightContent or .darkContent to avoid getting the new default (.lightContent) that's returned here.
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if
            let topPreference = topViewController?.preferredStatusBarStyle,
            topPreference != .default
        {
            return topPreference
        }
        
        return .lightContent
    }
}
