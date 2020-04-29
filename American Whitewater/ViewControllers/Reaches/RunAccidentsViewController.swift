//
//  RunAlertsViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 4/22/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class RunAccidentsViewController: UIViewController {

    var selectedRun: Reach?
    var accidentsList = [ReachAccidentsQuery.Data.Reach.Accident.Datum]()
    var inputDateFormatter = DateFormatter()
    var outDateFormatter = DateFormatter()
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var riverTitleLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the river title and label
        riverTitleLabel.text = selectedRun?.name ?? "Unknown River"
        riverSectionLabel.text = selectedRun?.section ?? "Unknown Section"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        // setup pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshAccidents), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // setup dateFormatter
        inputDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        outDateFormatter.dateFormat = "MMM d, yyyy"
        
        self.refreshControl.beginRefreshing()
        self.refreshAccidents()
    }
    
    @objc func refreshAccidents() {
        print("Refreshing Accidents...")
        
        AWGQLApiHelper.shared.getAccidentsForReach(reach_id: 476, first: 2, page: 1, callback: { (accidentResults) in
            self.accidentsList.removeAll()
            
            // handle server sending back multiple of the same results
            // server issue but needs client side handling for now
            if let accidentResults = accidentResults {
                print("AccidentResults count: \(accidentResults.count)")
                for item in accidentResults {
                    let accidentIds = self.accidentsList.map { $0.id }
                    if !accidentIds.contains(item.id) {
                        self.accidentsList.append(item)
                    }
                }
                self.accidentsList.reversed() // show latest accidents first
                print("AccidentsList count: \(self.accidentsList.count)")
            }
            
            //self.accidentsList = accidentResults
            self.tableView.reloadData()
        }) { (error) in
            print("Accidents Query Error: \(error.localizedDescription)")
        }
        
        self.refreshControl.endRefreshing()
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
        return accidentsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "accidentCell", for: indexPath) as! AccidentTableViewCell
        
        let accident = accidentsList[indexPath.row]
        
        let date = inputDateFormatter.date(from: accident.accidentdate ?? "")
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
