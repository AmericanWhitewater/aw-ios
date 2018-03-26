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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFetchPredicates()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.RunDetail.rawValue:
            guard let detailVC = segue.destination as? RunDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let reach = fetchedResultsController?.fetchedObjects![indexPath.row] else { return }
            
            detailVC.reach = reach
        case Segue.ShowFilters.rawValue:
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
        
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        managedObjectContext = container.viewContext
        
        guard let moc = managedObjectContext else { return }
        
        let request = NSFetchRequest<Reach>(entityName: "Reach")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "section", ascending: true)]
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController?.delegate = self
        updateFetchPredicates()
        
        setupSearchControl()
        setupRefreshControl()
    }
    
    func setupSearchControl() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search runs"
        navigationItem.searchController = searchController
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshReaches(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshReaches(sender: UIRefreshControl) {
        AWApiHelper.shared.updateReachesForAllRegions()
        sender.endRefreshing()
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
            var classPredicates: [NSPredicate] = []
            
            for value in difficulties {
                classPredicates.append(NSPredicate(format: "difficulty\(value) == TRUE"))
            }
            
            let classPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: classPredicates)
            combinedPredicates.append(classPredicate)
        }
        
        let regions = DefaultsManager.regionsFilter
        if regions.count > 0 {
            var regionPredicates: [NSPredicate] = []
            
            for region in regions {
                regionPredicates.append(NSPredicate(format: "state = %@", region))
            }
            let regionPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: regionPredicates)
            combinedPredicates.append(regionPredicate)
        }
        
        self.fetchedResultsController?.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: combinedPredicates)
        
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
        self.tableView.reloadData()
    }
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RunListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "runCell", for: indexPath) as! RunListTableViewCell
        
        //let reach = reaches[indexPath.row]
        
        guard let reach = fetchedResultsController?.object(at: indexPath) else { return cell }
        cell.setup(reach: reach)
        
        cell.managedObjectContext = managedObjectContext
        
        return cell
    }
}

