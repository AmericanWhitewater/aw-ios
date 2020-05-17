//
//  ReviewPhotoTableViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 5/15/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class ReviewPhotoTableViewController: UITableViewController, UITextViewDelegate {

    var selectedRun: Reach?
    var takenImage: UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var captionContainerView: UIView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    private let CAPTION_PLACEHOLDER: String = "Add a caption"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView?.image = takenImage
        runNameLabel.text = selectedRun?.name
        runSectionLabel.text = selectedRun?.section
        
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
            
            AWGQLApiHelper.shared.postPhotoFor(reach_id: Int(selectedRun.id), image: image, caption: capText, callback: { (photoResult) in
                if let imageResult = photoResult.image, let uri = imageResult.uri {
                    print("Photo Link: ", uri.thumb ?? "no thumb")
                    DuffekDialog.shared.showOkDialog(title: "Photo Saved", message: "Your photo has be successfully saved.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }) { (error) in
                print("Error uploading photo: ", error)
            }
        }
    }
}
