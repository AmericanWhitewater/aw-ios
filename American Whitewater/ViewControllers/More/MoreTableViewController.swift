import UIKit
import WebKit
import StoreKit
import MessageUI
import KeychainSwift
import SafariServices

class MoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var lastUpdatedAndVersionLabel: UILabel!
    @IBOutlet weak var signInOutLabel: UILabel!
    @IBOutlet weak var signInOutCell: UITableViewCell!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        lastUpdatedAndVersionLabel.text = "App Version: \(appVersion ?? "n/a") (\(appBuild))"
                
        signInOutCell.imageView?.image = UIImage(named: "aboutSignIn")
        
        if DefaultsManager.shared.signedInAuth == nil {
            signInOutLabel?.text = "Sign In"
        } else {
            signInOutLabel?.text = "Sign Out"
        }
    }
    
    func showLoginScreen() {
        if let modalSignInVC = self.storyboard?.instantiateViewController(withIdentifier: "ModalOnboardLogin") as? SignInViewController {
            modalSignInVC.modalPresentationStyle = .overCurrentContext
            tabBarController?.present(modalSignInVC, animated: true, completion: nil)
        }
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        // handle app rating selection
        if indexPath.row == 2 {
            
            // APP REVIEW (Forced display)
            let productURL = URL(string: "https://itunes.apple.com/app/id1400432533")!

            var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [ URLQueryItem(name: "action", value: "write-review") ]
            guard let writeReviewURL = components?.url else { return }

            UIApplication.shared.open(writeReviewURL)
            
        } else if indexPath.row == 3 {
            
            // FEEDBACK - via email
    
            // AWTODO: is this still the right email to use?
            let toAddress = "evan@americanwhitewater.org"
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([toAddress])
                mail.setMessageBody("<p>Here is some feedback for the AW iOS App:</p><br/>", isHTML: true)

                present(mail, animated: true)
            
            } else {
                let alert = UIAlertController(
                    title: "Feedback Issue",
                    message: "Please email your feedback to \(toAddress)",
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true)
            }
        } else if indexPath.row == 4 {
            
            // DONATE BUTTON PRESSED
            UIApplication.shared.open(URL(string:"https://www.americanwhitewater.org/content/Membership/donate")!)
            
        } else if indexPath.row == 5 {
            
            if signInOutLabel?.text == "Sign In" {
                print("Clicked show login screen")
                self.showLoginScreen()
            } else {
                // Sign out button pressed
                let keychain = KeychainSwift()
                if keychain.get(AWGC.AuthKeychainToken) != nil {
                    keychain.delete(AWGC.AuthKeychainToken)
                }

                HTTPCookieStorage.shared.removeCookies(since: Date(timeIntervalSince1970: 0))
                
                // clear cookies
                let dataTypes = Set([WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage,
                                     WKWebsiteDataTypeWebSQLDatabases, WKWebsiteDataTypeIndexedDBDatabases])
                WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: NSDate.distantPast, completionHandler: {})
                
                // load safari logout page
                let config = SFSafariViewController.Configuration()
                let vc = SFSafariViewController(url: URL(string: AWGC.AW_BASE_URL + "/logout")!, configuration: config)
                present(vc, animated: true)
                
                DefaultsManager.shared.signedInAuth = nil
                signInOutLabel?.text = "Sign In"
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        switch result {
            case .sent:
                self.showToast(message: "Thanks for your feedback!")
            case .failed:
                self.showToast(message: "We were unable to send the message. Please check your connection and try again.")
            default:
                break
        }
    }
}
