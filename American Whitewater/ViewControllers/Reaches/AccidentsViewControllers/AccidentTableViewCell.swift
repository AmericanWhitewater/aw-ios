//
//  AccidentTableViewCell.swift
//  American Whitewater
//
//  Created by David Nelson on 4/28/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class AccidentTableViewCell: UITableViewCell {

    @IBOutlet weak var accidentDateTimeLabel: UILabel!
    @IBOutlet weak var accidentDescriptionLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
