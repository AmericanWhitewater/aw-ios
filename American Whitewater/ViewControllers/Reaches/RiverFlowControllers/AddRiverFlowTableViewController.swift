//
//  AddRiverFlowTableViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 5/20/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit
import AVFoundation

class AddRiverFlowTableViewController: UITableViewController {

    var selectedRun: Reach?
        
    @IBOutlet weak var riverNameLabel: UILabel!
    @IBOutlet weak var riverSectionLabel: UILabel!
    @IBOutlet weak var flowImageView: UIImageView!
    @IBOutlet weak var observationTitleTextField: UITextField!
    @IBOutlet weak var flowDescriptionLabel: UILabel!
    @IBOutlet weak var observedGaugeLevelTextField: UITextField!
    @IBOutlet weak var observedGaugeUnitsLabel: UILabel!
    @IBOutlet weak var dateObservedLabel: UILabel!
    @IBOutlet weak var addFlowButton: UIButton!
        
    @IBOutlet weak var submitFlowButton: UIButton!
    
    //let reportingOptions = ["Low", "Low Runnable", "Runnable", "High Runnable", "Too High"]
    let reportingOptions = [ ["Low":-1], ["Low Runnable":0.1], ["Runnable": 0.45], ["High Runnable": 0.8], ["Too High":1.5] ]
    
    var unitOptions = ["cfs", "ft", "in"]
    var availableMetrics = [String:String]()
    
    let dateFormatter = DateFormatter()
    var awImagePicker: AWImagePicker!
    
    var flowObservationValue: Double? = nil
    
    public var senderVC: RiverFlowsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        
        awImagePicker = AWImagePicker(presentationController: self, delegate: self)
        
        submitFlowButton?.layer.cornerRadius = submitFlowButton.frame.height / 2
        submitFlowButton?.clipsToBounds = true
        
        riverNameLabel?.text = selectedRun?.name
        riverSectionLabel?.text = selectedRun?.section
        
        dateObservedLabel?.text = dateFormatter.string(from: Date())
        observedGaugeUnitsLabel?.text = selectedRun?.unit ?? "cfs"
        
        if availableMetrics.count > 0 {
            self.unitOptions = Array(availableMetrics.keys)
        }
    }

    @IBAction func changeUnitsButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Select Units", message: "", preferredStyle: .actionSheet)
        for item in unitOptions {
            let action = UIAlertAction(title: item, style: .default) { (alertAction) in
                alert.dismiss(animated: true, completion: nil)
                self.observedGaugeUnitsLabel.text = item
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func submitFlowButtonPressed(_ sender: Any) {
        //DuffekDialog.shared.showOkDialog(title: "Feature Coming", message: "This feature is being updated and will be available in the next release.")
        observedGaugeLevelTextField.resignFirstResponder()
        observationTitleTextField.resignFirstResponder()
        
        guard let selectedRun = selectedRun else {
            DuffekDialog.shared.showOkDialog(title: "Post Observation Error", message: "An error has occured. Please notify us of this problem")
            return
        }
        
        if let titleText = observationTitleTextField.text, titleText.count < 1 {
            DuffekDialog.shared.showOkDialog(title: "Caption Required", message: "Please enter a caption and try again!")
            return
        }

        AWProgressModal.shared.show(fromViewController: self, message: "Posting...");
        
        // send value to server
        let reachId = Int(selectedRun.id)
        let gageId: String? = selectedRun.gageId == -1 ? nil : "\(selectedRun.gageId)"
        let title = observationTitleTextField.text ?? "no title available"
        
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "YYYY-MM-dd h:mm:ss"
        let date = dateFormatter.date(from: dateObservedLabel.text!)
        let dateString = isoDateFormatter.string(from: date ?? Date())
        let reading = Double(observedGaugeLevelTextField.text ?? "0") ?? 0
        let metricIdString = availableMetrics[observedGaugeUnitsLabel.text ?? ""] ?? "0"
        let metricId = Int(metricIdString) ?? 0
        
        if flowImageView.image == nil {
            print("Posting obs without photo!")
            postFlowWithoutPhoto(reachId: reachId, gageId: gageId, metricId: metricId, title: title, dateString: dateString, reading: reading)
        } else {
            print("Posting obs with photo!")
            postFlowWithPhoto(reachId: reachId, gageId: gageId, metricId: metricId, title: title, dateString: dateString, reading: reading)
        }
    }

    func postFlowWithoutPhoto(reachId: Int, gageId: String?, metricId: Int, title: String, dateString: String, reading: Double) {
        AWGQLApiHelper.shared.postGaugeObservationFor(reach_id: reachId, metric_id: metricId, title: title, dateString: dateString, reading: reading, callback: { (postResult) in
            // handle post result
            AWProgressModal.shared.hide()
            
            // AWTODO: Check for errors!
            
            if let postResult = postResult {
                print("Flow Posted: \(postResult.title ?? "no title") -- \(postResult.postDate ?? "no date")")
            }
            
            DuffekDialog.shared.showOkDialog(title: "Flow Saved", message: "Your flow observation has been reported and saved.") {
                self.navigationController?.popViewController(animated: true)
            }
            
        }) { (error, errorMessage) in
            AWProgressModal.shared.hide()
            // handle error
            print("Error posting observation: ", error?.localizedDescription ?? "", errorMessage ?? "")
        }

    }
    
    func postFlowWithPhoto(reachId: Int, gageId: String?, metricId: Int, title: String, dateString: String, reading: Double) {
        print("GageId:", gageId ?? "n/a")
        
        guard let image = flowImageView.image else {
            DuffekDialog.shared.showOkDialog(title: "Invalid Image", message: "There is an issue with the chosen image. Please try a different one")
            return
        }
        
        AWGQLApiHelper.shared.postPhotoForReach(photoPostType: .gaugeObservation, image: image, reach_id: reachId, caption: title,
                                                       description: "", photoDate: dateString,
                                                       reachObservation: flowObservationValue, gauge_id: gageId, metric_id: metricId,
                                                       reachReading: reading,
                                                       callback: { (photoFileUpdate, photoPostUpdate) in
            AWProgressModal.shared.hide()
            print("Photo uploaded - callback returned")
            
            if let imageResult = photoFileUpdate.image, let uri = imageResult.uri {
                DuffekDialog.shared.showOkDialog(title: "Flow Saved", message: "Your flow observation has been reported and saved.") {
                    if let _ = self.senderVC {
                        var newFlow = [String:String?]()
                        newFlow["thumb"] = uri.thumb
                        newFlow["med"] = uri.medium
                        newFlow["big"] = uri.big
                        
                        newFlow["id"] = "\(photoPostUpdate.id ?? photoFileUpdate.id)"
                        newFlow["title"] = photoFileUpdate.caption ?? photoPostUpdate.title ?? ""
                        newFlow["description"] = photoFileUpdate.description ?? photoPostUpdate.detail ?? ""
                        newFlow["reading"] = "\(photoPostUpdate.reading != nil ? "\(photoPostUpdate.reading!)" : "n/a")"
                        newFlow["author"] = photoFileUpdate.author ?? photoPostUpdate.user?.uname ?? "You"
                        newFlow["postDate"] = photoFileUpdate.photoDate ?? photoPostUpdate.postDate ?? ""
                        newFlow["metric"] = photoPostUpdate.metric?.unit ?? ""
                        // TODO: newFlow["observed"] = ????
                        
                        self.senderVC?.riverFlows.insert(newFlow, at: 0)
                    }

                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                DuffekDialog.shared.showOkDialog(title: "Upload Issue", message: "We were unable to save your flow report to the server. Please check your connection and try again.")
            }
            
        }) { (error, message) in
            AWProgressModal.shared.hide()
            print("Error: \(error?.localizedDescription ?? "no error object") -- \(message ?? "no message")")
            DuffekDialog.shared.showOkDialog(title: "An Error Occured", message: "\(error?.localizedDescription ?? "")\n\(message ?? "")")
        }
    }
    
    @objc @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        if authStatus == .denied || authStatus == .restricted {
            // user rejected the ask
            DuffekDialog.shared.showStandardDialog(title: "Access Denied", message: "Hey, it looks like you rejected our access to your camera... We can't enable your camera to take pictures without it.", buttonTitle: "Let's Fix It!") {
                // user wants to fix the issue
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                
            } cancelFunction: {
                // user doens't want to fix it.
            }
        } else {
            awImagePicker.present(from: sender)
        }
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
            
            if indexPath.row == 3 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                DuffekDialog.shared.showPickerDialog(pickerDataSource: self, pickerDelegate: self, title: "Describe the Flow", message: "Please choose from the following options:") {}
            } else if indexPath.row == 4 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                // show date picker
                DuffekDialog.shared.showDatePickerDialog(title: "Please Select a Date", message: "") { (date) in
                    if let date = date {
                        //print("Date Chosen:", dateFormatter.string(from: date))
                        self.dateObservedLabel.text = self.dateFormatter.string(from: date)
                    } else {
                        print("Date was nil - using current date and time")
                        self.dateObservedLabel.text = self.dateFormatter.string(from: Date())
                    }
                }
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
        return reportingOptions[row].keys.first
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let option = reportingOptions[row]
        let keys = Array(option.keys)
        if let title = keys.first {
            print("Selected:", title)
            flowDescriptionLabel.text = title
            flowObservationValue = option[title]
        }
                
        print("flowObservationValue:", flowObservationValue ?? -99);
    }
}

extension AddRiverFlowTableViewController: AWImagePickerDelegate {

    // show the users photo in the preview listing
    func didSelect(image: UIImage?) {
        // Go add captioning and input to photo
        if let image = image, let _ = selectedRun {
            self.flowImageView.image = image
        }
    }
}
