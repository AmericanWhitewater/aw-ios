//
//  RunAlertsViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 4/22/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit
import SafariServices

class RunAccidentsViewController: UIViewController {

    var selectedRun: Reach?
    var accidentsList = [ReachAccidentsQuery.Data.Reach.Accident.Datum]()
    var inputDateFormatter = DateFormatter()
    var outDateFormatter = DateFormatter()
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var riverTitleLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var reportAccidentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the river title and label
        riverTitleLabel.text = selectedRun?.name ?? "Unknown River"
        riverSectionLabel.text = selectedRun?.section ?? "Unknown Section"
        
        reportAccidentButton.layer.cornerRadius = reportAccidentButton.bounds.height / 2
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        // setup pull to refresh
        refreshControl.tintColor = UIColor(named: "primary")
        refreshControl.addTarget(self, action: #selector(refreshAccidents), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // setup dateFormatter
        inputDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        outDateFormatter.dateFormat = "MMM d, yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load alerts from server
        refreshControl.beginRefreshingManually()
        self.refreshAccidents()
    }
    
    @objc func refreshAccidents() {
        print("Refreshing Accidents...")
        
        guard let reach = selectedRun else { print("can't get reach id on accidents list"); return }
        
        AWGQLApiHelper.shared.getAccidentsForReach(reach_id: Int(reach.id), first: 100, page: 1, callback: { (accidentResults) in
            self.accidentsList.removeAll()
            
            // handle server sending back multiple of the same results
            // server issue but needs client side handling for now
            if let accidentResults = accidentResults {
                for item in accidentResults {
                    let accidentIds = self.accidentsList.map { $0.id }
                    if !accidentIds.contains(item.id) {
                        self.accidentsList.append(item)
                    }
                }
                
                // sort the alerts list by postDate
                self.accidentsList = self.accidentsList.sorted(by: { (first, second) -> Bool in
                    let firstDateString = first.accidentDate ?? ""
                    let secondDateString = second.accidentDate ?? ""
                    
                    if let date1 = self.inputDateFormatter.date(from: firstDateString),
                        let date2 = self.inputDateFormatter.date(from: secondDateString) {
                        return date1 > date2
                    }
                    
                    return false
                })
            }
            
            //self.accidentsList = accidentResults
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error, message) in
            self.refreshControl.endRefreshing()
            print("Accidents Query Error: \(GQLError.handleGQLError(error: error, altMessage: message))")
        }
    }
    
    @IBAction func reportAccidentButtonPressed(_ sender: Any) {
        if let url = URL(string: "https://www.americanwhitewater.org/content/Accident/report/") {
            let safariVC = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
            self.present(safariVC, animated: true)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Segue.accidentDetailsSeg.rawValue {
            let detailsVC = segue.destination as? RunAccidentDetailsTableViewController
            detailsVC?.selectedAccident = sender as? ReachAccidentsQuery.Data.Reach.Accident.Datum
        }
    }
}

extension RunAccidentsViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accidentsList.count == 0 ? 1 : accidentsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // no accident reports available
        if accidentsList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noAccidentCell", for: indexPath)
            return cell
        }
        
        // show accident report cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "accidentCell", for: indexPath) as! AccidentTableViewCell
        
        let accident = accidentsList[indexPath.row]
        
        let date = inputDateFormatter.date(from: accident.accidentDate ?? "")
        if let date = date {
            cell.accidentDateTimeLabel.text = outDateFormatter.string(from: date)
        } else {
            cell.accidentDateTimeLabel.text = ""
        }
        
        let htmlMessage = accident.description ?? "No description available."

        if let data = htmlMessage.data(using: String.Encoding.unicode) {
            do {
                try cell.accidentDescriptionLabel.attributedText = NSAttributedString(data: data,
                                                                                   options: [.documentType:NSAttributedString.DocumentType.html],
                                                                                   documentAttributes: nil)
            } catch {
                cell.accidentDescriptionLabel.text = accident.description
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAccident = self.accidentsList[indexPath.row]
        self.performSegue(withIdentifier: Segue.accidentDetailsSeg.rawValue, sender: selectedAccident)
    }
    
}
