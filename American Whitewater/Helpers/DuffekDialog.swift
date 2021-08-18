import Foundation
import NYAlertViewController
import Contacts

class DuffekDialog {
    
    static let shared = DuffekDialog()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    var alertViewController: NYAlertViewController?
    private var datePicker: UIDatePicker?
    
    static func pickerDialog(
        pickerDataSource:UIPickerViewDataSource,
        pickerDelegate: UIPickerViewDelegate,
        initialSelection: (Int, Int) = (0, 0), // initial (row, component) to select
        title: String,
        message: String,
        selectedActionPressed: @escaping ()->Void = {}
    ) -> NYAlertViewController {
        let alertViewController = styledAlert()
        
        alertViewController.title = title
        alertViewController.message = "\n\(message)\n"
        
        let selectAction = NYAlertAction(title: "Select", style: .default) { (_) in
            alertViewController.dismiss(animated: true, completion: nil)
            
            // Send selected option from picker view
            selectedActionPressed()
        }
        
        alertViewController.addAction(selectAction)
        
        let picker = UIPickerView()
        picker.dataSource = pickerDataSource
        picker.delegate = pickerDelegate
        picker.selectRow(initialSelection.0, inComponent: initialSelection.1, animated: false)
        
        // add picker view to alertViewControllers content view
        alertViewController.alertViewContentView = picker
        
        return alertViewController
    }
    
    
    static func datePickerDialog(
        title: String,
        message: String,
        initialDate: Date? = nil,
        selectedActionPressed: @escaping (Date) -> Void
    ) -> NYAlertViewController {
        let alertViewController = styledAlert()
        alertViewController.title = title
        alertViewController.message = "\n\(message)\n"
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        
        if let initialDate = initialDate {
            datePicker.setDate(initialDate, animated: false)
        }
        
        let selectAction = NYAlertAction(title: "Select", style: .default) { (_) in
            alertViewController.dismiss(animated: true, completion: nil)
            
            // Send selected option from picker view
            selectedActionPressed(datePicker.date)
        }
        
        alertViewController.addAction(selectAction)
        
        // add picker view to alertViewControllers content view
        alertViewController.alertViewContentView = datePicker
        
        return alertViewController
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
    private static func styledAlert() -> NYAlertViewController {
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

