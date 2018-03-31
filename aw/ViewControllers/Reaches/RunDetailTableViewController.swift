//
//  RunDetailTableViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

class RunDetailTableViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var gradientLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var detailUpdated: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var managedObjectContext: NSManagedObjectContext?

    var reach: Reach?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let reach = reach, let moc = managedObjectContext {
            /*AWApiHelper.fetchReachDetail(reachID: String(reach.id)) { (detail) in
                print(detail)
            } */
            AWApiHelper.updateReachDetail(reachID: String(reach.id), viewContext: moc) {
                print("Updated reach details")
                self.drawView()
            }
        }

        initialize()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 1
        case 1:
            return 2
        case 3:
            return 3
        default:
            return 0
        }
    }
}

extension RunDetailTableViewController {
    func initialize() {
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0) //UIEdgeInsetsMake(-36, 0, 0, 0)

        drawView()
    }

    func drawView() {
        guard let reach = reach else { return }
        nameLabel.text = reach.name
        sectionLabel.text = reach.section
        difficultyLabel.text = reach.difficulty

        if let reading = reach.lastGageReading, let unit = reach.unit {
            readingLabel.text = reading
            readingLabel.textColor = reach.color
            unitsLabel.text = unit
        } else {
            readingLabel.text = ""
            unitsLabel.textColor = reach.color
            unitsLabel.text = "Unknown"
        }

        lengthLabel.text = reach.length ?? "Unknown"
        if reach.avgGradient != 0 {
            gradientLabel.text = "\(reach.avgGradient) fpm"
        } else {
            gradientLabel.text = "Unknown"
        }

        detailUpdated.text = reach.detailUpdated?.description ?? "Updating Run Details"

        if detailUpdated != nil {
            if let description = reach.longDescription, let data = description.data(using: .utf8) {
                if let html = try? NSMutableAttributedString(data: data,
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil) {
                    descriptionLabel.attributedText = html
                }
            } else {
                descriptionLabel.text = "No description"
            }
        } else {
            descriptionLabel.text = "Updating run details"
        }

    }
}

extension RunDetailTableViewController: MOCViewControllerType {

}
