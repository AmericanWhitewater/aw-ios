import CoreData
import MapKit
import UIKit

class ReachDetailMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var managedObjectContext: NSManagedObjectContext?
    var reach: Reach?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMap()
    }

    @objc func showDirections(sender: UIButton) {
        guard let annotation = mapView.selectedAnnotations.first as? RunAnnotation,
            let reach = reach
            else { return }

        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        mapItem.name = "\(reach.name ?? "") \(annotation.title ?? "")"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// MARK: - Extension
extension ReachDetailMapViewController {
    func initialize() {
        mapView.mapType = .hybrid
        mapView.delegate = self

        let keyView = UIView()
        keyView.backgroundColor = UIColor.white
        keyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyView)
        NSLayoutConstraint.activate([
            keyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            keyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            keyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            keyView.heightAnchor.constraint(equalToConstant: 45)
            ])
        keyView.layer.cornerRadius = 45 / 2
        keyView.layer.masksToBounds = true
    }

    func setupMap() {
        mapView.showsUserLocation = true
        setupAnnotations()
    }

    func setupAnnotations() {
        if let reach = reach {
            if let lat = reach.putInLat,
                let latitude = Double(lat),
                let lon = reach.putInLon,
                let longitude = Double(lon) {
                let annotation = RunAnnotation(
                    latitude: latitude,
                    longitude: longitude,
                    title: "Put In",
                    subtitle: reach.sectionCleanedHTML,
                    type: .putIn)
                mapView.addAnnotation(annotation)
            }

            if let lat = reach.takeOutLat,
                let latitude = Double(lat),
                let lon = reach.takeOutLon,
                let longitude = Double(lon) {
                let annotation = RunAnnotation(
                    latitude: latitude,
                    longitude: longitude,
                    title: "Take Out",
                    subtitle: reach.sectionCleanedHTML,
                    type: .takeOut)
                mapView.addAnnotation(annotation)
            }
            if let rapids = reach.rapids {
                for rapid in rapids {
                    if let rapid = rapid as? Rapid, rapid.lat != 0, rapid.lon != 0 {
                        let annotation = RunAnnotation(
                            latitude: rapid.lat,
                            longitude: rapid.lon,
                            title: "\(rapid.name ?? "") \(rapid.difficulty ?? "")",
                            subtitle: nil,
                            type: .rapid)
                        mapView.addAnnotation(annotation)
                    }
                }
            }
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }

    func reloadAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        setupAnnotations()
    }
}

// MARK: - MOCViewControllerType
extension ReachDetailMapViewController: MOCViewControllerType {
}

// MARK: - RunDetailViewControllerType
extension ReachDetailMapViewController: RunDetailViewControllerType {

}

// MARK: - MapViewDelegate
extension ReachDetailMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let point = annotation as? RunAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "point")
            if view == nil {
                view = MKAnnotationView(annotation: nil, reuseIdentifier: "point")
            }
            view?.canShowCallout = true
            view?.annotation = point
            if let icon = point.icon {
                view?.image = icon
            }

            if point.type == .putIn || point.type == .takeOut {
                let button = UIButton(type: .detailDisclosure)
                button.addTarget(self, action: #selector(showDirections), for: .touchUpInside)
                view?.rightCalloutAccessoryView = button
            }

            return view
        } else {
            return nil
        }
    }

}
