import UIKit

class FavoriteListTableViewController: RunListTableViewController {
    override func viewDidLoad() {
        predicates.append(NSPredicate(format: "favorite = TRUE" ))
        super.viewDidLoad()
        favorite = true
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
