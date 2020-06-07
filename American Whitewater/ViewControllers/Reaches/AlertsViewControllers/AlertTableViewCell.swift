//
//  AlertTableViewCell.swift
//  American Whitewater
//
//  Created by David Nelson on 4/27/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    
    @IBOutlet weak var alertDateTimeLabel: UILabel!
    @IBOutlet weak var alertPosterLabel: UILabel!
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
