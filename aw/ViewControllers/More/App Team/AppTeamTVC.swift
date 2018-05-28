import CoreData
import UIKit

class AppTeamTVC: UITableViewController {
    let teamMembers = [
        [
            "image": "profileAK",
            "name": "Alex Kerney",
            "title": "Software Engineer",
            "email": "Abk@mac.com"
        ],
        [
            "image": "profileRJ",
            "name": "Rachel Jin",
            "title": "Product Designer",
            "email": "girlracheljin@gmail.com"
        ],
        [
            "image": "profileGL",
            "name": "Gregory Lee",
            "title": "Project Lead/Engineer",
            "email": "greg@americanwhitewater.org"
        ],
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "teamMember",
                for: indexPath) as? TeamMemberTableViewCell else {
                    fatalError("Failed to dequeue donate cell")
            }
            
            let teamMember = teamMembers[indexPath.row]
            
            cell.setProfilePhoto(image: UIImage(named: teamMember["image"]!)!)
            cell.setName(name: teamMember["name"]!)
            cell.setTitle(title: teamMember["title"]!)
            cell.setEmail(email: teamMember["email"]!)
            
            return cell
            
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let email = teamMembers[indexPath.row]["email"]!
            openUrl(url: "mailto://" + email)
        }
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
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
