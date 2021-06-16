//
//  LoadingRiversCell.swift
//  American Whitewater
//
//  Created by David Nelson on 1/28/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import UIKit

class LoadingRiversCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
