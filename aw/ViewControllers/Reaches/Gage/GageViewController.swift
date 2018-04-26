import CoreData
import UIKit

class GageViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var graphImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateTimeLabel: UILabel!

    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Reach>?

    var sourceReach: Reach?
    var gageDetail: AWGageResponse? {
        didSet {
            draw()
            tableView.reloadData()
            updateFetchPredicates()
        }
    }
    var updateTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        fetchedResultsController?.delegate = self
        fetchedResultsController = initializeFetchedResultController()

        updateFetchPredicates()

        guard let reach = sourceReach,
            reach.gageId != 0, reach.gageMetric != 0,
            let url = URL(string:
                "https://www.americanwhitewater.org/content/Gauge2/graph/id/\(reach.gageId)/metric/\(reach.gageMetric)/.raw")
            else { return }
        AWApiHelper.fetchGageDetail(gageId: Int(reach.gageId)) { gageResponse in
            DispatchQueue.main.async {
                self.updateTime = Date()
                self.gageDetail = gageResponse
            }
        }
        if let imageData = try? Data(contentsOf: url) {
            graphImage.image = UIImage(data: imageData)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segue.gageToRunDetail.rawValue:
            guard let reachVC = segue.destination as? ReachDetailContainerViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let reach = fetchedResultsController?.fetchedObjects![indexPath.row] else { return }

            reachVC.reach = reach
            injectContextAndContainerToChildVC(segue: segue)
        default:
            print("Unknown segue! \(segue.identifier)")
        }
    }
}

extension GageViewController {
    func draw() {
        guard let gageDetail = gageDetail,
            let reach = sourceReach,
            let condition = gageDetail.conditions.filter({ $0.series == reach.gageMetric }).first,
            let updateTime = updateTime
            else { return }

        let metric = gageDetail.metrics[Int(reach.gageMetric)]
        nameLabel.text = gageDetail.gage.name
        readingLabel.text = condition.reading
        unitsLabel.text = metric?.unit

        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.doesRelativeDateFormatting = true

        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"

        //updateTimeLabel.text = "\( favoriteTable ? "Favorites " : "" )Last Updated \(dateFormat.string(from: date)) at \(timeFormat.string(from: date))"

        updateTimeLabel.text = "\(dateFormat.string(from: updateTime)) \(timeFormat.string(from: updateTime))"

        print(gageDetail.riverInfo.map { $0.id })
    }

    func initializeFetchedResultController() -> NSFetchedResultsController<Reach>? {
        guard let moc = managedObjectContext else { return nil }

        let request = NSFetchRequest<Reach>(entityName: "Reach")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }

    func updateFetchPredicates() {
        guard let gageDetail = gageDetail else { return }
        fetchedResultsController?.fetchRequest.predicate = NSPredicate(
            format: "id IN %@",
            gageDetail.riverInfo.map({ $0.id }))

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
        self.tableView.reloadData()
    }
}

extension GageViewController: MOCViewControllerType {

}

// MARK: - UITableView Delegate and DataSource
extension GageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "runCell",
            for: indexPath) as? RunListTableViewCell
            else {
                fatalError("Failed to deque cell as RunListTableViewCell")
        }

        guard let reach = fetchedResultsController?.object(at: indexPath) else {
            print("Can't get reach from fetch results")
            return cell
        }

        cell.setup(reach: reach)
        cell.managedObjectContext = managedObjectContext

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.gageToRunDetail.rawValue, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultControllerDelegage
extension GageViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let insertIndex = newIndexPath else { return }
            tableView.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath else { return }
            tableView.deleteRows(at: [deleteIndex], with: .automatic)
        case .move:
            guard let fromIndex = indexPath, let toIndex = newIndexPath else { return }
            tableView.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath else { return }
            tableView.reloadRows(at: [updateIndex], with: .automatic)
        }
    }
}
