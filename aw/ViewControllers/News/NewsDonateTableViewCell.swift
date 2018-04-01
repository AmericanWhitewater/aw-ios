//
//  NewsDonateTableViewCell.swift
//  aw
//
//  Created by Alex Kerney on 4/1/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class NewsDonateTableViewCell: UITableViewCell {
    @IBOutlet weak var donateButton: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func donateTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.americanwhitewater.org/content/Membership/donate")!, options: [:]) { (status) in
            if status {
                print("Opened browser to donate page")
            }
        }
    }
}
