import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class RunMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var mapTypeButton: UIButton!
    @IBOutlet weak var mapLegendViewContainer: UIView!
    @IBOutlet weak var viewSegmentControl: UISegmentedControl!
    
    var selectedRun: Reach?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        
        let selectedSegTitle = [NSAttributedString.Key.foregroundColor: UIColor(named: "primary") ?? UIColor.black]
                                       as [NSAttributedString.Key : Any]
        viewSegmentControl.setTitleTextAttributes(selectedSegTitle, for: .selected)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // check location permissions so we can show
        // user location on request
        checkLocationAuthorizationStatus()
        
        // setup all map markers/annotation
        processMapMarkers()
    }
    
    private func processMapMarkers() {
        
        // remove all annotations because we are resetting them
        mapView.removeAnnotations(mapView.annotations)
        
        if let selectedRun = selectedRun {
            // add putin marker if we have data for it
            if let putinLat = Double( selectedRun.putInLat ?? "" ), let putinLon = Double( selectedRun.putInLon ?? "")  {
                let putinCoordinate = CLLocationCoordinate2D(latitude: putinLat, longitude: putinLon)
                let putinAnnotation = RunMapAnnotation(title: "Put-In", sectionSubtitle: "", coordinate: putinCoordinate, reach: selectedRun)
                mapView.addAnnotation(putinAnnotation)
            }
            
            // add take out marker if we have data for it
            if let takeoutLat = Double( selectedRun.takeOutLat ?? "" ), let takeoutLon = Double( selectedRun.takeOutLon ?? "") {
                let takeoutCoordinate = CLLocationCoordinate2D(latitude: takeoutLat, longitude: takeoutLon)
                let takeoutAnnotation = RunMapAnnotation(title: "Take-Out", sectionSubtitle: "", coordinate: takeoutCoordinate, reach: selectedRun)
                mapView.addAnnotation(takeoutAnnotation)
            }

            // Handle rapid annotations - got to get them pulled in the DB first
            guard let rapids = selectedRun.rapids else { print("no rapids to process"); return }
            
            for rapid in rapids {
                
                if let rapid = rapid as? Rapid, rapid.lat != 0, rapid.lon != 0 {
                    
                    var subtitle = (rapid.difficulty?.count ?? 0) > 0 ? "Class \(rapid.difficulty ?? "n/a"): " : ""
                    if rapid.isHazard {
                        subtitle = "\(subtitle) - Hazard, Use Caution!"
                    } else {
                        subtitle = "\(subtitle)\(rapid.isPlaySpot ? "Play Spot" : "Rapid")"
                    }
                    
                    let annotation = RunMapAnnotation(
                        title: rapid.name ?? "",
                        sectionSubtitle: subtitle,
                        coordinate: CLLocationCoordinate2D(latitude: rapid.lat, longitude: rapid.lon),
                        reach: rapid.reach
                    )
                    
                    mapView.addAnnotation(annotation)
                }
            }
            
            // set the bounding region to the putin and take out
            mapView.showAnnotations(mapView.annotations, animated: false)
        }
        
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
        
        //DuffekDialog.shared.showOkDialog(title: "Rapid Info", message: "Info coming soon...")
        if let annotation = view.annotation as? RunMapAnnotation {

            // check if putin or take out, if so open in apple maps (ask first?)
            if annotation.title?.lowercased().contains("Put-In".lowercased()) == true ||
               annotation.title?.lowercased().contains("Take-Out".lowercased()) == true {
                
                print("opening in maps")
                DuffekDialog.shared.showStandardDialog(title: "Open in Maps?", message: "Would you like directions to the \(annotation.title ?? "River")", buttonTitle: "Get Directions", buttonFunction: {
                    // take them to Apple Maps
                    let url = "http://maps.apple.com/maps?saddr=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
                    UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)

                }, cancelFunction: {
                    // handle cancel
                })
            
            } else {
                
                // open detail view
                guard let rapids = annotation.reach?.rapids else { return }

                let rapidMatch = rapids.filter {
                    if let rapid = $0 as? Rapid {
                        return rapid.name == annotation.title
                    } else {
                        return false
                    }
                }

                if let rapid = rapidMatch.first {
                    performSegue(withIdentifier: "mapRapidDetails", sender: rapid)
                }
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let userLat = userLocation.coordinate.latitude
        let userLon = userLocation.coordinate.longitude
        
        //print("Location difference is: Map: \(userLat) - DefLat: \(DefaultsManager.latitude) = \(abs(userLat - DefaultsManager.latitude)) x \(userLon) - \(DefaultsManager.longitude) = \(abs(userLon - DefaultsManager.longitude))")
        
        // check if we need to update locations
        if abs(userLat - DefaultsManager.latitude) > 0.01 ||
            abs(userLon - DefaultsManager.longitude) > 0.01 {
            print("Updating distances of reaches")
            
            DefaultsManager.latitude = userLat
            DefaultsManager.longitude = userLon
        }

        self.mapView.setVisibleMapRectToFitAllAnnotations(animated: true, shouldIncludeUserAccuracyRange: true, shouldIncludeOverlays: true)
    }
    
    
    func showUserLocation() {
        mapView.showsUserLocation = true
        
        self.mapView.setVisibleMapRectToFitAllAnnotations(animated: true, shouldIncludeUserAccuracyRange: true, shouldIncludeOverlays: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // it's approved - button will now work
            return
        } else if CLLocationManager.authorizationStatus() == .denied {
            showLocationDeniedMessage()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse:
                //showUserLocation()
                break
            case .authorizedAlways:
                // showUserLocation()
                break
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
    
    
    @IBAction func mapTypeButtonPressed(_ sender: Any) {
        if mapView.mapType == .standard {
            mapView.mapType = .hybrid
        } else {
            mapView.mapType = .standard
        }
    }
    
    @IBAction func showUserLocationPressed(_ sender: Any) {
        showUserLocation()
        
        if let mapView = mapView {
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
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
