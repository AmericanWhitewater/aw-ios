import CoreData
import UIKit

class AppTeamTVC: UITableViewController {
    
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
            
            switch indexPath.row {
            case 0:
                cell.setProfilePhoto(image: UIImage(named: "profileAK")!)
                cell.setName(name: "Alex Kerney")
                cell.setTitle(title: "Software Engineer")
                cell.setEmail(email: "Abk@mac.com")
                return cell
                
            case 1:
                cell.setProfilePhoto(image: UIImage(named: "profileRJ")!)
                cell.setName(name: "Rachel Jin")
                cell.setTitle(title: "Product Designer")
                cell.setEmail(email: "girlracheljin@gmail.com")
                return cell
                
            case 2:
                cell.setProfilePhoto(image: UIImage(named: "profileGL")!)
                cell.setName(name: "Gregory Lee")
                cell.setTitle(title: "Project Lead/Engineer")
                cell.setEmail(email: "greg@americanwhitewater.org")
                return cell
            
            default:
                fatalError("Incorrect index path")
            }
            
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath)
        }
    }
}
