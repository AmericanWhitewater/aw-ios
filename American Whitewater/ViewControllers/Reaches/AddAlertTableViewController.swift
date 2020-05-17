import UIKit

class AddAlertTableViewController: UITableViewController {

    var selectedRun: Reach?
    
    @IBOutlet weak var riverTitleLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var dateFormatter = DateFormatter()
    
    let PLACEHOLDER_ALERT: String = "e.g. behold the tree in the creek..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertTextView.layer.cornerRadius = 15
        alertTextView.layer.borderColor = UIColor.lightGray.cgColor
        alertTextView.layer.borderWidth = 1
        alertTextView.delegate = self
        alertTextView?.text = PLACEHOLDER_ALERT
        
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
        
        if let selectedRun = selectedRun {
            riverTitleLabel.text = selectedRun.title
            riverSectionLabel.text = selectedRun.section
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        alertTextView.resignFirstResponder()
        
        if alertTextView.text == PLACEHOLDER_ALERT || alertTextView.text.count == 0 {
            DuffekDialog.shared.showOkDialog(title: "Invalid Alert", message: "Please enter a detailed description of the alert before pressing submit.")
            return
        }
        
        // post the alert with GraphQL
        guard let selectedRun = self.selectedRun else { return }
        
        AWProgress.shared.show()
        
        let dateString = dateFormatter.string(from: Date())
        print("Date using: \(dateString)")
        print("Selected Run Id: \(Int(selectedRun.id))")
        
        AWGQLApiHelper.shared.postAlertFor(reach_id: Int(selectedRun.id), message: alertTextView.text, callback: { (postUpdate) in
            print("Success - PostUpdate: \(postUpdate?.id ?? "no detail") -reach_id: \(postUpdate?.reachId ?? "no reach id")")
            AWProgress.shared.hide();
            self.successAndDismissView()
        }) { (error) in
            print("Error:", error.localizedDescription)
        }
    }

    func successAndDismissView() {
        DuffekDialog.shared.showOkDialog(title: "Alert Posted", message: "Your alert has been added. Thank you for providing valuable information to the river community.\nRiver karma granted!") {
            //self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
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

