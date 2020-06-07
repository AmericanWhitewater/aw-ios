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
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var captionContainerView: UIView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    private let CAPTION_PLACEHOLDER: String = "Add a Caption..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView?.image = takenImage
        runNameLabel.text = selectedRun?.name
        runSectionLabel.text = selectedRun?.section
        
        captionTextView.text = CAPTION_PLACEHOLDER
        captionContainerView.layer.cornerRadius = 15
        captionTextView.layer.cornerRadius = 15
        captionTextView.delegate = self
        
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
    }

    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if captionTextView.text.count == 0 || captionTextView.text == CAPTION_PLACEHOLDER {
            DuffekDialog.shared.showOkDialog(title: "Caption Required", message: "Please enter a valid caption before saving your photo.")
            return
        }
        
        // save photo to the server
        if let image = takenImage, let selectedRun = selectedRun, let capText = captionTextView.text {
            
            AWProgressModal.shared.show(fromViewController: self, message: "Saving...")
            AWGQLApiHelper.shared.postPhotoFor(reach_id: Int(selectedRun.id), image: image, caption: capText, callback: { (photoResult) in
                
                // stop showing progress
                
                AWProgressModal.shared.hide()
                if let imageResult = photoResult.image, let uri = imageResult.uri {
                    print("Photo Link: ", uri.thumb ?? "no thumb")
                    DuffekDialog.shared.showOkDialog(title: "Photo Saved", message: "Your photo has been successfully saved.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }) { (error, message) in
                AWProgressModal.shared.hide()
                print("Error Uploading Photo: \(GQLError.handleGQLError(error: error, altMessage: message))")
            }
        }
    }
}

extension ReviewPhotoTableViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == CAPTION_PLACEHOLDER {
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
