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
}
