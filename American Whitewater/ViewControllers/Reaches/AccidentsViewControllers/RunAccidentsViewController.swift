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
    
    private var accidentsList = [Accident]()
    private var inputDateFormatter = DateFormatter()
    private var outDateFormatter = DateFormatter()
    private let refreshControl = UIRefreshControl()

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
        
        // FIXME: are there reaches with more than 100 accidents? If so, is it OK to ignore anything after the first 100?
        API.shared.getAccidents(reachId: Int(reach.id), first: 100, page: 1) { (accidents, error) in
            defer { self.refreshControl.endRefreshing() }
            
            guard let accidents = accidents else {
                print("Accidents Query Error: \(String(describing: error))")
                
                return
            }
            
            // server may send back multiple of the same results so unique by id
            // sort the alerts list by postDate
            self.accidentsList = Dictionary(grouping: accidents, by: \.id)
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
    
    @IBAction func reportAccidentButtonPressed(_ sender: Any) {
        if let url = URL(string: "https://www.americanwhitewater.org/content/Accident/report/") {
            let safariVC = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
            self.present(safariVC, animated: true)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == Segue.accidentDetailsSeg.rawValue,
            let accident = sender as? Accident
        else {
            return
        }
        
        let detailsVC = segue.destination as? RunAccidentDetailsTableViewController
        detailsVC?.selectedAccident = accident
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
        
        if let date = accident.date {
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
        
        self.performSegue(
            withIdentifier: Segue.accidentDetailsSeg.rawValue,
            sender: self.accidentsList[indexPath.row]
        )
    }
    
}
