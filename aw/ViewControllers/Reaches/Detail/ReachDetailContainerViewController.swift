//
//  ReachDetailContainerViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/31/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

enum SubViews {
    case detail, map
}

class ReachDetailContainerViewController: UIViewController {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mapView: UIView!

    var managedObjectContext: NSManagedObjectContext?
    var reach: Reach?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRightItems()
    }
}

extension ReachDetailContainerViewController {
    func initialize() {
        initializeChildVCs()
        setupSegmentedControl()

        showView(name: .detail)
    }

    func initializeChildVCs() {
        for childVC in childViewControllers {
            print("childVC")
            if var childVC = childVC as? RunDetailViewControllerType {
                childVC.reach = reach
            }
            if var childVC = childVC as? MOCViewControllerType {
                childVC.managedObjectContext = managedObjectContext
            }
        }
    }

    func setupRightItems() {
        guard let reach = reach else { return }
        let favoriteButton = UIBarButtonItem(
            image: reach.favorite ? UIImage(named: "icon_favorite_selected") : UIImage(named: "icon_favorite"),
            style: .plain,
            target: self,
            action: #selector(tapFavoriteIcon))
        let shareButton = UIBarButtonItem(
            image: UIImage(named: "share"),
            style: .plain,
            target: self,
            action: #selector(tapShareIcon))

        self.navigationItem.rightBarButtonItems = [shareButton, favoriteButton]
    }

    func setupSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["Details", "Map"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
    }

    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            showView(name: .map)
        } else {
            showView(name: .detail)
        }
    }

    func showView(name: SubViews) {
        switch name {
        case .map:
            detailView.isHidden = true
            mapView.isHidden = false
        default:
            detailView.isHidden = false
            mapView.isHidden = true
        }
    }

    @objc func tapFavoriteIcon(_ sender: Any) {
        guard let reach = reach, let context = managedObjectContext else { return }

        context.persist {
            reach.favorite = !reach.favorite
            self.setupRightItems()
        }
    }

    @objc func tapShareIcon(_ sender: Any) {
        share(sender)
    }

    func share(_ sender: Any?) {
        guard let reach = reach,
            let section = reach.section,
            let name = reach.name,
            let url = reach.url else { return }

        let title: String
        if reach.runnable.count > 0 {
            title = "\( section) of \( name ) is \( reach.runnable )"
        } else {
            title = "\( section ) of \( name )"
        }
        let activityController = UIActivityViewController(activityItems: [title, url], applicationActivities: nil)
        if let sender = sender as? UIView {
            activityController.popoverPresentationController?.sourceView = sender
        }


        present(activityController, animated: true, completion: nil)
    }
}

extension ReachDetailContainerViewController: MOCViewControllerType {

}
