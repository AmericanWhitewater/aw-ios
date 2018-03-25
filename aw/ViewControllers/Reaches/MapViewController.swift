//
//  MapViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit
import MapKit

class MapViewController: UIViewController, MOCViewControllerType {
    @IBOutlet weak var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext?
    var fetchedresultsController: NSFetchedResultsController<Reach>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

extension MapViewController {
    func initialize() {
        print("initilize")
        mapView.delegate = self
        
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        managedObjectContext = container.viewContext
        
        guard let moc = managedObjectContext else { return }
        
        let request = NSFetchRequest<Reach>(entityName: "Reach")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedresultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedresultsController?.delegate = self
        
        do {
            try fetchedresultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
        
        // add the reaches in core data
        if let reaches = fetchedresultsController?.fetchedObjects {
            mapView.addAnnotations(reaches)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension MapViewController: NSFetchedResultsControllerDelegate {

    // update reaches as fetched results change (filtering)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let reach = anObject as? Reach else {
            print("not a reach")
            return
        }
        
        switch type {
        case .insert:
            mapView.addAnnotation(reach)
        case .delete:
            mapView.removeAnnotation(reach)
        case .update:
            mapView.removeAnnotation(reach)
            mapView.addAnnotation(reach)
        case .move:
            mapView.removeAnnotation(reach)
            mapView.addAnnotation(reach)
            print("reach moved: \(reach.name ?? "unknown reach")) - \(reach.section ?? "unknown section")")
        }
    }
}


