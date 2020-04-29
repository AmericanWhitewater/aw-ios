//
//  RunAccidentDetailsTableViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 4/28/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class RunAccidentDetailsTableViewController: UITableViewController {

    var selectedAccident: ReachAccidentsQuery.Data.Reach.Accident.Datum?
    
    @IBOutlet weak var runTitleLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var runLocationLabel: UILabel!
    @IBOutlet weak var runWaterLevelLabel: UILabel!
    @IBOutlet weak var runDifficultyLabel: UILabel!
    @IBOutlet weak var runAgeLabel: UILabel!
    @IBOutlet weak var runFactorsLabel: UILabel!
    @IBOutlet weak var runInjuriesLabel: UILabel!
    @IBOutlet weak var runCausesLabel: UILabel!
    @IBOutlet weak var runDescriptionLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 45
        
        if let selectedAccident = selectedAccident {
            runTitleLabel.text = selectedAccident.river ?? "Unknown River"
            runSectionLabel.text = selectedAccident.section ?? "Unknown Section"
            runLocationLabel.text = selectedAccident.location ?? "Location n/a"
            runWaterLevelLabel.text = selectedAccident.waterlevel ?? "N/A"
            runAgeLabel.text = selectedAccident.age == 0 ? "N/A" : "\(selectedAccident.age ?? 0)"
            runDifficultyLabel.text = selectedAccident.difficulty ?? "N/A"
            runDescriptionLabel.set(html: selectedAccident.description ?? "<h3>No Description Available</h3>")
            
            runFactorsLabel.text = ""
            if let factors = selectedAccident.factors {
                for (index, factorItem) in factors.enumerated() {
                    runFactorsLabel?.text? += "\(factorItem.factor ?? "")"
                    if index != factors.count - 1 {
                        runFactorsLabel?.text? += "\n"
                    }
                }
            }
            
            runInjuriesLabel.text = ""
            if let injuries = selectedAccident.injuries {
                for (index, injuryItem) in injuries.enumerated() {
                    runInjuriesLabel?.text? += "\(injuryItem.injury ?? "")"
                    if index != injuries.count - 1 {
                        runFactorsLabel?.text? += "\n"
                    }
                }
            }

            runCausesLabel.text = ""
            if let causes = selectedAccident.causes {
                for (index, causeItem) in causes.enumerated() {
                    runCausesLabel?.text? += "\(causeItem.cause ?? "")"
                    if index != causes.count - 1 {
                        runCausesLabel.text? += "\n"
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    // required for dynamic resizing of static UITableViews
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
