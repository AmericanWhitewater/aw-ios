import UIKit
import CoreData

class RunDetailTableViewController: UITableViewController {

    var selectedRun:Reach?
    
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Reach>?
    
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var runLevelLabel: UILabel!
    @IBOutlet weak var runUnitsLabel: UILabel!
    @IBOutlet weak var runGaugeDeltaLabel: UILabel!
    
    @IBOutlet weak var runSectionInfoLabel: UILabel!
    @IBOutlet weak var runDetailInfoLabel: UILabel!
    
    @IBOutlet weak var runClassLabel: UILabel!
    @IBOutlet weak var runLengthLabel: UILabel!
    @IBOutlet weak var runGradientLabel: UILabel!
    
    @IBOutlet weak var viewSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var readAllButton: UIButton!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
        
        let selectedSegTitle = [NSAttributedString.Key.foregroundColor: UIColor(named: "primary") ?? UIColor.black]
                                as [NSAttributedString.Key : Any]
        viewSegmentControl.setTitleTextAttributes(selectedSegTitle, for: .selected)

        
        readAllButton.layer.cornerRadius = readAllButton.frame.height/2
        readAllButton.clipsToBounds = true
        
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm:ss a"
        
        runNameLabel.text = selectedRun?.name ?? "Unknown"
        runSectionLabel.text = selectedRun?.section ?? ""
        lastUpdateLabel.text = dateFormatter.string(from: Date())
        
        runLevelLabel.text = selectedRun?.currentGageReading ?? "n/a"
        runUnitsLabel.text = selectedRun?.unit ?? ""
        runGaugeDeltaLabel.text = selectedRun?.delta ?? ""
        
        runClassLabel.text = selectedRun?.difficulty ?? "n/a"
        runLengthLabel.text = "n/a" //selectedRun. how do we get this?
        runGradientLabel.text = "n/a" // need to find this one too
        
        if let cond = selectedRun?.condition {
            if cond == "low" {
                runLevelLabel.textColor = UIColor.AW.Low
                runGaugeDeltaLabel.textColor = UIColor.AW.Low
            } else if cond == "med" {
                runLevelLabel.textColor = UIColor.AW.Med
                runGaugeDeltaLabel.textColor = UIColor.AW.Med
            } else if cond == "high" {
                runLevelLabel.textColor = UIColor.AW.High
                runGaugeDeltaLabel.textColor = UIColor.AW.High
            } else {
                runLevelLabel.textColor = UIColor.AW.Unknown
                runGaugeDeltaLabel.textColor = UIColor.AW.Unknown
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewSegmentControl.selectedSegmentIndex = 0
        
        if let selectedRun = selectedRun {
            AWApiReachHelper.shared.updateReachDetail(reachId: "\(selectedRun.id)", callback: {
                self.fetchDetailsFromCoreData()
            }) { (error) in
                print("Error: \(error?.localizedDescription ?? "?")")
            }
        }
    }
    
    
    func fetchDetailsFromCoreData() {
        guard let selectedRun = self.selectedRun else { return }
        
        let request = Reach.fetchRequest() as NSFetchRequest<Reach>
        request.predicate = NSPredicate(format: "id == %i", selectedRun.id)
        
        guard let result = try? managedObjectContext.fetch(request), let fetchedReach = result.first else {
            print("Unable to find matching details in db")
            return
        }
        
        self.runLengthLabel.text = fetchedReach.length ?? "n/a"
        self.runGradientLabel.text = fetchedReach.avgGradient == 0 ? "\(fetchedReach.avgGradient) fpm" : "n/a fpm"
        if let details = fetchedReach.longDescription {
            var cleanedDetails = stripHTML(string: details)
            if cleanedDetails.count == 0 {
                cleanedDetails = "No additional details available"
            }
            
            runDetailInfoLabel.text = cleanedDetails
        }
    
        self.tableView.reloadData()
    }
    
    
    private func stripHTML(string: String?) -> String {
        if let string = string {
            
            var strippedString = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            if let removedEncodingString = strippedString.removingPercentEncoding {
                strippedString = removedEncodingString
            }
            strippedString = strippedString.replacingOccurrences(of: "&nbsp;", with: "")
            strippedString = strippedString.replacingOccurrences(of: "&#39;", with: "")
            strippedString = strippedString.replacingOccurrences(of: "&quot;", with: "\"")
            strippedString = strippedString.trimmingCharacters(in: .whitespaces)
            
            //^[\r\n\t ]|[\r\n\t ]*$ -- no idea why not working doing ugly hack instead
            //strippedString = strippedString.replacingOccurrences(of: "^[\r\n\t ]*|[\r\n\t ]*$", with: "", options: .regularExpression)
            //print(strippedString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
            let urlEncoded = strippedString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? strippedString
            strippedString = urlEncoded.replacingOccurrences(of: "%09", with: "")
            strippedString = strippedString.removingPercentEncoding ?? strippedString
            
            return strippedString
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    /*
     This is a static table view but we're still using didSelectAt to handle when the user
     selects 'See Gage Info', 'Go to Website', and 'Share'
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 3 {
            
            // check what option the user selected
            if indexPath.row == 0 {
                // Handle 'See Gauge Info'
                if let selectedRun = selectedRun {
                    self.performSegue(withIdentifier: Segue.gaugeDetail.rawValue, sender: selectedRun)
                }
            } else if indexPath.row == 1 {
                
                // Handle go to website view
                guard let run = selectedRun,
                      let url = URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\(run.id)/") else { return }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else if indexPath.row == 2 {
                // Handle share button pressed
                shareButtonPressed()
            }
        }
    }

    @IBAction func shareButtonPressed() {
        guard let run = selectedRun else { return }
        let shareLink = "https://www.americanwhitewater.org/content/River/detail/id/\(run.id)/"
        
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @IBAction func readAllButtonPressed(_ sender: Any) {
        
        runDetailInfoLabel.numberOfLines = 0
        readAllButton.isHidden = true
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func detailViewSegmentChanged(_ segmentControl: UISegmentedControl) {
        
        if let selectedRun = selectedRun {
            performSegue(withIdentifier: Segue.reachMapEmbed.rawValue, sender: selectedRun)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let selectedRun = sender as? Reach {
            if segue.identifier == Segue.gaugeDetail.rawValue {
                let gaugeVC = segue.destination as? GaugeDetailViewController
                gaugeVC?.selectedRun = selectedRun
                
            } else if segue.identifier == Segue.reachMapEmbed.rawValue {
                let mapVC = segue.destination as? RunMapViewController
                mapVC?.selectedRun = selectedRun
            }
        }

    }
    

}
