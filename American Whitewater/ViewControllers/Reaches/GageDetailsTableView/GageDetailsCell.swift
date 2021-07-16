//
//  GageDetailsCell.swift
//  American Whitewater
//
//  Created by David Nelson on 1/11/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import UIKit

class GageDetailsCell: UITableViewCell {

    @IBOutlet weak var reachNameLabel: UILabel!
    @IBOutlet weak var reachSectionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var reachLevelLabel: UILabel!
    @IBOutlet weak var reachUnitLabel: UILabel!
    @IBOutlet weak var reachGageDeltaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
