//
//  RunListTableViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/24/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

class RunListTableViewController: UIViewController, MOCViewControllerType {
    @IBOutlet var tableView: UITableView!

    var managedObjectContext: NSManagedObjectContext?

    var fetchedResultsController: NSFetchedResultsController<Reach>?

    var predicates: [NSPredicate] = []
    var favorite: Bool = false

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFetchPredicates()
        let header = self.tableView.headerView(forSection: 0) as? RunHeaderTableViewCell
        header?.update()
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
        case Segue.showFilters.rawValue, Segue.showFiltersFavorites.rawValue:
            injectContextAndContainerToNavChildVC(segue: segue)
        default:
            print("Unknown segue!")
        }
    }
    func noDataString() -> String {
        if DefaultsManager.distanceFilter != 0 && DefaultsManager.regionsFilter.count != 0 {
            return "No runs found with current filters. Is the distance filter hiding the selected regions?"
        }
        if DefaultsManager.distanceFilter != 0 {
            return "No runs found with current filters. You might want to try searching a larger area?"
        }

        return "No runs found. Have you checked which filters are applied?"
    }

    @objc func refreshReaches(sender: UIRefreshControl) {
        let attributedTitle = sender.attributedTitle

        let refreshingTitle = NSLocalizedString("Refreshing runs from AW", comment: "Refreshing Runs from AW")
        sender.attributedTitle = NSAttributedString(string: refreshingTitle)

        if let context = managedObjectContext {
            AWApiHelper.updateRegions(viewContext: context) {
                sender.endRefreshing()
                sender.attributedTitle = attributedTitle
                let header = self.tableView.headerView(forSection: 0) as? RunHeaderTableViewCell
                header?.update()
            }
        }
    }

    func searchText() -> String {
        return "Search runs"
    }
}

// MARK: - RunListTableViewExtension
extension RunListTableViewController {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(
                nibName: "RunHeaderTableViewCell",
                bundle: nil),
           forHeaderFooterViewReuseIdentifier: "headerCell")

        fetchedResultsController = initializeFetchedResultController()
        fetchedResultsController?.delegate = self
        updateFetchPredicates()

        setupSearchControl()
        setupRefreshControl()
    }

    func setupSearchControl() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchText()
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.titleView = searchController.searchBar
    }

    func dismissSearch() {
        searchController.dismiss(animated: false, completion: nil)
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull to Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshReaches(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func updateFetchPredicates() {
        var combinedPredicates = predicates

        if let searchText = searchController.searchBar.text {
            if searchText.count > 0 {
                let searchName = NSPredicate(format: "name contains[c] %@", searchText)
                let searchSection = NSPredicate(format: "section contains[c] %@", searchText)

                let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [searchName, searchSection])

                combinedPredicates.append(searchPredicate)
            }
        }

        let difficulties = DefaultsManager.classFilter
        if difficulties.count > 0 {
            combinedPredicates.append(difficultiesPredicate())
        }

        let regions = DefaultsManager.regionsFilter
        if regions.count > 0 {
            combinedPredicates.append(regionsPredicate())
        }

        if DefaultsManager.distanceFilter > 0 {
            combinedPredicates.append(distancePredicate())
            self.fetchedResultsController?.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "distance", ascending: true),
                NSSortDescriptor(key: "name", ascending: true)]
        } else {
            self.fetchedResultsController?.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)]
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

        if rows != 0 {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = noDataString()
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            noDataLabel.lineBreakMode = .byWordWrapping
            noDataLabel.numberOfLines = 0
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }

        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "runCell",
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerCell") as? RunHeaderTableViewCell
        header?.favoriteTable = favorite
        return header
    }
}

extension RunListTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        updateFetchPredicates()
    }
}
