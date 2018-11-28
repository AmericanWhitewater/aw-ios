import CoreData
import UIKit

class RunListTableViewController: UIViewController, MOCViewControllerType {
    let UPDATE_INTERVAL_s: Double = 60 * 60 // 1 hour
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var toggleView: UIView?
    @IBOutlet weak var runnableToggle: UISwitch?
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var updateTimeView: UIView!
    @IBOutlet weak var filterButton: UIBarButtonItem?
    @IBOutlet weak var initialLoad: UIView?
    @IBOutlet weak var initialLoadSpinner: UIImageView?
    @IBOutlet weak var initialLoadTitle: UILabel?
    @IBOutlet weak var initialLoadBody: UILabel?

    var managedObjectContext: NSManagedObjectContext?

    var fetchedResultsController: NSFetchedResultsController<Reach>?

    var predicates: [NSPredicate] = []
    var favorite: Bool = false
    let cellId = "runCell"

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        
        // Add space below the last element for the tab bar and runnable switch.
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)

        if DefaultsManager.onboardingCompleted {
            initialLoad?.isHidden = true
        } else {
            initialLoadSpinner?.startRotating(duration: 2)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFetchPredicates()
        updateTime()
        updateFilterButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let lastUpdated = DefaultsManager.lastUpdated, let isAutoRefreshEnabled = DefaultsManager.shouldAutoRefresh {
            // If data is stale
            if isAutoRefreshEnabled && lastUpdated < Date().addingTimeInterval( -UPDATE_INTERVAL_s ) {
                refreshReaches(sender: nil)
            }
            
        // If there has never been an update
        } else {
            refreshReaches(sender: nil)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissSearch()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.runDetail.rawValue, Segue.runDetailFavorites.rawValue:
            guard let detailVC = segue.destination as? ReachDetailContainerViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let reach = fetchedResultsController?.fetchedObjects![indexPath.row] else { return }

            detailVC.reach = reach
            injectContextAndContainerToChildVC(segue: segue)
        case Segue.gageDetail.rawValue:
            guard let gageVC = segue.destination as? GageViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let reach = fetchedResultsController?.fetchedObjects![indexPath.row] else { return }
            
            gageVC.sourceReach = reach
            injectContextAndContainerToChildVC(segue: segue)
        case Segue.showFilters.rawValue, Segue.showFiltersFavorites.rawValue:
            injectContextAndContainerToNavChildVC(segue: segue)
        default:
            print("Unknown segue!")
        }
    }

    @objc func refreshReaches(sender: UIRefreshControl?) {
        guard let refreshControl = self.tableView.refreshControl else { return }

        refreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height), animated: true)

        if let context = managedObjectContext {
            AWApiHelper.updateRegions(viewContext: context) {
                refreshControl.endRefreshing()
                DefaultsManager.onboardingCompleted = true
                self.initialLoad?.isHidden = true
                self.initialLoadSpinner?.stopRotating()
                self.updateTime()
            }
        }
    }

    @IBAction func runnableToggled(_ sender: Any) {
        guard let runnableToggle = runnableToggle else { return }
        DefaultsManager.runnableFilter = runnableToggle.isOn
        updateFetchPredicates()
    }

    func searchText() -> String {
        return "Search runs"
    }

    func filterPredicates() -> [NSPredicate?] {
        return [searchPredicate(), difficultiesPredicate(),
                regionsPredicate(), distancePredicate(),
                runnablePredicate()]
    }

    func segueDetail() {
        performSegue(withIdentifier: Segue.runDetail.rawValue, sender: self)
    }
}

// MARK: - RunListTableViewExtension
extension RunListTableViewController {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RunListTableViewCell.self, forCellReuseIdentifier: cellId)

        fetchedResultsController = initializeFetchedResultController()
        fetchedResultsController?.delegate = self
        updateFetchPredicates()

        updateTimeLabel.apply(style: .Text4)

        initialLoadTitle?.apply(style: .Headline1)
        initialLoadBody?.apply(style: .Text1)

        setupSearchControl()
        setupRefreshControl()
        setupRunnableToggle()
    }

    func setupRunnableToggle() {
        guard let toggleView = toggleView,
            let runnableToggle = runnableToggle
            else { return }
        toggleView.layer.masksToBounds = true
        toggleView.layer.cornerRadius = toggleView.frame.size.height / 2
        runnableToggle.isOn = DefaultsManager.runnableFilter
        runnableToggle.backgroundColor = UIColor.white
        runnableToggle.onTintColor = UIColor(named: "font_green")
        runnableToggle.layer.cornerRadius = 16
    }

    func setupSearchControl() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.tintColor = UIColor.white
        setTextFieldTintColor(to: .black, for: searchController.searchBar)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchText()
        searchController.hidesNavigationBarDuringPresentation = false

        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundView = textField.subviews.first {
                backgroundView.layer.cornerRadius = 18
                backgroundView.clipsToBounds = true
            }
        }

        navigationItem.titleView = searchController.searchBar
    }

    func setTextFieldTintColor(to color: UIColor, for view: UIView) {
        if view is UITextField {
            view.tintColor = color
        }
        for subview in view.subviews {
            setTextFieldTintColor(to: color, for: subview)
        }
    }

    func dismissSearch() {
        searchController.dismiss(animated: false, completion: nil)
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshReaches(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func searchPredicate() -> NSPredicate? {
        guard let searchText = searchController.searchBar.text,
            searchText.count > 0 else { return nil }
        let searchName = NSPredicate(format: "name contains[c] %@", searchText)
        let searchSection = NSPredicate(format: "section contains[c] %@", searchText)

        return NSCompoundPredicate(orPredicateWithSubpredicates: [searchName, searchSection])
    }

    func runnablePredicate() -> NSPredicate? {
        if DefaultsManager.runnableFilter {
            return NSPredicate(format: "condition == %@", "med")
        }
        return nil
    }

    func updateFetchPredicates() {
        let combinedPredicates: [NSPredicate] = filterPredicates().compactMap { $0 } + predicates

        if DefaultsManager.distanceFilter > 0 {
            self.fetchedResultsController?.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "distance", ascending: true),
                NSSortDescriptor(key: "name", ascending: true)
            ]
        } else {
            self.fetchedResultsController?.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true),
                NSSortDescriptor(key: "sortName", ascending: true)
            ]
        }

        self.fetchedResultsController?.fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: combinedPredicates)

        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
        self.tableView.reloadData()
    }

    func updateTime() {
        if var date = DefaultsManager.lastUpdated {
            if favorite, let favoriteDate = DefaultsManager.favoritesLastUpdated {
                date = favoriteDate >  date ? favoriteDate : date
            }
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            dateFormat.doesRelativeDateFormatting = true

            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "h:mm a"

            updateTimeLabel.text = "Last Updated \(dateFormat.string(from: date)) at \(timeFormat.string(from: date))"
        } else {
            updateTimeLabel.text = "Update in progress"
        }
    }

    func noDataString() -> String {
        if !DefaultsManager.onboardingCompleted {
            return "Runs loading. \nExploration can commence in a moment."
        }
        if DefaultsManager.distanceFilter != 0 && DefaultsManager.regionsFilter.count != 0 {
            return "No runs found with current filters. Is the distance filter hiding the selected regions?"
        }
        if DefaultsManager.distanceFilter != 0 {
            return "No runs found with current filters. You might want to try searching a larger area?"
        }

        return "No runs found. Have you checked which filters are applied?"
    }

    func updateFilterButton() {
        guard let filterButton = filterButton else {
            return
        }
        if DefaultsManager.classFilter.count > 0 || DefaultsManager.regionsFilter.count > 0 || DefaultsManager.distanceFilter > 0 {
            filterButton.image = UIImage(named: "filterOn")
        } else {
            filterButton.image = UIImage(named: "filterOff")
        }
    }
}

// MARK: - ReachFetchRequestControllerType
extension RunListTableViewController: ReachFetchRequestControllerType {

}

// MARK: - UISearchResultsUpdating
extension RunListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateFetchPredicates()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension RunListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RunListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = fetchedResultsController?.fetchedObjects?.count ?? 0

        if rows != 0 || searchController.searchBar.text?.count ?? 0 > 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            updateTimeLabel.isHidden = false
            updateTimeView.backgroundColor = UIColor(named: "grey_divider")
        } else {
            if !favorite {
                let noDataLabel: UILabel = UILabel(
                    frame: CGRect(x: 0, y: 0,
                                  width: tableView.bounds.size.width,
                                  height: tableView.bounds.size.height))
                noDataLabel.text = noDataString()
                noDataLabel.apply(style: .Text3)
                noDataLabel.textAlignment = .center
                noDataLabel.lineBreakMode = .byWordWrapping
                noDataLabel.numberOfLines = 0
                tableView.backgroundView = noDataLabel
            } else {
                let noDataView = UIView()

                noDataView.backgroundColor = UIColor(named: "grey_divider")

                let image = UIImageView(image: UIImage(named: "fill1"))
                image.contentMode = .scaleAspectFit
                let title = UILabel()
                title.apply(style: .Number1)
                title.text = "No favorite runs, yet."

                let subtitle = UILabel()
                subtitle.apply(style: .Text3)
                subtitle.text = "You haven’t favorited any run, yet! Start to search and favorite a run to get updated info!"
                subtitle.lineBreakMode = .byWordWrapping
                subtitle.numberOfLines = 0
                subtitle.textAlignment = .center

                let stack = UIStackView(arrangedSubviews: [image, title, subtitle])
                stack.axis = .vertical
                stack.alignment = .center
                stack.translatesAutoresizingMaskIntoConstraints = false
                noDataView.addSubview(stack)

                NSLayoutConstraint.activate([
                    stack.leftAnchor.constraint(equalTo: noDataView.leftAnchor, constant: 20),
                    stack.rightAnchor.constraint(equalTo: noDataView.rightAnchor, constant: -20),
                    stack.centerYAnchor.constraint(equalTo: noDataView.centerYAnchor, constant: 0),
                    stack.heightAnchor.constraint(equalToConstant: 230),
                    image.heightAnchor.constraint(equalToConstant: 65)
                    ])

                tableView.backgroundView = noDataView
            }

            tableView.separatorStyle = .none
            updateTimeLabel.isHidden = true
        }

        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
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
        segueDetail()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RunListTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        updateFetchPredicates()
    }
}
