//
//  RunHeaderTableViewCell.swift
//  aw
//
//  Created by Alex Kerney on 3/31/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class RunHeaderTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var updateTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }

    func update() {
        if let date = DefaultsManager.lastUpdated {
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            dateFormat.doesRelativeDateFormatting = true

            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "h:mm a"

            updateTimeLabel.text = "Last Update \(dateFormat.string(from: date)) at \(timeFormat.string(from: date))"
        }
    }
}
