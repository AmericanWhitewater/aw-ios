//
//  RunDetailTableViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class RunDetailTableViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var gradientLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!

    var reach: Reach?

    override func viewDidLoad() {
        super.viewDidLoad()

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

        guard let reach = reach else { return }
        nameLabel.text = reach.name
        sectionLabel.text = reach.section
        difficultyLabel.text = reach.difficulty

        guard let reading = reach.lastGageReading, let unit = reach.unit else { return }
        readingLabel.text = reading
        readingLabel.textColor = reach.color
        unitsLabel.text = unit
    }
}
