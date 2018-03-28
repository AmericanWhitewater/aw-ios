//
//  RunListTableViewCell.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

class RunListTableViewCell: UITableViewCell, MOCViewControllerType {
    @IBOutlet weak var conditionColorView: UIView!
    @IBOutlet weak var riverName: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?

    var reach: Reach?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(reach: Reach) {
        self.reach = reach

        draw()
    }

    func draw() {
        if let reach = reach {
            conditionColorView.backgroundColor = reach.color

            riverName.text = reach.name
            sectionLabel.text = reach.section
            difficultyLabel.text = "Level: \(reach.readingFormatted) Class: \(reach.difficulty ?? "Unknown")"
            difficultyLabel.textColor = reach.color

            let favorite_icon = reach.favorite ?
                UIImage(named: "icon_favorite_selected") : UIImage(named: "icon_favorite")
            favoriteButton.setImage(favorite_icon, for: .normal)

        }
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        managedObjectContext?.persist {
            guard let reach = self.reach else { return }
            reach.favorite = !reach.favorite
        }

        favoriteButton.setImage(UIImage(named: "icon_favorite_selected"), for: .normal)
    }
}
