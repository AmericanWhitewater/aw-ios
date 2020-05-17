import Foundation
import NYAlertViewController
import Contacts

class DuffekDialog {
    
    static let shared = DuffekDialog()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    private var alertViewController: NYAlertViewController?
    
    /// Shows a simple Alert Dialog with an Ok Button added
    /// Auto closes and allows for tap and swipe to close gestures
    ///
    /// - Parameters:
    ///   - title: title of the dialog
    ///   - message: the message to display
    func showOkDialog(title: String, message: String) {
        
        // setup standard alert dialog
        alertViewController = styledAlert()
        
        if let alertViewController = alertViewController {
            alertViewController.title = title
            alertViewController.message = "\n\(message)\n"
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.backgroundTapDismissalGestureEnabled = true
            
            let okAction = NYAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in
                alertViewController.dismiss(animated: true, completion: nil)
            }
            
            alertViewController.addAction(okAction)
            
            self.displayAlert(alertController: alertViewController)
        }
    }
    
    func showOkDialog(title: String, message: String, completion: (()->Void)?) {
        
        // setup standard alert dialog
        alertViewController = styledAlert()
        
        if let alertViewController = alertViewController {
            alertViewController.title = title
            alertViewController.message = "\n\(message)\n"
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.backgroundTapDismissalGestureEnabled = true
            
            let okAction = NYAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in
                alertViewController.dismiss(animated: true, completion: completion)
            }
            
            alertViewController.addAction(okAction)
            
            self.displayAlert(alertController: alertViewController)
        }
    }
    
    
    /// Shows a basic alert and the user can specify standard and cancel buttons
    ///
    /// - Parameters:
    ///   - title: title of the dialog
    ///   - message: the message to be displayed
    ///   - buttonAction: positive action handler
    ///   - cancelAction: cancel action handler
    func showStandardDialog(title: String, message: String, buttonTitle: String, buttonFunction: @escaping ()->Void, cancelFunction: @escaping ()->Void) {
        
        // setup standard alert dialog
        alertViewController = styledAlert()
        
        if let alertViewController = alertViewController {
            alertViewController.title = title
            alertViewController.message = "\n\(message)\n"
            
            // add users defined actions
            let buttonAction = NYAlertAction(title: buttonTitle, style: .default) { (_) in
                self.alertViewController?.dismiss(animated: true, completion: nil)
                
                buttonFunction()
            }
            alertViewController.addAction(buttonAction)
            
            let cancelAction = NYAlertAction(title: "Cancel", style: .cancel) { (_) in
                self.alertViewController?.dismiss(animated: true, completion: nil)
                
                cancelFunction()
            }
            alertViewController.addAction(cancelAction)
            
            self.displayAlert(alertController: alertViewController)
        }
    }
    
    
    func showStandardDialogWithSuccessCompletion(title: String, message: String, buttonTitle: String, successCompletion: @escaping ()->Void) {
        
        // setup standard alert dialog
        alertViewController = styledAlert()
        
        if let alertViewController = alertViewController {
            alertViewController.title = title
            alertViewController.message = "\n\(message)\n"
            
            // add users defined actions
            let buttonAction = NYAlertAction(title: buttonTitle, style: .default) { (_) in
                self.alertViewController?.dismiss(animated: true, completion: successCompletion)
            }
            alertViewController.addAction(buttonAction)
            
            let cancelAction = NYAlertAction(title: "Cancel", style: .cancel) { (_) in
                self.alertViewController?.dismiss(animated: true, completion: nil)
            }
            alertViewController.addAction(cancelAction)
            
            self.displayAlert(alertController: alertViewController)
        }
    }
    
    func showPictureOptionsDialog(title: String, message: String, takePicture: @escaping () -> Void, selectPicture: @escaping () -> Void) {
        alertViewController = styledAlert()
        
        if let alertViewController = alertViewController {
            alertViewController.title = title
            alertViewController.titleColor = UIColor.white
            alertViewController.message = "\n\(message)\n"
            alertViewController.buttonTitleFont = UIFont.boldSystemFont(ofSize: 17)
            
            let takePictureAction = NYAlertAction(title: "Camera", style: .default) { (_) in
                self.alertViewController?.dismiss(animated: true, completion: nil)
                
                takePicture()
            }
            alertViewController.addAction(takePictureAction)
            
            let selectPictureAction = NYAlertAction(title: "Select Picture", style: .default) { (_) in
                self.alertViewController?.dismiss(animated: true, completion: nil)
                
                selectPicture()
            }
            alertViewController.addAction(selectPictureAction)
            
            // add default cancel option
            let cancelAction = NYAlertAction(title: "Cancel", style: .cancel) { (_) in
                self.alertViewController?.dismiss(animated: true, completion: nil)
            }
            alertViewController.addAction(cancelAction)
            
            self.displayAlert(alertController: alertViewController)
        }
    }
    
    func showContactPickerDialogFor(contact:CNContact, pickerDataSource:UIPickerViewDataSource, pickerDelegate: UIPickerViewDelegate, title: String, message: String, selectedActionPressed: @escaping ()->Void) {
        
        alertViewController = styledAlert()
        guard let alertViewController = alertViewController else {
            print("Error creating alertViewController");
            return;
        }
        
        alertViewController.title = title
        alertViewController.message = "\n\(message)\n"
        
        let cancelAction = NYAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.alertViewController?.dismiss(animated: true, completion: nil)
        }
        
        let selectAction = NYAlertAction(title: "Select", style: .default) { (_) in
            self.alertViewController?.dismiss(animated: true, completion: nil)
            
            // Send selected option from picker view
            selectedActionPressed()
        }
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(selectAction)
        
        // setup contact picker view
        let contactPicker = UIPickerView()
        contactPicker.dataSource = pickerDataSource
        contactPicker.delegate = pickerDelegate
        
        // add picker view to alertViewControllers content view
        alertViewController.alertViewContentView = contactPicker
        
        // show the alert
        self.displayAlert(alertController: alertViewController)
        
        // select the first row in case the user hasn't already chosen an item by default
        contactPicker.selectRow(0, inComponent: 0, animated: false)
        if let delegate = contactPicker.delegate {
            delegate.pickerView?(contactPicker, didSelectRow: 0, inComponent: 0)
        }
    }
    
    /// A direct way to hide the alert at any time
    func hideAlert() {
        alertViewController?.dismiss(animated: true, completion: nil)
    }
    
    /// Displays alert dialog on currently viewed window
    ///
    /// - Parameter alertController: displays the alert to the rootViewController
    private func displayAlert(alertController: UIViewController) {
        
        // the rootViewController may change based on where they are in the app
        // all views will be a tabViewController or NavigationViewController
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        // Display the chosen view
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    // Returns a NYAlertViewController that is styled in BrewFund colors and
    // has rounded corners, etc.
    private func styledAlert() -> NYAlertViewController {
        
        let alert = NYAlertViewController()
        
        // Corder Radius
        alert.buttonCornerRadius = 6.0
        alert.alertViewCornerRadius = 10.0
        
        // Set font sizes
        alert.titleFont = UIFont.boldSystemFont(ofSize: 18)
        alert.messageFont = UIFont.systemFont(ofSize: 16)
        
        // Set dialog colors
        //alert.view.tintColor =  self.view.tintColor;
        alert.alertViewBackgroundColor = UIColor.white
        alert.titleColor = UIColor.black
        alert.messageColor = UIColor.black
        alert.buttonColor = UIColor(named: "primary")
        alert.buttonTitleColor = UIColor.white
        alert.cancelButtonColor = UIColor(named: "primary_dark")
        alert.cancelButtonTitleColor = UIColor.white
        
        // Transition Style
        alert.transitionStyle = .fade
        
        return alert
        
    }
}

