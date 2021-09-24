import UIKit
import SwiftyJSON

class RunRapidDetailsTableViewController: UITableViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rapidNameLabel: UILabel!
    @IBOutlet weak var rapidDescriptionLabel: UILabel!
    @IBOutlet weak var rapidClassLabel: UILabel!
    @IBOutlet weak var rapidPlaySpotLabel: UILabel!
    @IBOutlet weak var readAllButton: UIButton!
    
    
    var selectedRapid: Rapid?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
        
        readAllButton.layer.cornerRadius = readAllButton.frame.height/2
        readAllButton.clipsToBounds = true
        
        if let selectedRapid = selectedRapid {
            rapidNameLabel?.text = selectedRapid.name ?? "Unnamed Rapid"
            rapidClassLabel?.text = selectedRapid.classRating ?? "N/A"
            rapidPlaySpotLabel?.text = selectedRapid.isPlaySpot ? "Yes" : "No"
            
            if let description = selectedRapid.description, !description.isEmpty {
                rapidDescriptionLabel.text = stripHTML(string: selectedRapid.description!)
            } else {
                rapidDescriptionLabel.text = "No Description Available"
                readAllButton.isHidden = true
            }
            
            if let url = selectedRapid.photoUrl {
                imageView.load(url: url)
            } else {
                imageView.isHidden = true
            }
        }
        
        self.tableView.reloadData()
    }

    @IBAction func readAllButtonPressed(_ sender: Any) {
        rapidDescriptionLabel.numberOfLines = 0
        readAllButton.isHidden = true
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    private func stripHTML(string: String?) -> String {
        if let string = string {
            
            var strippedString = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            if let removedEncodingString = strippedString.removingPercentEncoding {
                strippedString = removedEncodingString
            }
            strippedString = strippedString.replacingOccurrences(of: "&nbsp;", with: "")
            strippedString = strippedString.replacingOccurrences(of: "&#39;", with: "")

            return strippedString
        } else {
            return ""
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        

    }

}
