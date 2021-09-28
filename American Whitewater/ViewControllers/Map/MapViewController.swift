import UIKit
import MapKit
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.isAuthorized {
            showUserLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Stop observing DB:
        observer = nil
        
        notificationObservers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
        
        mapView.showsUserLocation = false
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let newLocation = userLocation.location else {
            return
        }
        
        DefaultsManager.shared.coordinate = newLocation.coordinate
        self.lastLocation = newLocation
    }

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
                .filter(
                    by: self.filters,
                    from: (self.lastLocation ?? DefaultsManager.shared.location).coordinate
                )
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
        
        let annotations = reaches
            .filter { $0.putIn != nil }
            .map { ReachAnnotation($0) }
        
        mapView.addAnnotations(annotations)
        
        // Zoom to updated annotations
        mapView.fitAll(in: annotations, andShow: true)
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
        guard let annotation = view.annotation as? ReachAnnotation else {
            return
        }
        
        performSegue(withIdentifier: Segue.runDetailMap.rawValue, sender: annotation.reach)
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

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            showUserLocation()
        }
    }
}
