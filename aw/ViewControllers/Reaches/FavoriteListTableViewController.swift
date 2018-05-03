import UIKit

class FavoriteListTableViewController: RunListTableViewController {
    override func viewDidLoad() {
        predicates.append(NSPredicate(format: "favorite = TRUE" ))
        super.viewDidLoad()
        favorite = true
    }

    override func noDataString() -> String {
        if DefaultsManager.distanceFilter != 0 && DefaultsManager.regionsFilter.count != 0 {
            return "No favorite runs found with current filters. Is the distance filter hiding the selected regions?"
        }
        if DefaultsManager.distanceFilter != 0 {
            return "No favorite runs found with current filters. You might want to try searching a larger area?"
        }

        return "No favorite runs found. Have you starred any runs and checked which filters are applied?"
    }

    override func refreshReaches(sender: UIRefreshControl) {
        guard let fetchedResultsController = fetchedResultsController,
            let reaches = fetchedResultsController.fetchedObjects
            else { return }

        let reachesIds = reaches.map { String($0.id) }

        if let context = managedObjectContext {
            AWApiHelper.updateReaches(reachIds: reachesIds, viewContext: context) {
                sender.endRefreshing()
                DefaultsManager.favoritesLastUpdated = Date()
                let header = self.tableView.headerView(forSection: 0) as? RunHeaderTableViewCell
                header?.update()
            }
        }
    }

    override func searchText() -> String {
        return "Search favorites"
    }

    override func filterPredicates() -> [NSPredicate?] {
        return [searchPredicate()]
    }
}
