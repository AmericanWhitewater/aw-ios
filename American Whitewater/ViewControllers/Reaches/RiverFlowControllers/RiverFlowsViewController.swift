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
    var riverFlows = [GaugeObservation]()
    var availableMetrics = [String:String]()

    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 110
        
        refreshControl.addTarget(self, action: #selector(refreshFlows), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mma"
        
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
            API.shared.getMetrics(gaugeId: Int(guageId), metricsCallback: { reachGageMetrics in
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
        guard let selectedRun = self.selectedRun else { return }
                
        API.shared.getGaugeObservations(reachId: selectedRun.id, page: 0, pageSize: 100) { (flows, error) in
            defer { self.refreshControl.endRefreshing() }
            
            guard
                let flows = flows,
                error == nil
            else {
                print("Error with observations list gql:", error)
                return
            }
            
            self.riverFlows = Dictionary(grouping: flows, by: \.id)
                .values
                .compactMap(\.first)
                .sorted {
                    guard let a = $0.date, let b = $1.date else {
                        return false
                    }
                    return a > b
                }
            
            self.tableView.reloadData()
        }
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
        
        let flow = riverFlows[indexPath.row]

        // FIXME: this was trying to use different cell types, but RiverFlowNoPicCell doesn't exist and the as! below would crash
//        let cellType = flow.photos.isEmpty ? "RiverFlowNoPicCell" : "RiverFlowCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiverFlowCell", for: indexPath) as! RiverFlowCell
        
        if let url = flow.photos.first?.mediumURL {
            cell.postedImageView.load(url: url)
        }

        cell.postedTitleLabel.text = flow.title
        
        // FIXME: see https://github.com/AmericanWhitewater/aw-ios/issues/223
//        cell.reportedVisualLabel.text = flow["observed"] ?? "no visual reported"
        
        if let reading = flow.reading {
            cell.reportedGaugeValueLabel.text = "\(reading)"
        } else {
            cell.reportedGaugeValueLabel.text = "n/a"
        }
        cell.postedByLabel.text = "Posted By: \(flow.author ?? "n/a")"
        
        if let date = flow.date {
            cell.postedDateLabel.text = "Posted: \(dateFormatter.string(from: date))"
        } else {
            cell.postedDateLabel.text = "Posted: n/a"
        }
        
        cell.expandImageButton?.tag = indexPath.row
        cell.expandImageButton?.addTarget(self, action: #selector(expandButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func expandButtonPressed(_ sender: UIButton) {
        print("Button pressed, tag:", sender.tag)
        let flow = riverFlows[sender.tag]
        
        if let url = flow.photos.first?.mediumURL {
            let config = SFSafariViewController.Configuration()
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        } else {
            let errorTitle = "Image Issue"
            let errorMessage = "Unfortunately this image has an issue that is preventing us from displaying it in a larger view. Please contact us to correct this issue."
            
            self.showToast(message: errorTitle + " " + errorMessage)
            print("imagePath issue: ", flow)
        }
    }
}
