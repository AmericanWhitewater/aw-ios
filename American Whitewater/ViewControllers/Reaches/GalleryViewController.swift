//
//  GalleryViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 5/15/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    var selectedRun: Reach?
    var imageLinks = [[String:String?]]()
    
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
       
    var awImagePicker: AWImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        runNameLabel.text = selectedRun?.name
        runSectionLabel.text = selectedRun?.section
        
        awImagePicker = AWImagePicker(presentationController: self, delegate: self)
        
        if let selectedRun = selectedRun, let photoUrl = selectedRun.photoUrl,
            let url = URL(string: photoUrl) {
            selectedImageView.load(url: url)
        }
    }

    @objc @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        awImagePicker.present(from: sender)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.reviewPhotoSeg.rawValue {
            let reviewVC = segue.destination as? ReviewPhotoTableViewController
            if let image = sender as? UIImage {
                reviewVC?.takenImage = image
                reviewVC?.selectedRun = selectedRun
            }
        }
        
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 335, height: 45)
        } else {
            return CGSize(width: 90, height: 90)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return imageLinks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // show 'add photo button' on first row
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoButtonCell", for: indexPath) as! AddButtonCell
            cell.addPhotoButton.addTarget(self, action: #selector(addPhotoButtonPressed(_:)), for: .touchUpInside)
            return cell
        }
        
        // else show image's from server
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "awImageCell", for: indexPath) as! AwImageCell
        if let imageUrlString = imageLinks[indexPath.row]["med"] as? String,
            let url = URL(string: "\(AWGC.AW_BASE_URL)\(imageUrlString)") {
            
            print("\(AWGC.AW_BASE_URL)\(imageUrlString)")
            cell.imageView.load(url: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // ignore first section events
        if indexPath.section == 0 { return }
        
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

