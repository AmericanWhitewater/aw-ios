import UIKit

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
            let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)" // Open App Review Tab
            
            
            if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
            break
        case IndexPath(row: 3, section: 0): // Feedback
            if let url = URL(string: "mailto://greg@americanwhitewater.org") {
                UIApplication.shared.open(url)
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
}
