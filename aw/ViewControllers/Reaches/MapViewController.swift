import CoreData
import UIKit
import MapKit

class MapViewController: UIViewController, MOCViewControllerType {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterButton: UIBarButtonItem?

    var managedObjectContext: NSManagedObjectContext?

    var fetchedResultsController: NSFetchedResultsController<Reach>?
    var predicates: [NSPredicate] = [NSPredicate(format: "putInLat != nil"), NSPredicate(format: "putInLon != nil")]
    var difficulties: [Int]?
    var regions: [String]?
    var distance: Float?
    var zoom = true


    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFilterButton()
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

        let keyView = MapKeyView(pointTypes: [
            (UIImage(named: "runnablePin"), "Runnable"),
            (UIImage(named: "lowPin"), "Low"),
            (UIImage(named: "highPin"), "High"),
            (UIImage(named: "noinfoPin"), "No info")
            ])
        view.addSubview(keyView)
        NSLayoutConstraint.activate([
            keyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            keyView.heightAnchor.constraint(equalToConstant: 45)])
    }

    @objc func reachButtonTapped(sender: UIButton!) {
        performSegue(withIdentifier: Segue.runDetailMap.rawValue, sender: nil)
    }

    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
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

        if regions != self.regions || distance != self.distance {
            zoom = true
        }

        self.difficulties = difficulties
        self.regions = regions
        self.distance = distance

        let combinedPredicates = predicates + [
            difficultiesPredicate(), regionsPredicate(), distancePredicate()].compactMap { $0 }

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
            if zoom {
                mapView.showAnnotations(reaches, animated: true)
                zoom = false
            }
        }
    }

    func updateFilterButton() {
        guard let filterButton = filterButton else {
            return
        }
        if DefaultsManager.classFilter.count > 0 || DefaultsManager.regionsFilter.count > 0 || DefaultsManager.distanceFilter > 0 {
            filterButton.image = UIImage(named: "filterOn")
        } else {
            filterButton.image = UIImage(named: "filterOff")
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
            if let icon = reach.icon {
                view?.image = icon
            }
            return view
        } else {
            // default view for user location and unknown annotations
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let reach = view.annotation as? Reach else {
            return
        }

        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(reachButtonTapped), for: .touchUpInside)
        view.rightCalloutAccessoryView = button

        let subtitle = UILabel()
        subtitle.text = reach.section
        subtitle.apply(style: .Text2)

        let runnableClass = UILabel()
        runnableClass.text = reach.runnableClass
        runnableClass.apply(style: .Label1)
        runnableClass.textColor = reach.color

        let stack = UIStackView(arrangedSubviews: [subtitle, runnableClass])
        stack.axis = .vertical

        view.detailCalloutAccessoryView = stack
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard view.annotation is Reach else {
            return
        }

        view.rightCalloutAccessoryView = nil
        view.detailCalloutAccessoryView = nil
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
