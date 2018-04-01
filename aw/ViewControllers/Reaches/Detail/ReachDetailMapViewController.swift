//
//  ReachDetailMapViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/31/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import MapKit
import UIKit

class ReachDetailMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var managedObjectContext: NSManagedObjectContext?
    var reach: Reach?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMap()
    }
}

// MARK: - Extension
extension ReachDetailMapViewController {
    func initialize() {
        mapView.mapType = .hybrid
        mapView.delegate = self
    }

    func setupMap() {
        mapView.showsUserLocation = true
        if let reach = reach {
            if let lat = reach.putInLat,
                let latitude = Double(lat),
                let lon = reach.putInLon,
                let longitude = Double(lon) {
                let annotation = RunAnnotation(latitude: latitude, longitude: longitude, title: "Put In")
                mapView.addAnnotation(annotation)
            }

            if let lat = reach.takeOutLat,
                let latitude = Double(lat),
                let lon = reach.takeOutLon,
                let longitude = Double(lon) {
                let annotation = RunAnnotation(latitude: latitude, longitude: longitude, title: "Take Out")
                mapView.addAnnotation(annotation)
            }
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
}

// MARK: - MOCViewControllerType
extension ReachDetailMapViewController: MOCViewControllerType {
}

// MARK: - RunDetailViewControllerType
extension ReachDetailMapViewController: RunDetailViewControllerType {

}

// MARK: - MapViewDelegate
extension ReachDetailMapViewController: MKMapViewDelegate {

}
