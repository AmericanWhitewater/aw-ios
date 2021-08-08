import UIKit
import SafariServices

class RiverFlowsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var riverNameLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var riverLevelLabel: UILabel!
    @IBOutlet weak var riverUnitsLabel: UILabel!
    @IBOutlet weak var riverGaugeDeltaLabel: UILabel!
    @IBOutlet weak var reportAFlowButton: UIButton!
    let refreshControl = UIRefreshControl()
    
    var selectedRun:Reach?
    var riverFlows = [[String:String?]]()
    var availableMetrics = [String:String]()

    var dateFormatter = DateFormatter()
    var isoDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 110
        
        refreshControl.addTarget(self, action: #selector(refreshFlows), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mma"
        isoDateFormatter.dateFormat = "YYYY-MM-DD hh:mm:ss"
        
        reportAFlowButton.layer.cornerRadius = reportAFlowButton.frame.height / 2
        reportAFlowButton.clipsToBounds = true
        
        riverNameLabel.text = selectedRun?.name
        riverSectionLabel.text = selectedRun?.section
        riverLevelLabel.text = selectedRun?.currentGageReading
        riverUnitsLabel.text = selectedRun?.unit
        riverGaugeDeltaLabel.text = selectedRun?.delta
        
        if let color = selectedRun?.runnabilityColor {
            riverLevelLabel.textColor = color
            riverGaugeDeltaLabel.textColor = color
        }
        
        if let guageId = selectedRun?.gageId {
            API.shared.getMetricsForGauge(id: "\(guageId)", metricsCallback: { reachGageMetrics in
                //let keys = Array(availableMetrics.keys)
                self.availableMetrics = reachGageMetrics
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshControl.tintColor = UIColor(named: "primary")
        
        // load alerts from server
        refreshControl.beginRefreshingManually()
        refreshFlows()
    }
    
    @objc func refreshFlows() {
        
        guard let selectedRun = self.selectedRun else { return; }
        
        print("Refreshing flows!")
        let reachId = Int(selectedRun.id)
                
        API.shared.getGaugeObservationsForReach(reach_id: reachId, page: 0, page_size: 100, callback: { (flowResults) in
            print("Total Gauge Observations Returned:", flowResults?.count ?? 0)
            self.refreshControl.endRefreshing()

            if let flowResults = flowResults {
                for result in flowResults {
                    print("Gauge Observation:", result)
                    print("Result Id:", result.id ?? "")
                    let resultId = result.id ?? ""
                    
                    if !self.alreadyHaveFlow(idString: resultId) {
                        var newFlow = [String:String?]()
                        newFlow["id"] = "\(result.id ?? NanoID.new(6))"
                        newFlow["title"] = result.title
                        newFlow["detail"] = result.detail
                        newFlow["reading"] = "\(result.reading ?? 0)"
                        newFlow["metric"] = result.metric?.unit ?? ""
                        newFlow["postDate"] = result.postDate
                        newFlow["author"] = result.user?.uname ?? "Anonymous"
                        //newFlow["observed"] = result.ob
                        
                        // AWTODO: add when observable is added to api
                        
                        let photos = result.photos

                        for photo in photos {
                            if let image = photo.image, let uri = image.uri,
                               let thumb = uri.thumb, let medium = uri.medium, let big = uri.big {
                                newFlow["thumb"] = thumb
                                newFlow["med"] = medium
                                newFlow["big"] = big
                            }
                        }
                        
                        print("New Flow: \(String(describing: newFlow["title"])) -- \(String(describing: newFlow["thumb"]))")
                        self.riverFlows.insert(newFlow, at: 0)
                    }
                }
                
                self.tableView.reloadData()
            }

        }) { (error, message) in
            print("Error with observations list gql:", error ?? "n/a", message ?? "n/a")
        }
        
    }
    
    func alreadyHaveFlow(idString: String) -> Bool {
        for flow in riverFlows {
            let testId = flow["id"] as? String ?? ""
            print("flowID: \(testId) == \(idString)")
            if flow["id"] as? String == idString {
                return true
            }
        }
        return false
    }

    func observedStringValue(value: Double) -> String {
        //let reportingOptions = [ ["Low":-1], ["Low Runnable":0.1], ["Runnable": 0.45], ["High Runnable": 0.8], ["Too High":1.5] ]
        if value < 0.0 {
            return "Low"
        } else if value > 0 && value < 0.33 {
            return "Low Runnable"
        } else if value > 0.33 && value < 0.66 {
            return "Runnable"
        } else if value > 0.66 && value < 1.0 {
            return "High Runnable"
        } else if value > 1.0 {
            return "Too High"
        } else {
            return ""
        }
    }
    
    
    @IBAction func reportAFlowButtonPressed(_ sender: Any) {
        if DefaultsManager.shared.signedInAuth == nil {
            self.showLoginScreen()
        } else {
            self.performSegue(withIdentifier: Segue.addRiverFlowSeg.rawValue, sender: nil)
        }
    }
    
    func showLoginScreen() {
        let modalSignInVC = SignInViewController.fromStoryboard()
        // AWTODO: why not present on self?
        tabBarController?.present(modalSignInVC, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case Segue.addRiverFlowSeg.rawValue:
            return selectedRun != nil
        default:
            return true
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Segue.addRiverFlowSeg.rawValue {
            let addFlowVC = segue.destination as? AddRiverFlowTableViewController
            addFlowVC?.selectedRun = self.selectedRun!
            addFlowVC?.senderVC = self
            addFlowVC?.availableMetrics = self.availableMetrics
        }
        
    }
}

extension RiverFlowsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //return 225
            return UITableView.automaticDimension
        } else {
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return riverFlows.count
        } else {
            return riverFlows.count == 0 ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Display no items cell message
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoRiverFlowCell", for: indexPath)
            return cell
        }

        var cellType = "RiverFlowNoPicCell"

        // show reported visual flow data
        let flow = riverFlows[indexPath.row]
        if let _ = flow["med"] as? String {
            cellType = "RiverFlowCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! RiverFlowCell
        
        if var imageLink = flow["med"] as? String, imageLink.count > 0 {
            imageLink = "\(AWGC.AW_BASE_URL)\(imageLink)"
            cell.postedImageView.load(url: URL(string: imageLink)!)
        }

        cell.postedTitleLabel.text = flow["title"] ?? ""
        cell.reportedVisualLabel.text = flow["observed"] ?? "no visual reported"
        cell.reportedGaugeValueLabel.text = flow["reading"] ?? "n/a"
        cell.postedByLabel.text = "Posted By: \(flow["author"] as? String ?? "n/a")"
        
        var finalDateString = "Posted: n/a"
        if let dateString = flow["postDate"] as? String {
            if let date = isoDateFormatter.date(from: dateString) {
                let fixedDateString = dateFormatter.string(from: date)
                finalDateString = "Posted: \(fixedDateString)"
            }
        }
        cell.postedDateLabel.text = finalDateString
        
        cell.expandImageButton?.tag = indexPath.row
        cell.expandImageButton?.addTarget(self, action: #selector(expandButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func expandButtonPressed(_ sender: UIButton) {
        print("Button pressed, tag:", sender.tag)
        let flow = riverFlows[sender.tag]
        if let imageLink = flow["med"] as? String {
            let errorTitle = "Image Issue"
            let errorMessage = "Unfortunately this image has an issue that is preventing us from displaying it in a larger view. Please contact us to correct this issue."

            let imagePath = "\(AWGC.AW_BASE_URL)\(imageLink)"
            
            if !imagePath.contains("https://") && !imagePath.contains("http://") {
                self.showToast(message: "Connection Error: " + errorMessage)
                print("imagePath issue: ", imagePath)
                return
            }

            if let url = URL(string: imagePath) {
                let config = SFSafariViewController.Configuration()
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            } else {
                self.showToast(message: errorTitle + " " + errorMessage)
                print("imagePath issue: ", imagePath)
            }
        }
    }
}
