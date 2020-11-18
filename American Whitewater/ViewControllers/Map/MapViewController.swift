
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
    
     var predicates: [NSPredicate] = []
    
    let locationManager = CLLocationManager()
    
    var lastLocation: CLLocation? = nil
    
    public static var userChangedMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        legendContainerView.layer.cornerRadius = legendContainerView.frame.height / 2
        legendContainerView.clipsToBounds = true
        
        mapView.mapType = .hybrid
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateFilterButton();
        checkLocationAuthorizationStatus()
        fetchReachesFromCoreData()
        
        if DefaultsManager.showRegionFilter {
            mapView.showsUserLocation = false
        } else {
            mapView.showsUserLocation = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.showsUserLocation = false
        
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let userLat = userLocation.coordinate.latitude
        let userLon = userLocation.coordinate.longitude
        
        if lastLocation != nil {
            if let lastLocation = lastLocation, let newLocation = userLocation.location {
                print("Last Location Distance to new location: \(lastLocation.distance(from: newLocation))")
                if (lastLocation.distance(from: newLocation) < 100) {
                   return
               }
           }
        }
        
        print("Location difference is: Map: \(userLat) - DefLat: \(DefaultsManager.latitude) = \(abs(userLat - DefaultsManager.latitude)) x \(userLon) - \(DefaultsManager.longitude) = \(abs(userLon - DefaultsManager.longitude))")
        
        // check if we need to update locations
        if abs(userLat - DefaultsManager.latitude) > 0.01 ||
            abs(userLon - DefaultsManager.longitude) > 0.01 {
            print("Updating distances of reaches")
            
            DefaultsManager.latitude = userLat
            DefaultsManager.longitude = userLon
            
            AWApiReachHelper.shared.updateAllReachDistances(callback: {
                self.fetchReachesFromCoreData();
            })
        }
        
        if (DefaultsManager.showDistanceFilter == true) {
            // this set the map to show the region around the users location
            let regionRadius: CLLocationDistance = 100000 // this is used to build a bounding box around the users location
            let coordinateRegion = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            self.mapView.setRegion(coordinateRegion, animated: true)
            
        } else {
            // This just shows the region without the users location automatically selected
            print("mapView annotations: \(mapView.annotations.count)")
            // some reaches may have invalid coordinates (i.e. -180) we need to skip those
            let cleanedAnnotations = mapView.annotations.filter { $0.coordinate.latitude > 0 && $0.coordinate.longitude > -170 }
            if MapViewController.userChangedMap == false {
                mapView.fitAll(in: cleanedAnnotations, andShow: true)
            } else {
                mapView.addAnnotations(cleanedAnnotations)
            }
        }
        
        self.lastLocation = userLocation.location!
    }
    
    func updateFilterButton() {
        navigationItem.rightBarButtonItem?.title = ""
        if DefaultsManager.classFilter.count < 5 || DefaultsManager.showDistanceFilter == true {
            navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "filterOn"), for: .normal, barMetrics: .default)
        } else {
            navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "filterOff"), for: .normal, barMetrics: .default)
        }
    }
    
    func fetchReachesFromCoreData() {
        print("Fetching reaches")
        let request = Reach.fetchRequest() as NSFetchRequest<Reach>
        
        // setup sort filters
        request.sortDescriptors = [
            NSSortDescriptor(key: "distance", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        // based on our filtering settings (distance, region, or class) we request Reaches that
        // match these settings
        let combinedPredicates: [NSPredicate] = filterPredicates().compactMap { $0 } + predicates
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
            DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.userInfo.description)
        }
        
        // add the reaches from core data to the map
        if let reaches = fetchedResultsController?.fetchedObjects {
            mapView.removeAnnotations(mapView.annotations)

            mapView.addAnnotations(reaches)
            
            // update the zoom if we're not using location
            if DefaultsManager.showDistanceFilter == false {
                let cleanedAnnotations = mapView.annotations.filter { $0.coordinate.latitude > 0 && $0.coordinate.longitude > -170 }
                if MapViewController.userChangedMap == false {
                    mapView.fitAll(in: cleanedAnnotations, andShow: true)
                } else {
                    mapView.addAnnotations(cleanedAnnotations)
                }
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapViewChangedFromUserInteraction() {
            MapViewController.userChangedMap = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if mapViewChangedFromUserInteraction() {
            MapViewController.userChangedMap = true
        }
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
        if DefaultsManager.showRegionFilter {
            mapView.showsUserLocation = false
        } else {
            mapView.showsUserLocation = true
            MapViewController.userChangedMap = false
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            showUserLocation()
        } else if CLLocationManager.authorizationStatus() == .denied {
            showLocationDeniedMessage()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse:
                showUserLocation()
            case .authorizedAlways:
                showUserLocation()
            case .denied:
                showLocationDeniedMessage()
            default:
                break
        }
    }
    
    func showLocationDeniedMessage() {
        DuffekDialog.shared.showStandardDialog(title: "Permission Denied", message: "You chose to deny this app location permissions and we are unable to use your current location for displaying the map. Please update your settings and try again.", buttonTitle: "Change Settings", buttonFunction: {
            
            // take user to change their settings
            if let bundleId = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }, cancelFunction: {})
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
        if let mapView = mapView {
            mapView.showsUserLocation = true
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
    }
    
    // MARK: - Filtering Predicates
    
    func difficultiesPredicate() -> NSCompoundPredicate? {
    
        var classPredicates: [NSPredicate] = []

        for difficulty in DefaultsManager.classFilter {
            classPredicates.append(NSPredicate(format: "difficulty\(difficulty) == TRUE"))
        }

        if classPredicates.count == 0 {
            return nil
        }

        return NSCompoundPredicate(orPredicateWithSubpredicates: classPredicates)
    }
    
    func regionsPredicate() -> NSPredicate? {
        // if we are filtering by distance then ignore regions
        if DefaultsManager.showDistanceFilter {
            return nil
        }
        
        let regionCodes = DefaultsManager.regionsFilter
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
        if !DefaultsManager.showDistanceFilter { return nil }
        
        let distance = DefaultsManager.distanceFilter
        if distance == 0 { return nil }
        let predicates: [NSPredicate] = [
            NSPredicate(format: "distance <= %lf", distance),
            NSPredicate(format: "distance != 0")] // hide invalid distances
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    func filterPredicates() -> [NSPredicate?] {
        if DefaultsManager.showDistanceFilter == true {
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
