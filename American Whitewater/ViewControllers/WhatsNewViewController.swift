//
//  WhatsNewViewController.swift
//  American Whitewater
//
//  Created by David Nelson on 6/9/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit

class WhatsNewViewController: UIViewController {

    @IBOutlet weak var dontShowAgainButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dontShowAgainButtonPressed(_ sender: Any) {
        
        DefaultsManager.shared.whatsNew = "whatsNew\(DefaultsManager.shared.appVersion ?? -1)"
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
