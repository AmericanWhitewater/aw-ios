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
    // This must always be set before presenting the controller.
    // Storyboards/segues make it difficult to remove the optional
    var selectedRun: Reach!
        
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
    
    // AWTODO: this should be part of models
    enum FlowOptions: CaseIterable, Equatable {
        case low, lowRunnable, runnable, highRunnable, tooHigh
        
        var title: String {
            switch self {
            case .low: return "Low"
            case .lowRunnable: return "Low Runnable"
            case .runnable: return "Runnable"
            case .highRunnable: return "High Runnable"
            case .tooHigh: return "Too High"
            }
        }
        
        var value: Double {
            switch self {
            case .low: return -1
            case .lowRunnable: return 0.1
            case .runnable: return 0.45
            case .highRunnable: return 0.8
            case .tooHigh: return 1.5
            }
        }
    }
    
    var unitOptions = ["cfs", "ft", "in"]
    var availableMetrics = [String:String]()
    
    let dateFormatter = DateFormatter()
    var awImagePicker: AWImagePicker!
    
    // AWTODO: This is the state for the storyboard placeholder that was being shown by default. Is it the correct default?
    var flowObservation: FlowOptions? = nil
    
    /// Returns the currently selected reportingOption as an index for the picker, in the format (row, component), or the first row if no selection
    var selectedPickerItem: (Int, Int) {
        guard let flowObservation = flowObservation else {
            return (0, 0)
        }

        // The force unwrap is safe because we're checking the index of an enum in its cases:
        let row = FlowOptions.allCases.firstIndex(where: { $0 == flowObservation })!
        return (row, 0)
    }
    
    private var dateObserved = Date()
    
    public var senderVC: RiverFlowsViewController?
    
    private static let isoDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "YYYY-MM-dd h:mm:ss"
        return f
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        
        awImagePicker = AWImagePicker(presentationController: self, delegate: self)
        
        submitFlowButton?.layer.cornerRadius = submitFlowButton.frame.height / 2
        submitFlowButton?.clipsToBounds = true
        
        riverNameLabel?.text = selectedRun.name
        riverSectionLabel?.text = selectedRun.section
        
        dateObservedLabel?.text = dateFormatter.string(from: dateObserved)
        observedGaugeUnitsLabel?.text = selectedRun.unit ?? "cfs"
        
        flowDescriptionLabel.text = flowObservation?.title
        
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
        observedGaugeLevelTextField.resignFirstResponder()
        observationTitleTextField.resignFirstResponder()
        
        AWProgressModal.shared.show(fromViewController: self, message: "Posting...");
        
        // send value to server
        let reachId = Int(selectedRun.id)
        let gageId: String? = selectedRun.gageId == -1 ? nil : "\(selectedRun.gageId)"
        let title = observationTitleTextField.text ?? ""
        let dateString = Self.isoDateFormatter.string(from: dateObserved)
        let reading = Double(observedGaugeLevelTextField.text ?? "0") ?? 0
        let metricIdString = availableMetrics[observedGaugeUnitsLabel.text ?? ""] ?? "0"
        let metricId = Int(metricIdString) ?? 0
        
        if let image = flowImageView.image {
            print("Posting obs with photo!")
            postFlowWithPhoto(image, reachId: reachId, gageId: gageId, metricId: metricId, title: title, dateString: dateString, reading: reading)
        } else {
            print("Posting obs without photo!")
            postFlowWithoutPhoto(reachId: reachId, gageId: gageId, metricId: metricId, title: title, dateString: dateString, reading: reading)
        }
    }

    // FIXME: this doesn't send flowObservationValue
    func postFlowWithoutPhoto(reachId: Int, gageId: String?, metricId: Int, title: String, dateString: String, reading: Double) {
        AWGQLApiHelper.shared.postGaugeObservationFor(reach_id: reachId, metric_id: metricId, title: title, dateString: dateString, reading: reading, callback: { (postResult) in
            // handle post result
            AWProgressModal.shared.hide()
                        
            if let postResult = postResult {
                print("Flow Posted: \(postResult.title ?? "no title") -- \(postResult.postDate ?? "no date")")
            }
            
            self.showToast(message: "Your flow observation has been reported and saved.")
            self.navigationController?.popViewController(animated: true)
            
        }) { (error, errorMessage) in
            AWProgressModal.shared.hide()
            if let error = error, case AWGQLApiHelper.Errors.notSignedIn = error {
                self.showToast(message: "You must sign in before adding a flow.")
                self.present(SignInViewController.fromStoryboard(), animated: true, completion: nil)
            } else {
                // AWTODO: handle other errors
                print("Error posting observation: ", error?.localizedDescription ?? "", errorMessage ?? "")
            }
        }

    }
    
    func postFlowWithPhoto(_ image: UIImage, reachId: Int, gageId: String?, metricId: Int, title: String, dateString: String, reading: Double) {
        print("GageId:", gageId ?? "n/a")
        
        AWGQLApiHelper.shared.postPhotoForReach(photoPostType: .gaugeObservation, image: image, reach_id: reachId, caption: title,
                                                       description: "", photoDate: dateString,
                                                reachObservation: flowObservation?.value, gauge_id: gageId, metric_id: metricId,
                                                       reachReading: reading,
                                                       callback: { (photoFileUpdate, photoPostUpdate) in
            AWProgressModal.shared.hide()
            print("Photo uploaded - callback returned")
            
            if let imageResult = photoFileUpdate.image, let uri = imageResult.uri {
                self.showToast(message: "Your flow observation has been reported and saved.")
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
            } else {
                self.showToast(message: "We were unable to save your flow report to the server. Please check your connection and try again.")
            }
            
        }) { (error, message) in
            AWProgressModal.shared.hide()
            print("Error: \(error?.localizedDescription ?? "no error object") -- \(message ?? "no message")")
            self.showToast(message: "An Error Occured: \(error?.localizedDescription ?? "")\n\(message ?? "")")
        }
    }
    
    @objc @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        guard authStatus != .denied, authStatus != .restricted else {
            let alert = UIAlertController(
                title: "Camera not enabled",
                message: "Please enable your camera to add a picture.",
                preferredStyle: .alert
            )
        
            // Opens Settings.app 
            alert.addAction(.init(title: "Let's Fix It!", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
            present(alert, animated: true)
            return
        }
        
        awImagePicker.present(from: sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - UITableView Overrides Delegate / Datasource
extension AddRiverFlowTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            if indexPath.row == 3 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                let alert = DuffekDialog.pickerDialog(
                    pickerDataSource: self,
                    pickerDelegate: self,
                    initialSelection: selectedPickerItem,
                    title: "Describe the Flow",
                    message: "Please choose from the following options:"
                )
                
                present(alert, animated: true)
            } else if indexPath.row == 4 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                // show date picker
                let alert = DuffekDialog.datePickerDialog(
                    title: "Please Select a Date",
                    message: "",
                    initialDate: self.dateObserved
                ) { (date) in
                        self.dateObserved = date
                        self.dateObservedLabel.text = self.dateFormatter.string(from: date)
                }
                
                present(alert, animated: true)
            }
        }
    }
}

extension AddRiverFlowTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FlowOptions.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return FlowOptions.allCases[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        flowDescriptionLabel.text = FlowOptions.allCases[row].title
        flowObservation = FlowOptions.allCases[row]
    }
}

extension AddRiverFlowTableViewController: AWImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        self.flowImageView.image = image
    }
}
