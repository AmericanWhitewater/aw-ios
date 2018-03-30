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
    var persistentContainer: NSPersistentContainer?

    var fetchedresultsController: NSFetchedResultsController<Reach>?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segue.runDetailMap.rawValue:
            prepareDetailSegue(segue)
        default:
            print("Unknown segue \(segue.identifier ?? "unknown identifier")")
        }
    }
}

extension MapViewController {
    func initialize() {
        mapView.delegate = self

        guard let moc = managedObjectContext else { return }

        let request = NSFetchRequest<Reach>(entityName: "Reach")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedresultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)

        fetchedresultsController?.delegate = self

        do {
            try fetchedresultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }

        // add the reaches in core data
        if let reaches = fetchedresultsController?.fetchedObjects {
            mapView.addAnnotations(reaches.map { $0.annotation })
        }
    }

    @objc func reachButtonTapped(sender: UIButton!) {
        performSegue(withIdentifier: Segue.runDetailMap.rawValue, sender: nil)
    }

    func prepareDetailSegue(_ segue: UIStoryboardSegue) {
        if let selectedReachAnnotation = mapView.selectedAnnotations.first as? ReachAnnotation,
            let context = managedObjectContext {
            let request: NSFetchRequest<Reach> = Reach.fetchRequest()
            request.predicate = NSPredicate(format: "id = %i", selectedReachAnnotation.id)

            do {
                let reaches = try context.fetch(request)
                if let reach = reaches.first, let destinationVC = segue.destination as? RunDetailTableViewController {
                    destinationVC.reach = reach
                } else {
                    print("No reach")
                }
            } catch {
                print("Failed to fetch reach \(selectedReachAnnotation.id)")
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let reach = annotation as? ReachAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "reach")
            if view == nil {
                view = MKAnnotationView(annotation: nil, reuseIdentifier: "reach")
            }
            view?.annotation = annotation
            view?.canShowCallout = true
            //view?.clusteringIdentifier = "reach"
            // cluster view is causing exc_bad_access crashes
            // see: https://forums.developer.apple.com/thread/92799
            if let icon = reach.icon {
                view?.image = icon
            }
            // change display priority based on current conditions
//            switch reach.condition {
//            case "low", "med", "high":
//                break
//            default:
//                view?.displayPriority = .defaultLow
//            }
            let button = UIButton(type: .detailDisclosure)
            button.addTarget(self, action: #selector(reachButtonTapped), for: .touchUpInside)
            view?.rightCalloutAccessoryView = button
            return view
        } else if let cluster = annotation as? MKClusterAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "cluster")
            }
            view?.annotation = cluster
            return view
        } else {
            // default view for user location and unknown annotations
            return nil
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension MapViewController: NSFetchedResultsControllerDelegate {

    // update reaches as fetched results change (filtering)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let reach = anObject as? Reach else {
            print("not a reach")
            return
        }

        switch type {
        case .insert:
            mapView.addAnnotation(reach.annotation)
        case .delete:
            mapView.removeAnnotation(reach.annotation)
        case .update:
            mapView.removeAnnotation(reach.annotation)
            mapView.addAnnotation(reach.annotation)
        case .move:
            mapView.removeAnnotation(reach.annotation)
            mapView.addAnnotation(reach.annotation)
            print("reach moved: \(reach.name ?? "unknown reach")) - \(reach.section ?? "unknown section")")
        }
    }
}
