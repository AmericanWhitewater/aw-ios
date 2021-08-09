//
//  RunAlertsViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 4/22/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit
import KeychainSwift

class RunAlertsViewController: UIViewController {

    var selectedRun: Reach?
    var alertsList = [ [String: String] ]()
    //var alertsList = [AlertsQuery.Data.Post.Datum]()
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
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        outDateFormatter.dateFormat = "MMM d, yyyy"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        // setup pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshAlerts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        addAlertButton.layer.cornerRadius = addAlertButton.bounds.height/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // if locally saved alerts exist load and display
        print("alertsList Count: ", alertsList.count)
        print("Loading Alerts")
        loadAlerts()

        refreshControl.tintColor = UIColor(named: "primary")
        
        // load alerts from server
        refreshControl.beginRefreshingManually()
        refreshAlerts()
    }
    
    @objc func refreshAlerts() {
        print("Refreshing Alerts...")
        
        guard let selectedRun = selectedRun else { refreshControl.endRefreshing(); return }
        print(selectedRun.id)
                
        API.shared.getAlerts(reachId: Int(selectedRun.id), page: 1, pageSize: 50, callback: { (alertResults) in
            self.refreshControl.endRefreshing()
            
            if let alertResults = alertResults {
                print("Alert Results count: \(alertResults.count)")
                // if the server is returning less alerts than we have we
                // display the alerts we already have (likely slow server response to add)
                if alertResults.count < self.alertsList.count { return; }
                
                self.alertsList.removeAll()
                self.convertAlertsResponse(alertResults: alertResults)
                self.saveAlerts()
            } else {
                print("No alerts returned")
            }

            self.tableView.reloadData()
        }) { (error) in
            print("Alert GraphQL Error: \(error)")
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    
    
    @IBAction func addAlertPressed(_ sender: Any) {
        
        let keychain = KeychainSwift();
        if keychain.get(AWGC.AuthKeychainToken) == nil || DefaultsManager.shared.signedInAuth == nil {
            self.showLoginScreen()
        } else {
            self.performSegue(withIdentifier: Segue.postAlertSeg.rawValue, sender: nil)
        }        
    }
    
    func showLoginScreen() {
        // AWTODO: why not present on self?
        tabBarController?.present(SignInViewController.fromStoryboard(), animated: true, completion: nil)
    }
    
    
    func saveAlerts() {
        var storedAlerts = DefaultsManager.shared.reachAlerts
        
        if let selectedRun = selectedRun, selectedRun.id != 0 {
            storedAlerts["\(selectedRun.id)"] = alertsList
            DefaultsManager.shared.reachAlerts = storedAlerts
        }
    }
    
    func loadAlerts() {
        if let selectedRun = selectedRun, selectedRun.id != 0 {
            let storedAlerts = DefaultsManager.shared.reachAlerts
            if let reachAlerts = storedAlerts["\(selectedRun.id)"], reachAlerts.count > 0 {
                alertsList.removeAll()
                alertsList = reachAlerts
                tableView.reloadData()
            }
        }
    }
    
    func convertAlertsResponse(alertResults: [AlertsQuery.Data.Post.Datum]) {
        if alertResults.count > 0 {
            alertsList.removeAll()
            
            for alert in alertResults {
                //print("Alert: \(alert.postDate ?? "na") - \(alert.detail ?? "na") - \(alert.user?.uname ?? "")")
                
                var newAlert = [String:String]()
                newAlert["postDate"] = alert.postDate ?? ""
                newAlert["message"] = alert.detail ?? ""
                newAlert["poster"] = alert.user?.uname ?? ""
                alertsList.append(newAlert)
            }
            
            // sort the alerts list by postDate
            alertsList = alertsList.sorted(by: { (first, second) -> Bool in
                let firstDateString = first["postDate"] ?? ""
                let secondDateString = second["postDate"] ?? ""
                
                if let date1 = inputDateFormatter.date(from: firstDateString),
                    let date2 = inputDateFormatter.date(from: secondDateString) {
                    return date1 > date2
                }
                
                return false
            })
                        
            tableView.reloadData()
        }
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
        return alertsList.count == 0 ? 1 : alertsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        // load a loading cell or a no alerts available cell
        if self.alertsList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noAlertCell", for: indexPath)
            return cell
        }
        
        // load the alert view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! AlertTableViewCell
        
        let alert = self.alertsList[indexPath.row]
        
        cell.alertMessageLabel.set(html: "<h3>No details provided</h3>")
        if let detail = alert["message"] {
            if detail.count > 1 {
                cell.alertMessageLabel.set(html: detail)
            }
        }
        
        cell.alertPosterLabel.text = ""
        if let user = alert["poster"] {
            cell.alertPosterLabel.text = user.count > 0 ? "by \(user)" : ""
        }
        
        cell.alertDateTimeLabel.text = ""
        if let dateString = alert["postDate"] {
            if let date = inputDateFormatter.date(from: dateString) { //yyyy-MM-dd hh:mm:ss
                let outString = outDateFormatter.string(from: date)
                cell.alertDateTimeLabel.text = outString
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
