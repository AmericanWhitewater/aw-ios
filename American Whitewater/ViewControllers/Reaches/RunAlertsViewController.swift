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
    
    @IBOutlet weak var riverTitleLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var inputDateFormatter = DateFormatter()
    var outDateFormatter = DateFormatter()
    
    @IBOutlet weak var addAlertButton: UIButton!
        
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
        
        self.refreshAlerts()
    }
    
    @objc func refreshAlerts() {
        print("Refreshing Alerts...")
        
        guard let selectedRun = selectedRun else { refreshControl.endRefreshing(); return }
        print(selectedRun.id)
        
        AWGQLApiHelper.shared.getAlertsForReach(reach_id: Int(selectedRun.id), page: 1, page_size: 50, callback: { (alertResults) in
             
            if let alertResults = alertResults {
                print("Alert Results count: \(alertResults.count)")
                self.alertsList.removeAll()
                self.alertsList = alertResults
            } else {
                print("No alerts returned")
            }
        }) { (error) in
            print("Alert GraphQL Error: \(error.localizedDescription)")
        }
        
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


    }
}

extension RunAlertsViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alertsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
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
