import UIKit
import GRDB

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!

    let refreshControl = UIRefreshControl()
    
    private lazy var reachUpdater = ReachUpdater()
    
    var favorites = [Reach]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.rowHeight = UITableView.automaticDimension
        favoritesTableView.estimatedRowHeight = 120
        
        // setup pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
        favoritesTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // fetch the data from the DB and tell tableView to reload
        // this forces a refresh of the view to display correctly
        // on the main view
        beginObserving()

        // check how long its been since we pulled from the server
        // user can always pull to refresh too
        if favorites.count > 0 {
            // check how long it's been since we updated from the server
            // if it's too long we just update
            if let lastUpdated = DefaultsManager.shared.favoritesLastUpdated {
                if lastUpdated < Date(timeIntervalSinceNow: -600) { // 10mins (60s*10m)
                    print("Long enough! Fetching rivers!")
                    self.refresh()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop observing changes
        observer = nil
    }
    
    @objc func favoriteButtonPressed(_ sender: UIButton?) {
        guard
            let button = sender,
            button.tag < favorites.count
        else {
            return
        }
        
        // Despite the observer which should keep things in sync, fetch and write within a transaction to ensure we don't write out stale data:
        do {
            try DB.shared.write { db in
                var reach = try Reach.fetchOne(db, id: favorites[button.tag].id)
                reach?.favorite = false
                try reach?.save(db)
            }
        } catch {
            print("Unable to save reaches in core data: \(error), \(error.localizedDescription)")
        }
        
        favoritesTableView.reloadData()
    }
    
    //
    // MARK: - Observation
    //
    
    private var observer: DatabaseCancellable? = nil
    
    func beginObserving() {
        let obs = ValueObservation.tracking(
            Reach
                .all()
                .isFavorite()
                .order(Reach.Columns.name.asc)
                .fetchAll
        )
        
        observer = obs.start(
            in: DB.shared.pool,
            onError: { error in
                print("Error fetching favorites from core data: \(error)")
                self.showToast(message: "Connection Error: " + error.localizedDescription)
            }, onChange: { favorites in
                self.favorites = favorites
                
                // TODO: this could be improved by using UITableViewDiffableDataSource
                self.favoritesTableView.reloadData()
            })
    }

    @objc func refreshFavorites(refreshControl: UIRefreshControl) {
        self.refresh()
    }

    func refresh() {
        guard favorites.count > 0 else {
            refreshControl.endRefreshing() // ??
            return
        }
        
        reachUpdater.updateReaches(reachIds: favorites.map(\.id)) { error in
            self.refreshControl.endRefreshing()
            
            if let error = error {
                print("Error fetching by IDs: \(error.localizedDescription)")
                return
            }

            DefaultsManager.shared.favoritesLastUpdated = Date()
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reach = sender as? Reach {
            if segue.identifier == Segue.runDetailFavorites.rawValue {
                let detailVC = segue.destination as! RunDetailTableViewController
                detailVC.selectedRun = reach
            }
        }
    }

}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritesTableView.isHidden = favorites.count == 0
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // no favorites? Show a message
//        if (fetchedResultsController?.fetchedObjects?.count ?? 0) == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NoFavsCell", for: indexPath)
//            print("returning nofavscell")
//            return cell
//        }

        // show the favorites
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavRunCell", for: indexPath) as! RunsListTableViewCell
        let favorite = favorites[indexPath.row]
        
        cell.runTitleLabel.text = favorite.name ?? "Unknown"
        cell.runSectionLabel.text = favorite.section ?? "Unknown Section"
        
        let level = (favorite.currentGageReading ?? "n/a").trimmingCharacters(in: .whitespacesAndNewlines)
        cell.runLevelAndClassLabel.text = "Level: \(level) Class: \(favorite.classRating ?? "n/a")"
        
        // set highlight color
        let color = favorite.runnabilityColor
        cell.runStatusLeftBar.backgroundColor = color
        cell.runLevelAndClassLabel.textColor = color
        
        cell.runFavoritesButton.setImage(UIImage(named: "icon_favorite_selected"), for: .normal)
        
        // set index on button for later lookup
        cell.runFavoritesButton.tag = indexPath.row
        
        // add click target for the button
        cell.runFavoritesButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: Segue.runDetailFavorites.rawValue,
            sender: favorites[indexPath.row]
        )
    }
}
