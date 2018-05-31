import CoreData
import UIKit

class ReachDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var flowLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var reccomendationLabel: UILabel!


    var reach: Reach? {
        didSet {
            drawInfo()
        }
    }
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

extension ReachDetailViewController {
    func initialize() {
        styleLabels()
        drawInfo()
    }

    func styleLabels() {
        nameLabel.apply(style: .Headline1)
        sectionLabel.apply(style: .Text1)
        updatedLabel.apply(style: .Text2)
        flowLabel.apply(style: .Number2)
        unitsLabel.apply(style: .Text1)
        reccomendationLabel.apply(style: .Text1)
    }

    func drawInfo() {
        guard let reach = reach else { return }
        nameLabel.text = reach.name
        sectionLabel.text = reach.sectionCleanedHTML
        //difficulty
        // updated

        if let lastReading = reach.lastGageReading,
            let reading = Float(lastReading),
            let unit = reach.unit {
            flowLabel.text = String(format: reading == floor(reading) ? "%.0f" : "%.2f", reading)
            flowLabel.textColor = reach.color
            unitsLabel.text = unit
        } else {
            flowLabel.text = " "
            unitsLabel.textColor = reach.color
            unitsLabel.text = "Unknown runnability"
        }

        // length

        // gradient

        // description

        // photo

        reccomendationLabel.text = reach.runnable
        reccomendationLabel.textColor = reach.color

        // read more button
    }
}



extension ReachDetailViewController: RunDetailViewControllerType, MOCViewControllerType {
}
