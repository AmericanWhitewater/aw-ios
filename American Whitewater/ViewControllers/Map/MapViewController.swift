import UIKit
import MapKit
import CoreData
import GRDB

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var legendContainerView: UIView!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    private lazy var reachUpdater = ReachUpdater()
    
    private var filters: Filters { DefaultsManager.shared.filters }
    
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation? = nil
    
    private var notificationObservers = [NSObjectProtocol]()
    
    private var reaches = [Reach]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        legendContainerView.layer.cornerRadius = legendContainerView.frame.height / 2
        legendContainerView.clipsToBounds = true
        
        mapView.mapType = .hybrid
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        
        updateFilterButton()
        beginObserving()
        
        notificationObservers.append(
            NotificationCenter.default.addObserver(
                forName: .filtersDidChange,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.beginObserving()
            }
        )
    }
    
    deinit {
        // Have to deregister block-based notification observers or they will continue to call their blocks:
        notificationObservers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.isAuthorized {
            showUserLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.showsUserLocation = false
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let newLocation = userLocation.location else {
            return
        }
        
        DefaultsManager.shared.coordinate = newLocation.coordinate
        self.lastLocation = newLocation
    }
    
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        beginObserving()
//    }
    
    func updateFilterButton() {
        navigationItem.rightBarButtonItem?.title = ""

        let imageName = (filters.classFilter.count < 5 || filters.isDistance) ? "filterOn" : "filterOff"
        navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: imageName), for: .normal, barMetrics: .default)
    }
    
    //
    // MARK: - Observation
    //
    
    private var observer: DatabaseCancellable? = nil
    
    func beginObserving() {
        let obs = ValueObservation.tracking { db in
            try Reach
                .all()
//                .geoboxed(rect: self.mapView.visibleMapRect)
            
            // TODO: respect other filters
            
                .fetchAll(db)
        }
        
        observer = obs.start(
            in: DB.shared.pool,
            onError: { error in
                let error = error as NSError
                print("Error fetching reaches for map: \(error), \(error.userInfo)")
                self.showToast(message: "Connection Error: " + error.userInfo.description)
            }, onChange: { reaches in
                self.reaches = reaches
                self.updateAnnotations()
            })
    }
    
    func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = reaches.map { ReachAnnotation($0) }
        mapView.addAnnotations(annotations)
        
//        // Zoom to updated coordinates
//        let cleanedAnnotations = mapView.annotations.filter { $0.coordinate.latitude > 0 && $0.coordinate.longitude > -170 }
//        if cleanedAnnotations.count > 0 {
//            mapView.fitAll(in: cleanedAnnotations, andShow: true)
//        }

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
        guard let annotation = annotation as? ReachAnnotation else { return nil }
                
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
        
        let selectedReach = view.annotation as! ReachAnnotation
        
        performSegue(withIdentifier: Segue.runDetailMap.rawValue, sender: selectedReach)
        
    }
    
    func showUserLocation() {
        mapView.showsUserLocation = true
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
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.isAuthorized {
            showUserLocation()
            
            if let mapView = mapView, mapView.hasLocation {
                mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            }
        } else if CLLocationManager.isDenied {
            present(LocationHelper.locationDeniedAlert(), animated: true)
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

//extension MapViewController: NSFetchedResultsControllerDelegate {
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//
//        guard let reach = anObject as? Reach, let mapView = mapView else { return }
//
//        switch type {
//            case .insert:
//                mapView.addAnnotation(reach)
//            case .delete:
//                mapView.removeAnnotation(reach)
//            case .update:
//                mapView.removeAnnotation(reach)
//                mapView.addAnnotation(reach)
//            case .move:
//                mapView.removeAnnotation(reach)
//                mapView.addAnnotation(reach)
//                print("reach moved: \(reach.name ?? "unknown reach")) - \(reach.section ?? "unknown section")")
//            default:
//                break
//        }
//    }
//}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            showUserLocation()
        }
    }
}

extension DerivableRequest where RowDecoder == Reach {
    func geoboxed(rect: MKMapRect) -> Self {
        let origin = rect.origin.coordinate
        let maxPt = MKMapPoint(x: rect.maxX, y: rect.maxY).coordinate
        
        // TODO: could check putIn OR takeOut in box
        return filter(
            Reach.Columns.putInLat >= min(origin.latitude, maxPt.latitude) &&
            Reach.Columns.putInLon >= min(origin.longitude, maxPt.longitude) &&
            Reach.Columns.putInLat <= max(origin.latitude, maxPt.latitude) &&
            Reach.Columns.putInLon >= max(origin.longitude, maxPt.longitude)
        )
    }
}
