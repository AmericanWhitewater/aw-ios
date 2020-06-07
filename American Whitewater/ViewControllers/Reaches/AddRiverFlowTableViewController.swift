//
//  AddRiverFlowTableViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 5/20/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class AddRiverFlowTableViewController: UITableViewController {

    var selectedRun: Reach?
        
    @IBOutlet weak var riverNameLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var flowDescriptionLabel: UILabel!
    
    let reportingOptions = ["Low", "Low Runnable", "Runnable", "High Runnable", "Too High"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        riverNameLabel?.text = selectedRun?.name
        riverSectionLabel?.text = selectedRun?.section
    }

    
    @IBAction func submitFlowButtonPressed(_ sender: Any) {
        DuffekDialog.shared.showOkDialog(title: "Feature Coming", message: "This feature is being updated and will be available in the next release.")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension AddRiverFlowTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UITableView Overrides Delegate / Datasource
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                DuffekDialog.shared.showPickerDialog(pickerDataSource: self, pickerDelegate: self, title: "Describe the Flow", message: "Please choose from the following options:") {}
            }
        }
    }
    
    // MARK: - UIPickerView Delegates / Datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reportingOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reportingOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected:", reportingOptions[row])
        flowDescriptionLabel.text = "Flow Description: \(reportingOptions[row])"
    }
}
