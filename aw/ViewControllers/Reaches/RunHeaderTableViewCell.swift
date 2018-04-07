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

    var favoriteTable: Bool = false {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }

    func update() {
        if var date = DefaultsManager.lastUpdated {
            if favoriteTable, let favoriteDate = DefaultsManager.favoritesLastUpdated {
                date = favoriteDate > date ? favoriteDate : date
            }
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            dateFormat.doesRelativeDateFormatting = true

            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "h:mm a"

            updateTimeLabel.text = "\( favoriteTable ? "Favorites " : "" )Last Updated \(dateFormat.string(from: date)) at \(timeFormat.string(from: date))"
        } else {
            updateTimeLabel.text = "Update in progress"
        }
    }
}
