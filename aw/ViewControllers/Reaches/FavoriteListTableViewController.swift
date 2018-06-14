import UIKit

class FavoriteListTableViewController: RunListTableViewController {
    let UPDATE_INTERVAL_s: Double = 3600

    override func viewDidLoad() {
        predicates.append(NSPredicate(format: "favorite = TRUE" ))
        super.viewDidLoad()
        favorite = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let favoritesLastUpdated = DefaultsManager.favoritesLastUpdated
            else { return }

        if favoritesLastUpdated < Date().addingTimeInterval( -UPDATE_INTERVAL_s ) {
            refreshReaches(sender: nil)
        }
    }

    override func refreshReaches(sender: UIRefreshControl?) {
        guard let fetchedResultsController = fetchedResultsController,
            let reaches = fetchedResultsController.fetchedObjects,
            let refreshControl = self.tableView.refreshControl
            else { return }

        let reachesIds = reaches.map { String($0.id) }

        refreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height), animated: true)

        if let context = managedObjectContext {
            AWApiHelper.updateReaches(reachIds: reachesIds, viewContext: context) {
                refreshControl.endRefreshing()
                DefaultsManager.favoritesLastUpdated = Date()
                self.updateTime()
            }
        }
    }

    override func searchText() -> String {
        return "Search favorites"
    }

    override func filterPredicates() -> [NSPredicate?] {
        return [searchPredicate()]
    }

    override func segueDetail() {
        performSegue(withIdentifier: Segue.runDetailFavorites.rawValue, sender: self)
    }
}
