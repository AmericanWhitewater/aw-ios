import Foundation
import NYAlertViewController
import Contacts

class DuffekDialog {
    
    static let shared = DuffekDialog()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    var alertViewController: NYAlertViewController?
    private var datePicker: UIDatePicker?
    
    func showPickerDialog(pickerDataSource:UIPickerViewDataSource, pickerDelegate: UIPickerViewDelegate, title: String, message: String, selectedActionPressed: @escaping ()->Void) {
        
        alertViewController = styledAlert()
        guard let alertViewController = alertViewController else {
            print("Error creating alertViewController");
            return;
        }
        
        alertViewController.title = title
        alertViewController.message = "\n\(message)\n"
        
        let selectAction = NYAlertAction(title: "Select", style: .default) { (_) in
            self.alertViewController?.dismiss(animated: true, completion: nil)
            
            // Send selected option from picker view
            selectedActionPressed()
        }
        
        alertViewController.addAction(selectAction)
        
        // setup contact picker view
        let picker = UIPickerView()
        picker.dataSource = pickerDataSource
        picker.delegate = pickerDelegate
        
        // add picker view to alertViewControllers content view
        alertViewController.alertViewContentView = picker
        
        // show the alert
        self.displayAlert(alertController: alertViewController)
        
        // select the first row in case the user hasn't already chosen an item by default
        picker.selectRow(0, inComponent: 0, animated: false)
        if let delegate = picker.delegate {
            delegate.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        }
    }
    
    
    func showDatePickerDialog(title: String, message: String, showTime: Bool? = nil, selectedActionPressed: @escaping (Date?)->Void) {
        
        alertViewController = styledAlert()
        guard let alertViewController = alertViewController else {
            print("Error creating alertViewController");
            return;
        }
        
        alertViewController.title = title
        alertViewController.message = "\n\(message)\n"
        
        let selectAction = NYAlertAction(title: "Select", style: .default) { (_) in
            self.alertViewController?.dismiss(animated: true, completion: nil)
            
            // Send selected option from picker view
            selectedActionPressed(self.datePicker?.date ?? nil)
        }
        
        alertViewController.addAction(selectAction)
        
        if self.datePicker == nil {
            self.datePicker = UIDatePicker()
            self.datePicker?.datePickerMode = .dateAndTime
        }
        
        // add picker view to alertViewControllers content view
        alertViewController.alertViewContentView = self.datePicker
        
        // show the alert
        self.displayAlert(alertController: alertViewController)
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
        
        // Whoops, if there's already a presented view controller this won't work
        // In that case, it's necessary to present on the presented controller (which can define itself as the 'presentation context', which allows nested modal presentation
        if let presented = rootViewController?.presentedViewController {
            rootViewController = presented
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

