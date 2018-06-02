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

    @IBOutlet var buttonLabels: [UILabel]!
    @IBOutlet weak var seeGageInfoView: UIView!


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


    @IBAction func gageInfoButtonTapped(_ sender: Any) {
        guard let reach = reach, reach.gageId != 0 else { return }
        self.parent?.performSegue(withIdentifier: Segue.gageDetail.rawValue, sender: sender)
    }
    @IBAction func learnMoreTapped(_ sender: Any) {
        guard let reach = reach, let url = reach.url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        share(sender)
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
        readMoreButton.titleLabel?.apply(style: .Label1)

        difficultyLabel.apply(style: .Headline1)
        lengthLabel.apply(style: .Headline1)
        gradientLabel.apply(style: .Headline1)
        for label in statsLabels {
            label.apply(style: .Text1)
        }

        for label in buttonLabels {
            label.apply(style: .Text3)
        }
    }

    func drawInfo() {
        guard let reach = reach else { return }
        nameLabel.text = reach.name
        sectionLabel.text = reach.sectionCleanedHTML
        descriptionSectionLabel.text = reach.sectionCleanedHTML
        updatedLabel.text = reach.updatedString ?? "Updating Run Details"

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

        reccomendationLabel.text = reach.runnable
        reccomendationLabel.textColor = reach.color

        // read more button


        if reach.gageId == 0 {
            seeGageInfoView.isHidden = true
        }
    }

    func share(_ sender: Any?) {
        guard let reach = reach,
            let section = reach.section,
            let name = reach.name,
            let url = reach.url else { return }

        let title: String
        if reach.runnable.count > 0 {
            title = "\( section) of \( name ) is \( reach.runnable )"
        } else {
            title = "\( section ) of \( name )"
        }
        let activityController = UIActivityViewController(activityItems: [title, url], applicationActivities: nil)
        if let sender = sender as? UIView {
            activityController.popoverPresentationController?.sourceView = sender
        }

        present(activityController, animated: true, completion: nil)
    }
}



extension ReachDetailViewController: RunDetailViewControllerType, MOCViewControllerType {
}
