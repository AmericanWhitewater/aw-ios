//
//  FavoriteListTableViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class FavoriteListTableViewController: RunListTableViewController {
    override func viewDidLoad() {
        predicates.append(NSPredicate(format: "favorite = TRUE" ))
        super.viewDidLoad()
        favorite = true
    }

    override func noDataString() -> String {
        if DefaultsManager.distanceFilter != 0 && DefaultsManager.regionsFilter.count != 0 {
            return "No favorite runs found with current filters. Is the distance filter hiding the selected regions?"
        }
        if DefaultsManager.distanceFilter != 0 {
            return "No favorite runs found with current filters. You might want to try searching a larger area?"
        }

        return "No favorite runs found. Have you starred any runs and checked which filters are applied?"
    }

    override func refreshReaches(sender: UIRefreshControl) {
        let attributedTitle = sender.attributedTitle

        let refreshingTitle = NSLocalizedString("Refreshing favorites from AW", comment: "Refreshing favorites from AW")
        sender.attributedTitle = NSAttributedString(string: refreshingTitle)

        guard let fetchedResultsController = fetchedResultsController,
            let reaches = fetchedResultsController.fetchedObjects
            else { return }

        let reachesIds = reaches.map { String($0.id) }

        if let context = managedObjectContext {
            AWApiHelper.updateReaches(reachIds: reachesIds, viewContext: context) {
                sender.endRefreshing()
                sender.attributedTitle = attributedTitle
                let header = self.tableView.headerView(forSection: 0) as? RunHeaderTableViewCell
                header?.update()
            }
        }

    }
}
