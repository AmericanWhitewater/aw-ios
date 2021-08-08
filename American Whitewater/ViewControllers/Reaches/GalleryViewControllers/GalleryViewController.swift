//
//  GalleryViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 5/15/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

class GalleryViewController: UIViewController {
    var selectedRun: Reach?
    var imageLinks = [[String:String?]]()
    
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var riverObservationLabel: UILabel!
    
    // Expand photo button is implemented as a button and an image that's not a child of the button:
    @IBOutlet weak var expandPhotoIcon: UIImageView!
    @IBOutlet weak var expandPhotoButton: UIButton!
    
    var awImagePicker: AWImagePicker!
    
    var refreshControl = UIRefreshControl()
    
    private var selectedImageUrl: URL? = nil {
        didSet {
            self.expandPhotoIcon.isHidden = selectedImageUrl == nil
            self.expandPhotoButton.isHidden = selectedImageUrl == nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        expandPhotoIcon.isHidden = true
        expandPhotoButton.isHidden = true

        runNameLabel.text = selectedRun?.name
        runSectionLabel.text = selectedRun?.section
        
        awImagePicker = AWImagePicker(presentationController: self, delegate: self)
        
        if let url = initialPhotoURL {
            selectedImageUrl = url
            selectedImageView.load(url: url)
        }
        
        // setup pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshPictures), for: .valueChanged)
        galleryCollectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        // reload local data while we wait for
        // API data
        galleryCollectionView.reloadData()
        
        // query api
        self.refreshPictures()
    }

    @IBAction func expandPhotoButtonPressed(_ sender: Any) {
        guard let url = selectedImageUrl else {
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
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
            
        guard DefaultsManager.shared.signedInAuth != nil else {
            self.showLoginScreen()
            return
        }
        
        awImagePicker.present(from: sender)
    }
    
    func showLoginScreen() {
        tabBarController?.present(SignInViewController.fromStoryboard(), animated: true, completion: nil)
    }

    
    @objc private func refreshPictures() {
        guard let selectedRun = selectedRun else { print("selected run is nil"); return }
                
        API.shared.getPhotosForReach(reach_id: Int(selectedRun.id), page: 1, page_size: 100, callback: { (photoResults) in
            
            self.refreshControl.endRefreshing()
            
            if let photoResults = photoResults {
                for result in photoResults {
                    let photos = result.photos
                    
                    for photo in photos {
                        if let image = photo.image, let uri = image.uri,
                           let thumb = uri.thumb, let medium = uri.medium, let big = uri.big {
                            
                            //print("PhotoDate: \(photo.photoDate ?? "no photo date") - author: \(photo.author ?? "no author") - caption \(photo.caption ?? "no caption")")
                            
                            let dateString = photo.photoDate ?? result.postDate ?? ""
                            let author = photo.author ?? result.user?.uname ?? ""
                            let reading = result.reading ?? 0.0
                            
                            // only add the new photo if we already have it
                            if !self.alreadyHavePhoto(thumb: thumb) {
                                var newUri = [String:String?]()
                                newUri["thumb"] = thumb
                                newUri["med"] = medium
                                newUri["big"] = big
                                newUri["caption"] = photo.caption ?? ""
                                newUri["description"] = photo.description ?? result.detail ?? ""
                                newUri["author"] = author
                                newUri["photoDate"] = dateString
                                if reading > 0.001 {
                                    newUri["reading"] = "\(reading)"
                                }
                                print("New URI:", newUri)
                                self.imageLinks.insert(newUri, at: 0)
                            }
                        }
                    }
                    
                    self.galleryCollectionView.reloadData()
                }
            }
        }) { (error, message) in
            print("Photos GraphQL Error: \(GQLError.handleGQLError(error: error, altMessage: message))")
            self.refreshControl.endRefreshing()
        }
    }

    private func alreadyHavePhoto(thumb: String) -> Bool {
        for image in imageLinks {
            if image["thumb"] as? String == thumb {
                return true
            }
        }
        return false
    }
    
    private var initialPhotoURL: URL? {
        // Prefer the selectedRun's photoURL
        if let photoUrl = selectedRun?.photoUrl, let url = URL(string: photoUrl) {
            return url
        }
        
        // Otherwise, take the first photo from imageLinks
        if
            let imgLink = imageLinks.first?["med"] as? String,
            let url = URL(string: "\(AWGC.AW_BASE_URL)\(imgLink)")
        {
            return url
        }
        
        // Otherwise, there's no initial photo
        return nil
    }
    
    /// Set the selected image and all its associated labels, failing if an image URL can't be constructed
    private func setSelectedImage(_ imageDict: [String: String?]){
        guard
            let medUrlString = imageDict["med"] as? String,
            let url = URL(string: "\(AWGC.AW_BASE_URL)\(medUrlString)")
        else {
            return
        }
        
        selectedImageUrl = url
        
        if let author = imageDict["author"] as? String {
            self.postedByLabel.text = "Posted by: \(author.count > 0 ? author : "n/a")"
        } else {
            self.postedByLabel.text = ""
        }
        
        if let postedDate = imageDict["photoDate"] as? String {
            self.postedDateLabel.text = "Date: \(postedDate.count > 0 ? postedDate : "n/a")"
        } else {
            self.postedDateLabel.text = ""
        }
        
        if let caption = imageDict["caption"] as? String {
            self.captionLabel.text = caption.count > 0 ? caption : "No Caption Available"
        } else {
            self.captionLabel.text = "No Caption Available"
        }
        
        if let description = imageDict["description"] as? String {
            self.captionLabel.text = "\(self.captionLabel.text ?? "")\n\(description)"
        }
        
        if let reading = imageDict["reading"] as? String {
            self.riverObservationLabel.text = reading.count > 0 ? reading : ""
        } else {
            self.riverObservationLabel.text = ""
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == Segue.reviewPhotoSeg.rawValue,
            let reviewVC = segue.destination as? ReviewPhotoTableViewController,
            let image = sender as? UIImage
        else {
            return
        }
        
        reviewVC.takenImage = image
        reviewVC.selectedRun = selectedRun
        reviewVC.senderVC = self
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 335, height: 45)
        } else {
            return imageLinks.count == 0 ?
                CGSize(width: 335, height: 100) : CGSize(width: 90, height: 90)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return imageLinks.count == 0 ? 1 : imageLinks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // show 'add photo button' on first row
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoButtonCell", for: indexPath) as! AddButtonCell
            cell.addPhotoButton.addTarget(self, action: #selector(addPhotoButtonPressed(_:)), for: .touchUpInside)
            return cell
        }
        
        // show no photos available
        if indexPath.section == 1 && imageLinks.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoPhotosCell", for: indexPath)
            cell.contentView.layer.cornerRadius = 15
            cell.contentView.clipsToBounds = true
            return cell
        }
        
        // else show image's from server
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "awImageCell", for: indexPath) as! AwImageCell
        cell.imageView.image = nil
        
        let imageLink = imageLinks[indexPath.row]
        
        if let imageUrlString = imageLink["med"] as? String,
            let url = URL(string: "\(AWGC.AW_BASE_URL)\(imageUrlString)") {
            cell.imageView.load(url: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // ignore first section events on non-action views
        if indexPath.section == 0 { return }
        if indexPath.section == 1 && imageLinks.count == 0 { return }
        
        setSelectedImage(imageLinks[indexPath.row])
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AwImageCell {
            selectedImageView.image = cell.imageView.image
        }
    }
}

extension GalleryViewController: AWImagePickerDelegate {

    // show the users photo in the preview listing
    func didSelect(image: UIImage?) {
        // Go add captioning and input to photo
        if let image = image, let _ = selectedRun {
            self.performSegue(withIdentifier: Segue.reviewPhotoSeg.rawValue, sender: image)
        }
    }
}

