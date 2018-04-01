//
//  AboutAWFundingViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class AboutAWFundingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func donateNowTapped(_ sender: Any) {
        UIApplication.shared.open(
            URL(string: "https://www.americanwhitewater.org/content/Membership/donate")!,
            options: [:]) { status in
                if status {
                    print("Opened join AW browser")
                }
        }
    }

    @IBAction func joinMembershipTapped(_ sender: Any) {
        UIApplication.shared.open(
            URL(string: "https://www.americanwhitewater.org/content/Membership/join-aw")!,
            options: [:]) { status in
                if status {
                    print("Opened AW Mission browser")
                }
        }
    }
}
