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
    
    static let placeholderText: String = "e.g. behold the tree in the creek..."
    
    var alertTextIsValid: Bool {
        !alertTextView.text.isEmpty &&
        alertTextView.text != Self.placeholderText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertTextViewContainer.layer.cornerRadius = 15
        alertTextViewBacking.layer.cornerRadius = alertTextViewContainer.layer.cornerRadius
        alertTextView.delegate = self
        alertTextView?.text = Self.placeholderText
        
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
        updateSubmitButtonEnabled()
        
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
        
        guard
            alertTextIsValid,
            let selectedRun = self.selectedRun
        else {
            return
        }
                
        AWProgressModal.shared.show(fromViewController: self, message: "Saving...")
        
        let dateString = dateFormatter.string(from: Date())
        print("Date using: \(dateString)")
        print("Selected Run Id: \(Int(selectedRun.id))")

        API.shared.postAlert(reachId: Int(selectedRun.id), message: alertTextView.text) { (alert, error) in
            if let error = error {
                switch error {
                case AWGQLApiHelper.Errors.notSignedIn:
                    self.showToast(message: "You must sign in to submit an alert.")
                    self.present(SignInViewController.fromStoryboard(), animated: true, completion: nil)
                default:
                    AWProgressModal.shared.hideWith {
                        print("Error:", error.localizedDescription)
                        self.showToast(message: "Connection error: \(error.localizedDescription)")
                    }
                }
                
                return
            }
            
            guard let alert = alert else { return }
            
            AWProgressModal.shared.hide()
            
            // save the alert to local storage in case GQL is slow
            // this gets loaded first in the AlertsView while GQL call
            // happens in background
            // FIXME: replace, don't use defaults
            let reachAlerts = DefaultsManager.shared.reachAlerts["\(selectedRun.id)"]
            DefaultsManager.shared.reachAlerts["\(selectedRun.id)"] = [alert.dictionary] + (reachAlerts ?? [])
            
            self.successAndDismissView()
        }
    }
    
    func successAndDismissView() {
        self.showToast(message: "Your alert has been added. Thank you for providing valuable information to the river community.\n\nRiver Karma Granted!")
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateSubmitButtonEnabled() {
        submitButton.isEnabled = alertTextIsValid
        // FIXME: button should dim or otherwise visually change when disabled to indicate it's state, lowering opacity is not a great way to do that but it's quick:
        submitButton.alpha = alertTextIsValid ? 1.0 : 0.6
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
        if textView.text == Self.placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSubmitButtonEnabled()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Self.placeholderText
            textView.textColor = .lightGray
        }
    }
}

