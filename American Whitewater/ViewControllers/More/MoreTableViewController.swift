//
//  MoreTableViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 9/26/19.
//  Copyright © 2019 American Whitewater. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class MoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var lastUpdatedAndVersionLabel: UILabel!
    @IBOutlet weak var autoRefreshSwitch: UISwitch!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        lastUpdatedAndVersionLabel.text = "App Version: \(appVersion ?? "n/a")"
        
        if DefaultsManager.shouldAutoRefresh == true {
            autoRefreshSwitch.setOn(true, animated: false)
        } else {
            autoRefreshSwitch.setOn(false, animated: false)
        }
    }
    
    @IBAction func autoRefreshChanged(_ refreshSwitch: UISwitch) {
        DefaultsManager.shouldAutoRefresh = refreshSwitch.isOn
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
            if MFMailComposeViewController.canSendMail() {
                    
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["evan@americanwhitewater.org"])
                mail.setMessageBody("<p>Here is some feedback for the AW iOS App:</p><br/>", isHTML: true)

                present(mail, animated: true)
            
            } else {
               // show failure alert
                DuffekDialog.shared.showOkDialog(title: "Feedback Issue ", message: "Please setup a valid email account before attempting to contact us.")
            }
        } else if indexPath.row == 4 {
            
            // DONATE BUTTON PRESSED
            UIApplication.shared.open(URL(string:"https://www.americanwhitewater.org/content/Membership/donate")!)
            
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        switch result {
            case .sent:
                DuffekDialog.shared.showOkDialog(title: "Success", message: "Thanks for your feedback!")
            case .failed:
                DuffekDialog.shared.showOkDialog(title: "Sending Failed", message: "We were unable to send the message. Please check your connection and try again.")
            default:
                break
        }
    }
}
