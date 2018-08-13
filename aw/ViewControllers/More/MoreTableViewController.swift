import UIKit

class MoreTableViewController: UITableViewController {
    @IBOutlet weak var version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.version.apply(style: FontStyle.Text2)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.version.text = "v \(version)"
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 2, section: 0): // Rate this App
            let appID = "" //TODO
            
            // Open App Review Tab
            openUrl(url: "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)")
            
            break
        case IndexPath(row: 3, section: 0): // Feedback
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                openUrl(url: "mailto://greg@americanwhitewater.org?body=%0A%0AiOS%20v%20\(version)")
            } else {
                openUrl(url: "mailto://greg@americanwhitewater.org")
            }
            
            break
        case IndexPath(row: 4, section: 0): // Donate
            UIApplication.shared.open(
                    URL(string: "https://www.americanwhitewater.org/content/Membership/donate")!,
                    options: [:]) { (status) in
                if status {
                    print("Opened browser to donate page")
                }
            }
        default:
            break
        }
    }
    
    func openUrl(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
