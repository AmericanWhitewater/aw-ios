//
//  MoreTableViewController.swift
//  aw
//
//  Created by Alex Kerney on 4/1/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 5
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 2, section: 1): // Rate this App
            break
        case IndexPath(row: 3, section: 1): // Feedback
            break
        case IndexPath(row: 4, section: 1): // Donate
            UIApplication.shared.open(URL(string: "https://www.americanwhitewater.org/content/Membership/donate")!, options: [:]) { (status) in
                if status {
                    print("Opened browser to donate page")
                }
            }
        default:
            break
        }
    }
}
