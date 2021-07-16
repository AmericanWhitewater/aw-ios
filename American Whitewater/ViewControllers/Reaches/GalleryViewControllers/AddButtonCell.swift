//
//  AddButtonCell.swift
//  American Whitewater
//
//  Created by David Nelson on 5/15/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class AddButtonCell: UICollectionViewCell {

    @IBOutlet weak var addPhotoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.height / 2
        addPhotoButton.clipsToBounds = true
    }
}
