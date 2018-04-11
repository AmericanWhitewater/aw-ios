import CoreData
import UIKit

class RunDetailTableViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var gradientLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var detailUpdated: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var runnabilityLabel: UILabel!

    var managedObjectContext: NSManagedObjectContext?

    var reach: Reach?

    var expandDescription: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let reach = reach,
            let context = managedObjectContext,
            reach.detailUpdated == nil {
            drawView()
            print("Updating reach detail")
            AWApiHelper.updateReachDetail(reachID: String(reach.id), viewContext: context) {
                print("Updated reach details")
                self.drawView()
            }
            AWApiHelper.updateReaches(reachIds: [String(reach.id)], viewContext: context) {
                self.drawView()
            }
        } else {
            print("Details already updated")
            drawView()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 1
        case 1:
            return 2
        case 3:
            return 3
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 1, section: 1):
            expandDescription = !expandDescription
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        case IndexPath(row: 1, section: 3):
            guard let reach = reach, let url = reach.url else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case IndexPath(row: 2, section: 3):
            let cell = tableView.cellForRow(at: indexPath)
            share(cell)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return 117
        case IndexPath(row: 0, section: 1): // Image
            if reach?.photoUrl != nil {
                return 186
            }
            return 0
        case IndexPath(row: 1, section: 1): // Description
            return expandDescription ? UITableViewAutomaticDimension : 168
        case IndexPath(row: 0, section: 2):
            return 77
        default:
            return 44
        }
    }
}

extension RunDetailTableViewController {
    func initialize() {
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0) //UIEdgeInsetsMake(-36, 0, 0, 0)

        drawView()
        setupRefreshControl()
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull to Refresh", comment: "Pull to Refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshReach(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func tapFavoriteIcon(_ sender: Any) {
        guard let reach = reach, let context = managedObjectContext else { return }

        context.persist {
            reach.favorite = !reach.favorite
            self.drawView()
        }
    }

    @objc func refreshReach(sender: UIRefreshControl) {
        guard let reach = reach, let context = managedObjectContext else { return }

        let attributedTitle = sender.attributedTitle
        let refreshingTitle = NSLocalizedString("Refreshing run details from AW",
            comment: "Refreshing run details from AW")
        sender.attributedTitle = NSAttributedString(string: refreshingTitle)

        AWApiHelper.updateReachDetail(reachID: String(reach.id), viewContext: context) {
            sender.endRefreshing()
            sender.attributedTitle = attributedTitle
            self.drawView()
        }
        AWApiHelper.updateReaches(reachIds: [String(reach.id)], viewContext: context) {
            self.drawView()
        }
    }

    func drawView() {
        guard let reach = reach else { return }
        nameLabel.text = reach.name
        sectionLabel.text = reach.sectionCleanedHTML
        difficultyLabel.text = reach.difficulty

        if let lastReading = reach.lastGageReading,
            let reading = Float(lastReading),
            let unit = reach.unit {
            readingLabel.text = String(format: reading == floor(reading) ? "%.0f" : "%.2f", reading)
            readingLabel.textColor = reach.color
            unitsLabel.text = unit
        } else {
            readingLabel.text = ""
            unitsLabel.textColor = reach.color
            unitsLabel.text = "Unknown"
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

        detailUpdated.text = reach.updatedString ?? "Updating Run Details"

        if detailUpdated != nil {
            if let description = reach.longDescription, let data = description.data(using: .utf8) {
                if let html = try? NSMutableAttributedString(data: data,
                         options: [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html],
                         documentAttributes: nil) {
                    descriptionLabel.attributedText = html
                }
            } else {
                descriptionLabel.text = "No description"
            }
        } else {
            descriptionLabel.text = "Updating run details"
        }
        if let photoUrl = reach.photoUrl {
            if let url = URL(string: photoUrl), let data = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: data)
            }
        }
        runnabilityLabel.text = reach.runnable
        runnabilityLabel.textColor = reach.color

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
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

// MARK: - RunDetailViewControllerType
extension RunDetailTableViewController: RunDetailViewControllerType {

}

// MARK: - MOCViewControllerType
extension RunDetailTableViewController: MOCViewControllerType {

}
