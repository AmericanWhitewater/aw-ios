import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!

    let refreshControl = UIRefreshControl()
    
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Reach>?
    
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
        fetchRiversFromCoreData()
        favoritesTableView.reloadData()

        // check how long its been since we pulled from the server
        // user can always pull to refresh too
        if fetchedResultsController?.fetchedObjects?.count ?? 0 > 0 {
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
        
        fetchedResultsController?.delegate = nil
    }
    
    @objc func favoriteButtonPressed(_ sender: UIButton?) {
        if let button = sender {
            let reach = fetchedResultsController?.object(at: IndexPath(row: button.tag, section: 0))
            reach?.favorite = false
            do {
                try managedObjectContext.save()
            } catch {
                let error = error as NSError
                print("Unable to save reaches in core data: \(error), \(error.localizedDescription)")
            }

            favoritesTableView.reloadData()
        }
    }
    
    
    func fetchRiversFromCoreData() {
        let request = Reach.reachFetchRequest() as NSFetchRequest<Reach>
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("Error fetching favorites from core data: \(error), \(error.userInfo)")
            self.showToast(message: "Connection Error: " + error.userInfo.description)
        }
    }

    @objc func refreshFavorites(refreshControl: UIRefreshControl) {
        self.refresh()
    }

    func refresh() {
        
        guard let reachIds = (fetchedResultsController?.fetchedObjects?.map { String($0.id) }), reachIds.count > 0 else {
            refreshControl.endRefreshing()
            print("no ids")
            return
        }
        
        AWApiReachHelper.shared.updateReaches(reachIds: reachIds, callback: {
            self.refreshControl.endRefreshing()
            
            print("Fetched favorite rivers")
            self.fetchRiversFromCoreData()
            DefaultsManager.shared.favoritesLastUpdated = Date()
            
        }) { (error) in
            self.refreshControl.endRefreshing()
            print("Error fetching by IDs: \(error.localizedDescription)")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("fetched count: \(fetchedResultsController?.fetchedObjects?.count ?? -1)")
        
        if fetchedResultsController?.fetchedObjects?.count == 0 {
            favoritesTableView.isHidden = true;
        } else {
            favoritesTableView.isHidden = false;
        }
        
        return fetchedResultsController?.fetchedObjects?.count ?? 0
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

        guard let favorite = fetchedResultsController?.object(at: indexPath) else { return cell }
        
        cell.runTitleLabel.text = favorite.name ?? "Unknown"
        cell.runSectionLabel.text = favorite.section ?? "Unknown Section"
        
        var level = favorite.currentGageReading ?? "n/a"
        level = level.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.runLevelAndClassLabel.text = "Level: \(level) Class: \(favorite.difficulty ?? "n/a")"
        
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
        let selectedRun = fetchedResultsController?.object(at: indexPath)
        performSegue(withIdentifier: Segue.runDetailFavorites.rawValue, sender: selectedRun)
    }

}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoritesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoritesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else { return }
        
        switch type {
            case .insert:
                favoritesTableView.insertRows(at: [cellIndex], with: .automatic)
            case .delete:
                favoritesTableView.deleteRows(at: [cellIndex], with: .automatic)
            case .move:
                guard let fromIndex = indexPath, let toIndex = newIndexPath else { return }
                favoritesTableView.moveRow(at: fromIndex, to: toIndex)
            case .update:
                favoritesTableView.reloadRows(at: [cellIndex], with: .automatic)
            default:
                break
        }
    }
    

}
