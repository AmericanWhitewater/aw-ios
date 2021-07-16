//
//  AWProgressModal.swift
//  American Whitewater
//
//  Created by David Nelson on 6/3/20.
//  Copyright © 2020 American Whitewater. All rights reserved.
//

import UIKit
import Foundation

class AWProgressModal {
    
    static let shared = AWProgressModal()
    
    var progressVC: ProgressViewController?
    var fromVC: UIViewController?
    
    private init() {}
    
    func show(fromViewController: UIViewController, message: String?) {
        if let progressVC = progressVC {
            fromViewController.present(progressVC, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.progressVC = storyboard.instantiateViewController(withIdentifier: "ProgressView") as? ProgressViewController
            if let progressVC = self.progressVC {
                progressVC.messageToDisplay = message ?? "Loading..."
                fromViewController.present(progressVC, animated: true, completion: nil)
            }
        }
    }
    
    func hide() {
        progressVC?.dismiss(animated: true, completion: nil)
    }
    
    func hideWith(completion: @escaping ()->()) {
        progressVC?.dismiss(animated: true, completion: completion)
    }
    
}
