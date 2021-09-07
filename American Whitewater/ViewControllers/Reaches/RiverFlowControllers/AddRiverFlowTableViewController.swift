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
    
    var availableMetrics = [Metric]()
    
    var unitOptions: [String] {
        if availableMetrics.isEmpty {
            return ["cfs", "ft", "in"]
        } else {
            return availableMetrics.map(\.unit)
        }
    }
    
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
        let gageId = selectedRun.gageId == -1 ? nil : Int(selectedRun.gageId)
        let title = observationTitleTextField.text ?? ""
        let dateString = Self.isoDateFormatter.string(from: dateObserved)
        let reading = Double(observedGaugeLevelTextField.text ?? "0") ?? 0
        
        // FIXME: unitOptions may return a default list if no metrics are available, but in that case, it will be sent with metricId = 0, dropping the user's intended unit
        let metricIdString = availableMetrics.first(where: { $0.unit == observedGaugeUnitsLabel.text })?.id ?? "0"
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
    // FIXME: gageId is dropped on the floor, see API.swift
    func postFlowWithoutPhoto(reachId: Int, gageId: Int?, metricId: Int, title: String, dateString: String, reading: Double) {
        API.shared.postGaugeObservation(reachId: reachId, metricId: metricId, title: title, dateString: dateString, reading: reading) { (postResult, error) in
            defer {
                AWProgressModal.shared.hide()
            }
            
            
            if let error = error {
                switch error {
                case AWGQLApiHelper.Errors.notSignedIn:
                    self.showToast(message: "You must sign in before adding a flow.")
                    self.present(SignInViewController.fromStoryboard(), animated: true, completion: nil)
                default:
                    print("Error posting observation: ", error.localizedDescription)
                }
                
                return
            }
            
            guard let postResult = postResult else { return }
            
            print("Flow Posted: \(postResult.title ?? "no title") -- \(String(describing: postResult.date))")
            
            self.showToast(message: "Your flow observation has been reported and saved.")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func postFlowWithPhoto(_ image: UIImage, reachId: Int, gageId: Int?, metricId: Int, title: String, dateString: String, reading: Double) {
        print("GageId:", gageId ?? "n/a")
        
        API.shared.postPhoto(
            photoPostType: .gaugeObservation,
            image: image,
            reachId: reachId,
            caption: title,
            description: "", photoDate: dateString,
            reachObservation: flowObservation?.value,
            gaugeId: gageId,
            metricId: metricId,
            reachReading: reading
        ) { (photo, error) in
            defer {
                AWProgressModal.shared.hide()
            }
            
            guard
                let photo = photo,
                error == nil
            else {
                print("Error: \(error?.localizedDescription)")
                self.showToast(message: "An Error Occured: \(error?.localizedDescription)")
                
                // FIXME: older version could also do this error, if no error was returned but also no object. This should return an error too (could it even happen?) but which is the correct message to show the user?
//                self.showToast(message: "We were unable to save your flow report to the server. Please check your connection and try again.")
                return
            }
            
            print("Photo uploaded - callback returned")
            self.showToast(message: "Your flow observation has been reported and saved.")
                
                // FIXME: add this back with updated API response
                // FIXME: This is attempting to make a GaugeObservation out of the response... perhaps it should be calling a distinct API method to indicate that's what it wants
            
                //                    if let _ = self.senderVC {
                //                        var newFlow = [String:String?]()
                //                        newFlow["thumb"] = uri.thumb
                //                        newFlow["med"] = uri.medium
                //                        newFlow["big"] = uri.big
                //
                //                        newFlow["id"] = "\(photoPostUpdate.id ?? photoFileUpdate.id)"
                //                        newFlow["title"] = photoFileUpdate.caption ?? photoPostUpdate.title ?? ""
                //                        newFlow["description"] = photoFileUpdate.description ?? photoPostUpdate.detail ?? ""
                //                        newFlow["reading"] = "\(photoPostUpdate.reading != nil ? "\(photoPostUpdate.reading!)" : "n/a")"
                //                        newFlow["author"] = photoFileUpdate.author ?? photoPostUpdate.user?.uname ?? "You"
                //                        newFlow["postDate"] = photoFileUpdate.photoDate ?? photoPostUpdate.postDate ?? ""
                //                        newFlow["metric"] = photoPostUpdate.metric?.unit ?? ""
                //                        // TODO: newFlow["observed"] = ????
                //
                //                        self.senderVC?.riverFlows.insert(newFlow, at: 0)
                //                    }
                
            self.navigationController?.popViewController(animated: true)
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
