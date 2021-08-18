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
    var imageLinks = [Photo]()
    
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
        

        // if nothing is selected we try and load one
        if
            let selectedRun = selectedRun,
            selectedRun.photoUrl == nil,
            let url = imageLinks.first?.mediumURL
        {
            print("Trying to load url: \(url)")
            selectedImageView.load(url: url)
        }
        
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
        
        API.shared.getPhotos(reachId: Int(selectedRun.id), page: 1, pageSize: 100) { (photos, error) in
            defer {
                self.refreshControl.endRefreshing()
            }
            
            guard
                let photos = photos,
                error == nil
            else {
                print("Photos GraphQL Error: \(String(describing: error))")
                return
            }
            
            self.imageLinks = photos
            self.galleryCollectionView.reloadData()
        }
    }
    
    private var initialPhotoURL: URL? {
        // Prefer the selectedRun's photoURL
        if let photoUrl = selectedRun?.photoUrl, let url = URL(string: photoUrl) {
            return url
        }
        
        // Otherwise, take the first photo from imageLinks if available
        return imageLinks.first?.mediumURL
    }
    
    /// Set the selected image and all its associated labels, failing if an image URL can't be constructed
    private func setSelectedImage(_ image: Photo){
        guard let url = image.mediumURL else {
            return
        }
        
        selectedImageUrl = url
        
        if let author = image.author {
            self.postedByLabel.text = "Posted by: \(author.count > 0 ? author : "n/a")"
        } else {
            self.postedByLabel.text = ""
        }
        
        if let postedDate = image.date {
            self.postedDateLabel.text = "Date: \(Self.dateFormatter.string(from: postedDate))"
        } else {
            self.postedDateLabel.text = ""
        }
        
        if let caption = image.caption {
            self.captionLabel.text = caption.count > 0 ? caption : "No Caption Available"
        } else {
            self.captionLabel.text = "No Caption Available"
        }
        
        if let description = image.description {
            self.captionLabel.text = "\(self.captionLabel.text ?? "")\n\(description)"
        }
        
        // FIXME: this isn't part of Photo now -- but wasn't it wrong before?
//        if let reading = image["reading"] as? String {
//            self.riverObservationLabel.text = reading.count > 0 ? reading : ""
//        } else {
//            self.riverObservationLabel.text = ""
//        }
        
        selectedImageUrl = image.mediumURL
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

        if let url = imageLinks[indexPath.row].mediumURL {
            cell.imageView.load(url: url)
        }
        
        return cell
    }
    
    static private let dateFormatter = DateFormatter(dateFormat: "MMM d, h:mm a")
    
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

