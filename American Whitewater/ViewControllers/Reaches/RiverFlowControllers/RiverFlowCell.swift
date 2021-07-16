//
//  RiverFlowCell.swift
//  American Whitewater
//
//  Created by David Nelson on 6/30/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class RiverFlowCell: UITableViewCell {

    
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var postedImageView: UIImageView!
    @IBOutlet weak var postedTitleLabel: UILabel!
    @IBOutlet weak var reportedVisualLabel: UILabel!
    @IBOutlet weak var reportedGaugeValueLabel: UILabel!
    @IBOutlet weak var expandImageButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
