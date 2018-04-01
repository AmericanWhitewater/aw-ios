//
//  NewsTableViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/31/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import CoreData
import UIKit

class NewsTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext?

    var fetchedResultsController: NSFetchedResultsController<Article>?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

        if let context = managedObjectContext {
            AWArticleAPIHelper.updateArticles(viewContext: context) {
                print("fetched articles")
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return fetchedResultsController?.fetchedObjects?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "supportAWCell", for: indexPath)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else {
                fatalError("Failed to deque newsCell")
            }

            let article = fetchedResultsController?.object(at: convertToFetchedResults(indexPath))

            cell.article = article
            cell.update()
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 204
        default:
            return 196
        }
    }
}

extension NewsTableViewController {
    func initialize() {
        initializeFetchedResultController()
    }

    func initializeFetchedResultController() {
        guard let moc = managedObjectContext else { return }

        let request = NSFetchRequest<Article>(entityName: "Article")
        request.sortDescriptors = [NSSortDescriptor(key: "posted", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("fetch request failed \(error) \(error.userInfo)")
        }

    }

    func convertToFetchedResults(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: indexPath.section - 1)
    }

    func convertToTableView(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: indexPath.section + 1)
    }
}

extension NewsTableViewController: MOCViewControllerType {
}

extension NewsTableViewController: NSFetchedResultsControllerDelegate {
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
            tableView.insertRows(at: [convertToTableView(insertIndex)], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath else { return }
            tableView.deleteRows(at: [convertToTableView(deleteIndex)], with: .automatic)
        case .move:
            guard let fromIndex = indexPath, let toIndex = newIndexPath else { return }
            tableView.moveRow(at: convertToTableView(fromIndex), to: convertToTableView(toIndex))
        case .update:
            guard let updateIndex = indexPath else { return }
            tableView.reloadRows(at: [convertToTableView(updateIndex)], with: .automatic)
        }
    }
}
