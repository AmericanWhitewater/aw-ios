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
        super .viewDidLoad()
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
}
