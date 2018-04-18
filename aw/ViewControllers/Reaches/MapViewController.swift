import CoreData
import UIKit
import MapKit

class MapViewController: UIViewController, MOCViewControllerType {
    @IBOutlet weak var mapView: MKMapView!

    var managedObjectContext: NSManagedObjectContext?

    var fetchedResultsController: NSFetchedResultsController<Reach>?
    var predicates: [NSPredicate] = []
    var difficulties: [Int]?
    var regions: [String]?
    var distance: Float?


    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFetchPredicates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segue.runDetailMap.rawValue:
            prepareDetailSegue(segue)
        case Segue.showFiltersMap.rawValue:
            injectContextAndContainerToNavChildVC(segue: segue)
        default:
            print("Unknown segue \(segue.identifier ?? "unknown identifier")")
        }
    }
}

// MARK: - Extension
extension MapViewController {
    func initialize() {
        setupMapView()

        fetchedResultsController = initializeFetchedResultController()
        fetchedResultsController?.delegate = self
    }

    @objc func reachButtonTapped(sender: UIButton!) {
        performSegue(withIdentifier: Segue.runDetailMap.rawValue, sender: nil)
    }

    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true

        let distance = Double(DefaultsManager.distanceFilter)
        let latitude = DefaultsManager.latitude
        let longitude = DefaultsManager.longitude

        if distance != 0 {
            let scalingFactor = abs( (cos(2 * Double.pi * latitude / 360.0)))
            let span = MKCoordinateSpan(latitudeDelta: distance / 69.0, longitudeDelta: distance/(scalingFactor * 69.0))
            let region = MKCoordinateRegion(center:
                CLLocationCoordinate2D(
                    latitude: latitude, longitude: longitude),
                span: span)
            mapView.setRegion(region, animated: false)
        }
    }

    func prepareDetailSegue(_ segue: UIStoryboardSegue) {
        if let selectedReach = mapView.selectedAnnotations.first as? Reach,
            let context = managedObjectContext {
            let request: NSFetchRequest<Reach> = Reach.fetchRequest()
            request.predicate = NSPredicate(format: "id = %i", selectedReach.id)

            do {
                let reaches = try context.fetch(request)
                if let reach = reaches.first,
                        let detailVC = segue.destination as?   ReachDetailContainerViewController {
                    detailVC.reach = reach
                } else {
                    print("No reach")
                }
            } catch {
                print("Failed to fetch reach \(selectedReach.id)")
            }
        }
        injectContextAndContainerToChildVC(segue: segue)
    }

    func updateFetchPredicates() {
        let difficulties = DefaultsManager.classFilter
        let regions = DefaultsManager.regionsFilter
        let distance = DefaultsManager.distanceFilter

        guard difficulties != self.difficulties || regions != self.regions || distance != self.distance else { return }

        self.difficulties = difficulties
        self.regions = regions
        self.distance = distance

        var combinedPredicates = predicates

        if difficulties.count > 0 {
            combinedPredicates.append(difficultiesPredicate())
        }

        if regions.count > 0 {
            combinedPredicates.append(regionsPredicate())
        }

        if DefaultsManager.distanceFilter > 0 {
            combinedPredicates.append(distancePredicate())
        }

        self.fetchedResultsController?.fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: combinedPredicates)

        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
        mapView.removeAnnotations(mapView.annotations)
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }

        // add the reaches in core data
        if let reaches = fetchedResultsController?.fetchedObjects {
            mapView.addAnnotations(reaches)
        }
    }
}

// MARK: - ReachFetchRequestControllerType
extension MapViewController: ReachFetchRequestControllerType {

}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let reach = annotation as? Reach {
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
        /*} else if let cluster = annotation as? MKClusterAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "cluster")
            }
            view?.annotation = cluster
            return view*/
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
