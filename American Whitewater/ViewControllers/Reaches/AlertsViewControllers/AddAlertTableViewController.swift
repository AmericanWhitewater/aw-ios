import UIKit

class AddAlertTableViewController: UITableViewController {

    var selectedRun: Reach?
    
    @IBOutlet weak var riverTitleLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var alertTextViewContainer: UIView!
    @IBOutlet weak var alertTextViewBacking: UIView!
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var dateFormatter = DateFormatter()
    
    let PLACEHOLDER_ALERT: String = "e.g. behold the tree in the creek..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertTextViewContainer.layer.cornerRadius = 15
        alertTextViewBacking.layer.cornerRadius = alertTextViewContainer.layer.cornerRadius
        alertTextView.delegate = self
        alertTextView?.text = PLACEHOLDER_ALERT
        
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
        
        if let selectedRun = selectedRun {
            riverTitleLabel.text = selectedRun.title
            riverSectionLabel.text = selectedRun.section
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        alertTextView.resignFirstResponder()
        
        if alertTextView.text == PLACEHOLDER_ALERT || alertTextView.text.count == 0 {
            DuffekDialog.shared.showOkDialog(title: "Invalid Alert", message: "Please enter a detailed description of the alert before pressing submit.")
            return
        }
        
        // post the alert with GraphQL
        guard let selectedRun = self.selectedRun else { return }
                
        AWProgressModal.shared.show(fromViewController: self, message: "Saving...")
        
        let dateString = dateFormatter.string(from: Date())
        print("Date using: \(dateString)")
        print("Selected Run Id: \(Int(selectedRun.id))")

        AWGQLApiHelper.shared.postAlertFor(reach_id: Int(selectedRun.id), message: alertTextView.text, callback: { (postUpdate) in
            print("Success - PostUpdate: \(postUpdate?.id ?? "no detail") -reach_id: \(postUpdate?.reachId ?? "no reach id")")

            AWProgressModal.shared.hide()
            
            // convert postUpdate response to alert object
            var newAlert = [String:String]()
            newAlert["postDate"] = postUpdate?.postDate ?? ""
            newAlert["message"] = postUpdate?.detail ?? ""
            newAlert["poster"] = postUpdate?.user?.uname ?? ""

            // save the alert to local storage in case GQL is slow
            // this gets loaded first in the AlertsView while GQL call
            // happens in background
            var storedAlerts = DefaultsManager.reachAlerts
            print("Total Stored Alerts:", storedAlerts.count)
            if var reachAlerts = storedAlerts["\(selectedRun.id)"] {
                reachAlerts.insert(newAlert, at: 0)
                storedAlerts["\(selectedRun.id)"] = reachAlerts
                DefaultsManager.reachAlerts = storedAlerts
            } else {
                // no alerts have been stored for this group yet
                var alertsList = [ [String: String] ]()
                alertsList.append(newAlert)
                storedAlerts["\(selectedRun.id)"] = alertsList
                DefaultsManager.reachAlerts = storedAlerts
            }
            
            self.successAndDismissView()
            
        }) { (error, message) in
            AWProgressModal.shared.hideWith {
                let errorMessage = GQLError.handleGQLError(error: error, altMessage: message)
                print("Error:", errorMessage)
                DuffekDialog.shared.showOkDialog(title: "Connection Issue", message: "We were unable to connect to the server due to: \(errorMessage)")
            }
        }
    }

    
    func successAndDismissView() {
        DuffekDialog.shared.showOkDialog(title: "Alert Posted", message: "Your alert has been added. Thank you for providing valuable information to the river community.\n\nRiver Karma Granted!") {
            //self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension AddAlertTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PLACEHOLDER_ALERT {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = PLACEHOLDER_ALERT
            textView.textColor = UIColor.lightGray
        }
    }
}

