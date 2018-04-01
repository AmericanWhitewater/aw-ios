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
    @IBOutlet weak var imageView: UIImageView!

    var managedObjectContext: NSManagedObjectContext?

    var reach: Reach?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let reach = reach,
            let moc = managedObjectContext,
            reach.detailUpdated == nil {
            print("Updating reach detail")
            AWApiHelper.updateReachDetail(reachID: String(reach.id), viewContext: moc) {
                print("Updated reach details")
                self.drawView()
            }
        } else {
            print("Details already updated")
            drawView()
        }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RunDetailTableViewController {
    func initialize() {
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0) //UIEdgeInsetsMake(-36, 0, 0, 0)

        drawView()
        setupRefreshControl()
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull to Refresh", comment: "Pull to Refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshReach(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func tapFavoriteIcon(_ sender: Any) {
        guard let reach = reach, let context = managedObjectContext else { return }

        context.persist {
            reach.favorite = !reach.favorite
            self.drawView()
        }
    }

    @objc func refreshReach(sender: UIRefreshControl) {
        let attributedTitle = sender.attributedTitle
        let refreshingTitle = NSLocalizedString("Refreshing run details from AW",
            comment: "Refreshing run details from AW")
        sender.attributedTitle = NSAttributedString(string: refreshingTitle)

        if let reach = reach, let context = managedObjectContext {
            AWApiHelper.updateReachDetail(reachID: String(reach.id), viewContext: context) {
                sender.endRefreshing()
                sender.attributedTitle = attributedTitle
                self.drawView()
            }
        }
    }

    func drawView() {
        guard let reach = reach else { return }
        nameLabel.text = reach.name
        sectionLabel.text = reach.sectionCleanedHTML
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

        if let length = reach.length {
            lengthLabel.text = "\(length) miles"
        } else {
            lengthLabel.text = "Unknown"
        }

        if reach.avgGradient != 0 {
            gradientLabel.text = "\(reach.avgGradient) fpm"
        } else {
            gradientLabel.text = "Unknown"
        }

        detailUpdated.text = reach.updatedString ?? "Updating Run Details"

        if detailUpdated != nil {
            if let description = reach.longDescription, let data = description.data(using: .utf8) {
                if let html = try? NSMutableAttributedString(data: data,
                         options: [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html],
                         documentAttributes: nil) {
                    descriptionLabel.attributedText = html
                }
            } else {
                descriptionLabel.text = "No description"
            }
        } else {
            descriptionLabel.text = "Updating run details"
        }
        if let photoUrl = reach.photoUrl {
            if let url = URL(string: photoUrl), let data = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: data)
            }
        }
    }
}

extension RunDetailTableViewController: RunDetailViewControllerType {

}

extension RunDetailTableViewController: MOCViewControllerType {

}
