import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var legendContainerView: UIView!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Reach>?
    
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        legendContainerView.layer.cornerRadius = legendContainerView.frame.height / 2
        legendContainerView.clipsToBounds = true
        
        mapView.mapType = .hybrid
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        self.locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateFilterButton();
        fetchReachesFromCoreData()
        
        if Location.shared.checkLocationStatusInBackground(manager: locationManager) {
            showUserLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.showsUserLocation = false
        
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let newLocation = userLocation.location else {
            return
        }
        
        // Do nothing if new location is close to old location
        if let lastLocation = lastLocation, lastLocation.distance(from: newLocation) < 100 {
            print("Last Location Distance to new location: \(lastLocation.distance(from: newLocation))")
            return
        }
        
        // check if we need to update distances
        if newLocation.coordinate.hasChanged(from: DefaultsManager.shared.coordinate, byMoreThan: 0.01) {
            print("Updating distances of reaches")
            
            AWApiReachHelper.shared.updateAllReachDistances(callback: {
                self.fetchReachesFromCoreData();
            })
        }
        
        DefaultsManager.shared.coordinate = newLocation.coordinate
        self.lastLocation = newLocation
    }
    
    func updateFilterButton() {
        navigationItem.rightBarButtonItem?.title = ""
        if DefaultsManager.shared.classFilter.count < 5 || DefaultsManager.shared.showDistanceFilter == true {
            navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "filterOn"), for: .normal, barMetrics: .default)
        } else {
            navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "filterOff"), for: .normal, barMetrics: .default)
        }
    }
    
    func fetchReachesFromCoreData() {
        print("Fetching reaches")
        let request = Reach.reachFetchRequest() as NSFetchRequest<Reach>
        
        // setup sort filters
        request.sortDescriptors = [
            NSSortDescriptor(key: "distance", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        // based on our filtering settings (distance, region, or class) we request Reaches that
        // match these settings
        let combinedPredicates: [NSPredicate] = filterPredicates().compactMap { $0 }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: combinedPredicates)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                      managedObjectContext: managedObjectContext,
                                                        sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("Error fetching reaches for map: \(error), \(error.userInfo)")
            self.showToast(message: "Connection Error: " + error.userInfo.description)
        }
        
        // add the reaches from core data to the map
        if let reaches = fetchedResultsController?.fetchedObjects {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(reaches)
            
            // Zoom to updated coordinates
            let cleanedAnnotations = mapView.annotations.filter { $0.coordinate.latitude > 0 && $0.coordinate.longitude > -170 }
            if cleanedAnnotations.count > 0 {
                mapView.fitAll(in: cleanedAnnotations, andShow: true)
            }
        }
    }

    func mapViewChangedFromUserInteraction() -> Bool {
        if let view = self.mapView.subviews.first, let gestureRecogs = view.gestureRecognizers {
            for recog in gestureRecogs {
                if recog.state == UIGestureRecognizer.State.began || recog.state == UIGestureRecognizer.State.ended {
                    return true
                }
            }
        }
        
        return false
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Reach else { return nil }
                
        var view:MKAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "ReachAnnotation") { //as? MKAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "ReachAnnotation")
            
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        //view.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: annotation.imageName)
        
        return view
    }
    
    // User Clicked on the info of a callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let selectedReach = view.annotation as! Reach
        
        performSegue(withIdentifier: Segue.runDetailMap.rawValue, sender: selectedReach)
        
    }
    
    func showUserLocation() {
        mapView.showsUserLocation = true
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            showUserLocation()
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Segue.showFiltersMap.rawValue, sender: nil)
    }
    
    @IBAction func mapTypeButtonPressed(_ sender: Any) {
        if mapView.mapType == .standard {
            mapView.mapType = .hybrid
        } else {
            mapView.mapType = .standard
        }
    }
    
    @IBAction func showUserLocationPressed(_ sender: Any) {
        if Location.shared.checkLocationStatusOnUserAction(manager: locationManager) {
            showUserLocation()
            
            if let mapView = mapView {
                if Location.shared.hasLocation(mapView: mapView) {
                    mapView.setCenter(mapView.userLocation.coordinate, animated: true)
                }
            }
        }
    }
    
    // MARK: - Filtering Predicates
    
    func difficultiesPredicate() -> NSCompoundPredicate? {
    
        var classPredicates: [NSPredicate] = []

        for difficulty in DefaultsManager.shared.classFilter {
            classPredicates.append(NSPredicate(format: "difficulty\(difficulty) == TRUE"))
        }

        if classPredicates.count == 0 {
            return nil
        }

        return NSCompoundPredicate(orPredicateWithSubpredicates: classPredicates)
    }
    
    func regionsPredicate() -> NSPredicate? {
        // if we are filtering by distance then ignore regions
        if DefaultsManager.shared.showDistanceFilter {
            return nil
        }
        
        let regionCodes = DefaultsManager.shared.regionsFilter
        var states:[String] = []
        for regionCode in regionCodes {
            if let region = Region.regionByCode(code: regionCode) {
                states.append(region.apiResponse)
            }
        }

        if states.count == 0 {
            return nil
        }
        return NSPredicate(format: "state IN[cd] %@", states)
    }

    func distancePredicate() -> NSPredicate? {
        // check if user is using the distance filter or if
        // they have turned it off
        if !DefaultsManager.shared.showDistanceFilter { return nil }
        
        let distance = DefaultsManager.shared.distanceFilter
        if distance == 0 { return nil }
        let predicates: [NSPredicate] = [
            NSPredicate(format: "distance <= %lf", distance),
            NSPredicate(format: "distance != 0")] // hide invalid distances
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    func filterPredicates() -> [NSPredicate?] {
        if DefaultsManager.shared.showDistanceFilter == true {
            return [distancePredicate()]
        } else {
            return [regionsPredicate()]
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let reach = sender as? Reach {
            if segue.identifier == Segue.runDetailMap.rawValue {
                let detailVC = segue.destination as! RunDetailTableViewController
                detailVC.selectedRun = reach
            }
        }
        
    }
}

extension MapViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        guard let reach = anObject as? Reach, let mapView = mapView else { return }

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
            default:
                break
        }
    }
}
