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
    var alertsList = [Alert]()
    
    @IBOutlet weak var riverTitleLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAlertButton: UIButton!
    private let refreshControl = UIRefreshControl()
    private var outDateFormatter = DateFormatter(dateFormat: "MMM d, yyyy")
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the river title and label
        riverTitleLabel.text = selectedRun?.name ?? "Unknown River"
        riverSectionLabel.text = selectedRun?.section ?? "Unknown Section"
        
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
                
        API.shared.getAlerts(reachId: Int(selectedRun.id), page: 1, pageSize: 50) { (alertResults, error) in
            defer { self.refreshControl.endRefreshing() }
            
            guard
                let alertResults = alertResults,
                error == nil
            else {
                print("Alert GraphQL Error: \(String(describing: error))")
                self.tableView.reloadData()
                return
            }
            
            print("Alert Results count: \(alertResults.count)")
            
            // if the server is returning less alerts than we have we
            // display the alerts we already have (likely slow server response to add)
            if alertResults.count < self.alertsList.count {
                return
            }
            
            self.alertsList = alertResults
                .sorted {
                    guard let a = $0.date, let b = $1.date else {
                        return false
                    }
                    return a > b
                }
                
//            self.convertAlertsResponse(alertResults: alertResults)
            self.saveAlerts()
        
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
        guard
            let selectedRun = selectedRun,
            selectedRun.id != 0
        else {
            return
        }
        
        let alertsDicts = alertsList.map { $0.dictionary }
        DefaultsManager.shared.reachAlerts["\(selectedRun.id)"] = alertsDicts
    }
    
    // FIXME: do not keep this in UserDefaults, it may become quite large
    func loadAlerts() {
        if
            let selectedRun = selectedRun,
            selectedRun.id != 0,
            let reachAlerts = DefaultsManager.shared.reachAlerts["\(selectedRun.id)"],
            reachAlerts.count > 0
        {
            alertsList = reachAlerts.map { Alert(dict: $0) }
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
        if let message = alert.message {
            if message.count > 1 {
                cell.alertMessageLabel.set(html: message)
            }
        }
        
        if let user = alert.poster, !user.isEmpty {
            cell.alertPosterLabel.text = "by \(user)"
        } else {
            cell.alertPosterLabel.text = ""
        }
        
        cell.alertDateTimeLabel.text = ""
        if let date = alert.date {
            cell.alertDateTimeLabel.text = outDateFormatter.string(from: date)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
