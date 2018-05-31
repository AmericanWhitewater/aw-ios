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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionSectionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var readMoreButton: UIButton!

    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var gradientLabel: UILabel!
    @IBOutlet var statsLabels: [UILabel]!


    var reach: Reach?
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let reach = reach,
            let context = managedObjectContext,
            reach.detailUpdated == nil {
            drawInfo()
            print("Updating reach detail")
            // refreshcontrol

            AWApiHelper.updateReachDetail(reachID: String(reach.id), viewContext: context) {
                print("Updated reach details")
                // end refreshing
                self.drawInfo()
                if let parentVC = self.parent {
                    for vc in parentVC.childViewControllers {
                        if let mapVC = vc as? ReachDetailMapViewController {
                            mapVC.reloadAnnotations()
                        }
                    }
                }
            }
            AWApiHelper.updateReaches(reachIds: [String(reach.id)], viewContext: context) {
                self.drawInfo()
            }
        } else {
            print("Details already updated")
            drawInfo()
        }
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

        descriptionSectionLabel.apply(style: .Headline1)
        descriptionLabel.apply(style: .Text1)

        difficultyLabel.apply(style: .Headline1)
        lengthLabel.apply(style: .Headline1)
        gradientLabel.apply(style: .Headline1)
        for label in statsLabels {
            label.apply(style: .Text1)
        }
    }

    func drawInfo() {
        guard let reach = reach else { return }
        nameLabel.text = reach.name
        sectionLabel.text = reach.sectionCleanedHTML
        descriptionSectionLabel.text = reach.sectionCleanedHTML
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

        if reach.detailUpdated != nil {
            if let description = reach.longDescription {
                descriptionLabel.attributedText = description.htmlToAttributedString
            } else {
                descriptionLabel.text = "No description"
            }
        } else {
            descriptionLabel.text = "Loading"
        }

        if let photoUrl = reach.photoUrl {
            imageView.loadFromUrlAsync(urlString: photoUrl)
        } else {
            imageViewHeightContraint.constant = 0
        }


        if let difficulty = reach.difficulty {
            difficultyLabel.text = "Class \(difficulty)"
        } else {
            difficultyLabel.text = "N/A"
        }
        if let length = reach.length {
            lengthLabel.text = "\(length) miles"
        } else {
            lengthLabel.text = "Unknown"
        }

        if reach.avgGradient != 0 {
            gradientLabel.text = "\(reach.avgGradient) fpm"
        } else {
            gradientLabel.text = "Unknown"
        }


        // length

        // gradient

        reccomendationLabel.text = reach.runnable
        reccomendationLabel.textColor = reach.color

        // read more button
    }
}



extension ReachDetailViewController: RunDetailViewControllerType, MOCViewControllerType {
}
