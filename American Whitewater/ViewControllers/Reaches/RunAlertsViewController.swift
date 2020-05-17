//
//  RunAlertsViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 4/22/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class RunAlertsViewController: UIViewController {

    var selectedRun: Reach?
    var alertsList = [AlertsQuery.Data.Post.Datum]()
    var loadingAlerts = true
    
    @IBOutlet weak var riverTitleLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAlertButton: UIButton!
    let refreshControl = UIRefreshControl()
    
    var inputDateFormatter = DateFormatter()
    var outDateFormatter = DateFormatter()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the river title and label
        riverTitleLabel.text = selectedRun?.name ?? "Unknown River"
        riverSectionLabel.text = selectedRun?.section ?? "Unknown Section"
        
        // setup dateFormatters for converting graphql date formats
        inputDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        outDateFormatter.dateFormat = "MMM d, yyyy"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        // setup pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshAlerts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        addAlertButton.layer.cornerRadius = addAlertButton.bounds.height/2
        
        // show tableView refresh control while requesting alerts from server
        loadingAlerts = true
        refreshControl.beginRefreshingManually()
    }
    
    @objc func refreshAlerts() {
        print("Refreshing Alerts...")
        
        guard let selectedRun = selectedRun else { refreshControl.endRefreshing(); return }
        print(selectedRun.id)
                
        loadingAlerts = true
        AWGQLApiHelper.shared.getAlertsForReach(reach_id: Int(selectedRun.id), page: 1, page_size: 50, callback: { (alertResults) in
             
            if let alertResults = alertResults {
                print("Alert Results count: \(alertResults.count)")
                self.alertsList.removeAll()
                self.alertsList = alertResults
            } else {
                print("No alerts returned")
            }

            self.loadingAlerts = false
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }) { (error) in
            print("Alert GraphQL Error: \(error.localizedDescription)")
            self.loadingAlerts = false
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addAlertPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.postAlertSeg.rawValue, sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.postAlertSeg.rawValue {
            let addAlertVC = segue.destination as? AddAlertTableViewController
            addAlertVC?.selectedRun = self.selectedRun
        }

    }
}

extension RunAlertsViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.alertsList.count == 0 {
            return 1
        } else {
            return self.alertsList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        // load a loading cell or a no alerts available cell
        if self.alertsList.count == 0 && loadingAlerts {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingAlertCell", for: indexPath)
            return cell
        } else if self.alertsList.count == 0 && !loadingAlerts {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noAlertCell", for: indexPath)
            return cell
        }
        
        // load the alert view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! AlertTableViewCell
        
        let alert = self.alertsList[indexPath.row]
        
        cell.alertMessageLabel.set(html: "<h3>No details provided</h3>")
        if let detail = alert.detail {
            if detail.count > 1 {
                cell.alertMessageLabel.set(html: detail)
            }
        }
        
        cell.alertPosterLabel.text = ""
        if let user = alert.user {
            cell.alertPosterLabel.text = user.uname.count > 0 ? "by \(user.uname)" : ""
        }
        
        cell.alertDateTimeLabel.text = ""
        if let dateString = alert.postDate, let date = inputDateFormatter.date(from: dateString) {
            cell.alertDateTimeLabel.text = outDateFormatter.string(from: date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
