import CoreData
import UIKit

class FilterViewController: UIViewController {
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var distanceView: UIView!

    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        // make our segmented control view blend in with the navigation bar
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initialize() {
        initializeChildVC()

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")

        setViewShown(name: "region")
    }

    func initializeChildVC() {
        for childVC in childViewControllers {
            if var childVC = childVC as? MOCViewControllerType {
                childVC.managedObjectContext = managedObjectContext
            }
        }
    }

    func setViewShown(name: String) {
        switch name {
        case "region":
            regionView.isHidden = false
            classView.isHidden = true
            distanceView.isHidden = true
        case "class":
            regionView.isHidden = true
            regionView.endEditing(true)
            classView.isHidden = false
            distanceView.isHidden = true
        case "distance":
            regionView.isHidden = true
            regionView.endEditing(true)
            classView.isHidden = true
            distanceView.isHidden = false
        default:
            regionView.isHidden = false
            classView.isHidden = true
            distanceView.isHidden = true
        }
    }

    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setViewShown(name: "region")
        case 1:
            setViewShown(name: "distance")
        case 2:
            setViewShown(name: "class")
        default:
            break
        }
    }

    @IBAction func cancelHit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneHit(_ sender: Any) {
        //let regionVC = regionView.subviews.first.responder
        for childVC in childViewControllers {
            if let childVC = childVC as? FilterViewControllerType {
                childVC.save()
            }
        }

        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: MOCViewControllerType {
}
