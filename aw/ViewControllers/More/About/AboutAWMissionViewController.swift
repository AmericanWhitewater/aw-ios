//
//  AboutAWMissionViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class AboutAWMissionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func joinMembershipTapped(_ sender: Any) {
        UIApplication.shared.open(
                URL(string: "https://www.americanwhitewater.org/content/Membership/join-aw")!,
                options: [:]) { status in
            if status {
                print("Opened join AW window")
            }
        }
    }
    @IBAction func knowMoreTapped(_ sender: Any) {
    }
}
