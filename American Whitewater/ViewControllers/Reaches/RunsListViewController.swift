import UIKit
import CoreData
import OneSignal
import SwiftyJSON
import CoreLocation
import KeychainSwift

class RunsListViewController: UIViewController {
    private let reachUpdater = ReachUpdater()
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Reach>?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var runnableFilterContainerView: UIView!
    @IBOutlet weak var runnableSwitch: UISwitch!
    let searchBar = UISearchBar()
    let refreshControl = UIRefreshControl()
    
    private var filters: Filters { DefaultsManager.shared.filters }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup pull to refresh
        refreshControl.addTarget(self, action: #selector(didPullRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        setupSearchBar()
        // add tap-away from search to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        runnableSwitch.isOn = filters.runnableFilter
        API.shared.updateAccountInfo()
        
        // AWTODO loading UI states
        if !DefaultsManager.shared.completedFirstRun {
            print("downloading all reaches")
            reachUpdater.updateAllReaches {
                print("Completed downloading all data")

                do {
                    try self.updateFetchedResultsController()
                } catch {
                    print("Error in updateFetchedResultsController: \(error)")
                }
                
                DefaultsManager.shared.completedFirstRun = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateData();
        
        showOnboardingIfNeeded()

        // check if user is logged in
        let keychain = KeychainSwift();
        //keychain.set(credential.oauthToken, forKey: "ios-aw-auth-key")
        //keychain.delete("ios-aw-auth-key") // for sign out
        if keychain.get(AWGC.AuthKeychainToken) == nil || DefaultsManager.shared.signedInAuth == nil {
            self.showLoginScreen()
        } else {
            print("Session authenticated")
        }        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
    }
    
    func showOnboardingIfNeeded() {
        guard
            !DefaultsManager.shared.onboardingCompleted,
            let modalOnboardingVC = self.storyboard?.instantiateViewController(withIdentifier: "ModalOnboardingVC") as? OnboardLocationViewController
        else {
            return
        }
 
        modalOnboardingVC.modalPresentationStyle = .overCurrentContext
        modalOnboardingVC.referenceViewController = self
        tabBarController?.present(modalOnboardingVC, animated: true, completion: nil)
    }

    func showLoginScreen() {
        guard
            let lastShown = DefaultsManager.shared.signInLastShown,
            // Only show once per day
            lastShown < Date(timeIntervalSinceNow: -24 * 60 * 60)
        else {
            return
        }

        // AWTODO: why not present on self?
        tabBarController?.present(SignInViewController.fromStoryboard(), animated: true, completion: nil)
    }
    
    // Contract for updating data
    // - Uses the settings in the defaults manager
    // - The data will not be returned, but will be in the fetchedResultsController
    // - TableView.reloadData() will be called automatically
    // - LastUpdate will be updated automatically
    func updateData(fromNetwork: Bool = false) {
        do {
            try updateFetchedResultsController()
        } catch {
            print("Error in updateFetchedResultsController: \(error)")
        }
        
        // Update from network if requested or if data is more than 1 hour old
        guard
            let lastUpdate = DefaultsManager.shared.lastUpdated,
            fromNetwork || lastUpdate < Date(timeIntervalSinceNow: -60 * 60)
        else {
            return
        }
        
        refreshControl.beginRefreshing()
        
        func onCompletion(_ error: Error?) {
            self.refreshControl.endRefreshing()
            
            if let error = error {
                self.showToast(message: "Error fetching data: " + error.localizedDescription)
                return
            }
            
            DefaultsManager.shared.lastUpdated = Date()
            self.tableView.reloadData()
        }
        
        if filters.isRegion {
            if filters.regionsFilter.isEmpty {
                let alert = UIAlertController(
                    title: "Pull All Data?",
                    message: "You didn't select a region or distance to pull data from. This will download all river data for the USA.\n\nOn a slower connection this can take a few minutes.\n\nYou can set filters to speed this up.",
                    preferredStyle: .alert
                )
                
                alert.addAction(.init(title: "Continue", style: .default, handler: { _ in
                    self.refreshByRegion(completion: onCompletion)
                }))
                alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true)
            } else {
                refreshByRegion(completion: onCompletion)
            }
        } else {
            guard let reaches = fetchedResultsController?.fetchedObjects else {
                // FIXME: should this indicate failure?
                // By indicating success, lastUpdated gets set
                onCompletion(nil)
                return
            }
            
            reachUpdater.updateReaches(reachIds: reaches.map(\.id), completion: onCompletion)
        }
    }
    
    private var searchPredicate: NSPredicate? {
        guard let searchText = searchBar.searchTextField.text, searchText.count > 0 else { return nil }
        
        let searchName = NSPredicate(format: "name contains[cd] %@", searchText)
        let searchSection = NSPredicate(format: "section contains[cd] %@", searchText)
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: [searchName, searchSection])
    }
    
    /// This is the combination of the filter's predicate and the current search query (which Filters doesn't know about)
    private var combinedPredicateWithSearch: NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [
            filters.combinedPredicate(),
            searchPredicate
        ].compactMap({$0}))
    }
    
    /// The count of all reaches cached locally.
    /// Used to ask, essentially, "do we have any data?" below when deciding whether to show the loading or empty state for no results
    private var totalReachCount: Int {
        let count = try? managedObjectContext.count(for: Reach.fetchRequest())
        return count ?? 0
    }
    
    func updateFetchedResultsController() throws {
        print("Fetching rivers from core data")
        
        if let fetchedResultsController = fetchedResultsController {
            // Update sort descriptors and predicate if the controller already exists
            fetchedResultsController.fetchRequest.sortDescriptors = filters.sortDescriptors
            fetchedResultsController.fetchRequest.predicate = combinedPredicateWithSearch
        } else {
            // Create the fetched results controller if it doesn't exist
            let request = Reach.reachFetchRequest()
            request.sortDescriptors = filters.sortDescriptors
            request.predicate = combinedPredicateWithSearch
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: managedObjectContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
        }
        
        try fetchedResultsController?.performFetch()
        
        // Still have to update the tableView after the initial fetch
        // (the delegate will handle further updates)
        tableView.reloadData()
    }
    
    func refreshByRegion(completion: @escaping (Error?) -> Void) {
        print("Updating reaches by region")
        
        reachUpdater.updateReaches(
            regionCodes: filters.regionsFilter.count > 0 ? filters.regionsFilter : Region.all.map { $0.code },
            completion: completion
        )
    }
    
    @objc func didPullRefreshControl(refreshControl: UIRefreshControl) {
        print("Refresh called from refresh control")
        self.updateData(fromNetwork: true)
    }
    
    @objc func dismissKeyboard() {
        self.searchBar.searchTextField.resignFirstResponder()
        self.searchBar.searchTextField.endEditing(true)
    }
    
    @IBAction func runnableFilterChanged(_ runnableSwitch: UISwitch) {
        var filters = filters
        filters.runnableFilter = runnableSwitch.isOn
        DefaultsManager.shared.filters = filters
        
        updateData()
    }
    
    // MARK: - Get Filter Information

    @objc @IBAction func selectFiltersPressed(_ sender: Any) {
        performSegue(withIdentifier: Segue.showFilters.rawValue, sender: nil)
    }
    
    @objc func favoriteButtonPressed(_ sender: UIButton?) {
        guard let button = sender else {
            return
        }
                                    
        // This is a good time to ask for permissions!
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        guard let reach = fetchedResultsController?.object(at: IndexPath(row: button.tag, section: 0)) else {
            return
        }
        
        reach.favorite.toggle()
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to save context after save button pressed")
        }
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let reach = sender as? Reach,
           segue.identifier == Segue.runDetail.rawValue
        else {
            return
        }
        
        let detailVC = segue.destination as! RunDetailTableViewController
        detailVC.selectedRun = reach
    }
}

/// A minimal implementation that reloads the whole tableView every time the fetched results change
extension RunsListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}


extension RunsListViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // AWTODO: when 0 items exist we return 1 to show placeholder values
        // i.e. Check your filters before searching
        let count = fetchedResultsController?.fetchedObjects?.count ?? 0
        if section == 0 {
            return count
        } else {
            return count == 0 ? 1 : 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // handle the case when there are no fetched objects
        if
            indexPath.section == 1,
            (fetchedResultsController?.fetchedObjects?.count ?? 0) == 0
        {
            if totalReachCount == 0 {
                // The loading state.
                // There aren't any reaches stored locally, so (presumably?) we must be doing an initial load of reaches from the network
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingRiversCell", for: indexPath) as! LoadingRiversCell
                cell.activityIndicator.startAnimating()
                return cell
            } else {
                // The empty state.
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoRiversCell", for: indexPath) as! NoRiversTableViewCell
                cell.noRiversButton.addTarget(self, action: #selector(selectFiltersPressed(_:)), for: .touchUpInside)
                
                return cell
            }
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingRiversCell", for: indexPath) as! LoadingRiversCell
            cell.activityIndicator.startAnimating()
            return cell
            
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath) as! RunsListTableViewCell

            guard let reach = fetchedResultsController?.object(at: indexPath) else { return cell }

            cell.runTitleLabel.text = reach.name ?? "Unknown"
            cell.runSectionLabel.text = reach.section ?? "Unknown Section"
            
            var level = reach.currentGageReading ?? "n/a"
            level = level.trimmingCharacters(in: .whitespacesAndNewlines)
            cell.runLevelAndClassLabel.text = "Level: \(level)\(reach.unit ?? "") Class: \(reach.difficulty ?? "n/a")"
            
            // set highlight color
            let color = reach.runnabilityColor
            cell.runStatusLeftBar.backgroundColor = color
            cell.runLevelAndClassLabel.textColor = color
            
            // show star filled or not filled if it's a favorite
            if reach.favorite {
                cell.runFavoritesButton.setImage(UIImage(named: "icon_favorite_selected"), for: .normal)
            } else {
                cell.runFavoritesButton.setImage(UIImage(named: "icon_favorite"), for: .normal)
            }
            
    // DEBUG ONLY! AWTODO Fix this to set alert image correctly
            if let name = reach.name, name.lowercased().contains("watauga") {
                cell.runAlertsButton.setImage(UIImage(named: "alert-filled"), for: .normal)
            } else {
                cell.runAlertsButton.setImage(UIImage(named: "alert-empty"), for: .normal)
            }
            
            // show distance to the river if we have it
            // this 999999 value is an ugly hack for invalid distance values to prevent
            // them from showing up first in the listing
            cell.runDistanceAwayLabel.isHidden = true
            if reach.distance == 999999 || reach.distance == 0.0 {
                cell.runDistanceAwayLabel.text = "n/a miles"
                cell.runDistanceAwayLabel.isHidden = true
            } else if reach.distance > 0.0 {
                cell.runDistanceAwayLabel.text = String(format: "%.1f miles", reach.distance)
                cell.runDistanceAwayLabel.isHidden = true
            }
                
            // set index on button for later lookup
            cell.runFavoritesButton.tag = indexPath.row
            
            // add click target for the button
            cell.runFavoritesButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRun = fetchedResultsController?.object(at: indexPath) else {
            return
        }
        
        performSegue(withIdentifier: Segue.runDetail.rawValue, sender: selectedRun)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            let label = UILabel()
            
            var lastUpdatedMessage = "Refreshing..."
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            if let lastUpdatedDate = DefaultsManager.shared.lastUpdated {
                lastUpdatedMessage = "Last Updated: \(dateFormatter.string(from: lastUpdatedDate))"
            }
            
            view.backgroundColor = UIColor.systemGroupedBackground
            
            label.text = lastUpdatedMessage
            label.textAlignment = .center
            label.textColor = UIColor.darkGray
            
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-|", options: .alignAllCenterY, metrics: nil, views: ["label": label, "view": view])
            view.addConstraints(horizontallayoutContraints)

            let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            view.addConstraint(verticalLayoutContraint)
            
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        } else {
            return 0
        }
    }
}

extension RunsListViewController: UISearchBarDelegate {

    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.setTextField(color: UIColor.white)
        searchBar.tintColor = UIColor(named: "primary") ?? UIColor.AW.Unknown
        searchBar.searchTextField.textColor = UIColor.AW.Unknown
        searchBar.placeholder = "Search for a Run"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            clearButton.addTarget(self, action: #selector(self.clearButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func clearButtonPressed() {
        searchBar.searchTextField.resignFirstResponder()
        updateData()
    }

    // hide keyboard on search press
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        updateData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        updateData()
    }
}

class SearchBarContainerView: UIView {

    let searchBar: UISearchBar

    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)

        addSubview(searchBar)
    }

    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
