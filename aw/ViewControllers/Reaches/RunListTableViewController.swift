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
    var persistentContainer: NSPersistentContainer?

    var fetchedResultsController: NSFetchedResultsController<Reach>?

    var predicates: [NSPredicate] = []

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFetchPredicates()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissSearch()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.runDetail.rawValue, Segue.runDetailFavorites.rawValue:
            guard let detailVC = segue.destination as? RunDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let reach = fetchedResultsController?.fetchedObjects![indexPath.row] else { return }

            detailVC.reach = reach
        case Segue.showFilters.rawValue, Segue.showFiltersFavorites.rawValue:
            break
        default:
            print("Unknown segue!")
        }
    }
}

// MARK: - RunListTableViewExtension
extension RunListTableViewController {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self

        fetchedResultsController = initializeFetchedResultController()
        fetchedResultsController?.delegate = self
        updateFetchPredicates()

        setupSearchControl()
        setupRefreshControl()
    }

    func setupSearchControl() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search runs"
        searchController.searchBar.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundView = textField.subviews.first {
                // set background color
                backgroundView.backgroundColor = .white

                // round corners
                backgroundView.layer.cornerRadius = 10
                backgroundView.clipsToBounds = true
            }
        }
        navigationItem.searchController = searchController
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

    @objc private func refreshReaches(sender: UIRefreshControl) {
        let attributedTitle = sender.attributedTitle

        let refreshingTitle = NSLocalizedString("Refreshing runs from AW", comment: "Refreshing Runs from AW")
        sender.attributedTitle = NSAttributedString(string: refreshingTitle)

        if let context = managedObjectContext {
            AWApiHelper.updateRegions(viewContext: context) {
                //self.updateFetchPredicates()

                sender.endRefreshing()
                sender.attributedTitle = attributedTitle
            }
        }
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
        return fetchedResultsController?.fetchedObjects?.count ?? 0
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
        cell.persistentContainer = persistentContainer

        return cell
    }
}
