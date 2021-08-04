//
//  ReviewPhotoTableViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 5/15/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class ReviewPhotoTableViewController: UITableViewController {

    var selectedRun: Reach?
    var takenImage: UIImage?
    var senderVC: GalleryViewController?
    
    var dateFormatter = DateFormatter()
    var serverDateFormatter = DateFormatter()
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var approxDateTimeLabel: UILabel!
    @IBOutlet weak var addObservationLabel: UILabel!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var captionContainerView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionContainerView: UIView!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    private let AUTHOR_PLACEHOLDER: String = "Author Display Name (optional)"
    private let CAPTION_PLACEHOLDER: String = "Add a Caption"
    private let DESCRIPTION_PLACEHOLDER: String = "Add a Description"
    private let OBSERVED_PLACEHOLDER: String = "Add Observation"
    
    let reportingOptions = ["Low", "Low Runnable", "Runnable", "High Runnable", "Too High"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
        serverDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        photoImageView?.image = takenImage
        runNameLabel.text = selectedRun?.name
        runSectionLabel.text = selectedRun?.section
                        
        captionTextField.placeholder = CAPTION_PLACEHOLDER
        captionTextField.layer.cornerRadius = 15
        captionContainerView.layer.cornerRadius = 15

        
        descriptionTextView.text = DESCRIPTION_PLACEHOLDER
        descriptionTextView.layer.cornerRadius = 15
        descriptionContainerView.layer.cornerRadius = 15
        descriptionTextView.delegate = self
            
        approxDateTimeLabel.text = dateFormatter.string(from: Date())
        
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        
    }

    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let image = takenImage, let selectedRun = selectedRun, let capText = captionTextField.text {
            
            var description = ""
            if let desc = descriptionTextView.text, desc != DESCRIPTION_PLACEHOLDER {
                description = desc
            }
            
            // AWTODO: what's this alert mean? fix date parsing, supply a default, or indicate how to fix.
            let dateString = self.approxDateTimeLabel.text!
            guard let date = dateFormatter.date(from: dateString) else {
                let alert = UIAlertController(
                    title: "Invalid Date Issue",
                    message: "There was an issue with the date/time for this post. Please contact us about this problem.",
                    preferredStyle: .alert)
                alert.addAction(.init(title: "Ok", style: .default, handler: nil))
                return
            }

            let serverDateString = serverDateFormatter.string(from: date)
            
            AWProgressModal.shared.show(fromViewController: self, message: "Saving...")
            
            AWGQLApiHelper.shared.postPhotoForReach(image: image, reach_id: Int(selectedRun.id), caption: capText,
                                                           description: description, photoDate: serverDateString,
                                                           callback: { (photoFileUpdate, photoPostUpdate) in
                AWProgressModal.shared.hide()
                print("Photo uploaded - callback returned")
                
                if let imageResult = photoFileUpdate.image, let uri = imageResult.uri {
                    self.showToast(message: "Your photo has been successfully saved.")
                    if let _ = self.senderVC {
                        var newUri = [String:String?]()
                        newUri["thumb"] = uri.thumb
                        newUri["med"] = uri.medium
                        newUri["big"] = uri.big
                        newUri["caption"] = self.captionTextField.text ?? ""
                        if let description = self.descriptionTextView.text {
                            newUri["description"] = description
                        }
                        newUri["author"] = "You"
                        newUri["photoDate"] = self.approxDateTimeLabel.text ?? ""
                        if let observed = self.addObservationLabel.text {
                            if observed != self.OBSERVED_PLACEHOLDER {
                                newUri["observed"] = observed
                            }
                        }
                        
                        self.senderVC?.imageLinks.insert(newUri, at: 0)
                    }

                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showToast(message: "We were unable to save your photo to the server. Please try again or try another photo.")
                }                
                
            }) { (error, message) in
                AWProgressModal.shared.hide()
                print("Error: \(error?.localizedDescription ?? "no error object") -- \(message ?? "no message")")
                self.showToast(message: "An Error Occured: \(error?.localizedDescription ?? "")\n\(message ?? "")")
            }
        }
    }
}

extension ReviewPhotoTableViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == DESCRIPTION_PLACEHOLDER {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = CAPTION_PLACEHOLDER
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ReviewPhotoTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            DuffekDialog.shared.showDatePickerDialog(title: "Select Date and Time", message: "") { (date) in
                if let date = date {
                    self.approxDateTimeLabel.text = self.dateFormatter.string(from: date)
                }
            }
        } else if indexPath.section == 1 && indexPath.row == 1 {
            DuffekDialog.shared.showPickerDialog(pickerDataSource: self, pickerDelegate: self, title: "Describe the Flow", message: "Please choose from the following options:") {}
        }
    }
}

extension ReviewPhotoTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        addObservationLabel.text = reportingOptions[row]
    }
}

