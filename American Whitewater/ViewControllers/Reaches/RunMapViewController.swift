import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import GRDB

class RunMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var mapTypeButton: UIButton!
    @IBOutlet weak var mapLegendViewContainer: UIView!
    @IBOutlet weak var viewSegmentControl: UISegmentedControl!
    
    /// The ID of the reach to display
    var reachId: Int?
    
    /// The fetched reach, updated on change
    private var reach: Reach?
    
    /// The fetched rapids, updated on change
    private var rapids = [Rapid]()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        
        viewSegmentControl.setTitleTextAttributes(
            [.foregroundColor: UIColor(named: "primary") ?? UIColor.black],
            for: .selected
        )
        
        // set button styling to match our rounded corners like all
        // other buttons - also round the legend container view
        mapTypeButton.layer.cornerRadius = mapTypeButton.frame.height/2
        mapTypeButton.clipsToBounds = true
        
        mapLegendViewContainer.layer.cornerRadius = mapLegendViewContainer.frame.height/2
        mapLegendViewContainer.clipsToBounds = true
        
        userLocationButton.layer.cornerRadius = userLocationButton.frame.height/2
        userLocationButton.clipsToBounds = true
        
        // setup initial map styling
        mapView.mapType = .hybrid
        mapView.delegate = self
        
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        beginObserving()
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
        
        observer = nil
    }
    
    //
    // MARK: - Observation
    //
    
    private var observer: DatabaseCancellable? = nil
    
    private func beginObserving() {
        guard let id = reachId else {
            return
        }
        
        let obs = ValueObservation.tracking { db in
            (
                try Reach.fetchOne(db, id: id),
                try Rapid.filter(Rapid.Columns.reachId == id).fetchAll(db)
            )
        }
        
        observer = obs.start(
            in: DB.shared.pool,
            onError: { error in
                // TODO handle error
            }, onChange: { (reach, rapids) in
                self.reach = reach
                self.rapids = rapids
                self.processMapMarkers()
            }
        )
    }
    
    private func processMapMarkers() {
        // remove all annotations because we are resetting them
        mapView.removeAnnotations(mapView.annotations)
        
        guard let reach = reach else {
            return
        }
        
        // Putin/takeout annotations:
        
        if let putIn = reach.putIn?.coordinate {
            mapView.addAnnotation(RunMapAnnotation(
                kind: .putin,
                title: "Put-In",
                sectionSubtitle: "",
                coordinate: putIn
            ))
        }
        
        if let takeOut = reach.takeOut?.coordinate {
            mapView.addAnnotation(RunMapAnnotation(
                kind: .takeout,
                title: "Take-Out",
                sectionSubtitle: "",
                coordinate: takeOut
            ))
        }
        
        // Rapid annotations:
        for rapid in rapids {
            guard let loc = rapid.location else {
                continue
            }
            
            let annotation = RunMapAnnotation(
                kind: .rapid(rapid),
                title: rapid.name ?? "",
                sectionSubtitle: rapid.subtitle,
                coordinate: loc.coordinate
            )
            
            mapView.addAnnotation(annotation)
        }
            
        // set the bounding region to the put in and take out
        let annotations = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.showAnnotations(annotations, animated: false)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RunMapAnnotation else { return nil }

        var view:MKAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "RunAnnotation") {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "RunAnnotation")
            
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        //view.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: annotation.imageName)
        print("Displaying with: \(annotation.imageName)")
        
        return view
    }
    
    // User Clicked on the info of a callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? RunMapAnnotation else {
            return
        }

        // check if put in or take out, if so open in apple maps (ask first?)
        switch annotation.kind {
        case .putin, .takeout:
            let alert = UIAlertController(
                title: "Open in Maps?",
                message: "Would you like directions to the \(annotation.title ?? "River")",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "Get Directions", style: .default, handler: { _ in
                // take them to Apple Maps
                let url = "http://maps.apple.com/maps?daddr=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        case .rapid(let rapid):
            // open detail view
            performSegue(withIdentifier: "mapRapidDetails", sender: rapid)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let userCoord = userLocation.coordinate
        
        // check if we need to update locations
        if userCoord.hasChanged(from: DefaultsManager.shared.coordinate, byMoreThan: 0.01) {
            print("Updating distances of reaches")
        
            // FIXME: this doesn't actually update reach distances. Should it?
        }
        
        DefaultsManager.shared.coordinate = userCoord
    }
    
    func showUserLocation() {
        mapView.showsUserLocation = true
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
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Segue.mapRapidDetails.rawValue {
            let destVC = segue.destination as! RunRapidDetailsTableViewController
            destVC.selectedRapid = sender as? Rapid
        }
    }
}

extension RunMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            showUserLocation()
        }
    }
}
