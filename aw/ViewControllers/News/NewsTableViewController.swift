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
    @IBOutlet weak var donateButton: UIButton!

    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<Article>?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

        if let lastUpdated = DefaultsManager.articlesLastUpdated {
            if lastUpdated < Date(timeIntervalSinceNow: -86400) {
                updateArticles()
            }
        } else {
            updateArticles()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segue.articleDetail.rawValue:
            guard let articleVC = segue.destination as? SingleArticleViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let article = fetchedResultsController?.object(at: convertToFetchedResults(indexPath)) else { return }
            articleVC.article = article
        default:
            print("unknown segue")
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
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "supportAWCell",
                for: indexPath) as? NewsDonateTableViewCell else {
                fatalError("Failed to deque donate cell")
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "newsCell",
                for: indexPath) as? NewsTableViewCell else {
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

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        default:
            return 18
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewsTableViewController {
    func initialize() {
        initializeFetchedResultController()
        setupRefreshControl()
    }

    func initializeFetchedResultController() {
        guard let moc = managedObjectContext else { return }

        let request = NSFetchRequest<Article>(entityName: "Article")
        request.sortDescriptors = [NSSortDescriptor(key: "posted", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("fetch request failed \(error) \(error.userInfo)")
        }

    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull to Refresh", comment: "Pull to Refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refreshArticles(sender: UIRefreshControl) {
        let attributedTitle = sender.attributedTitle
        let refreshingTitle = NSLocalizedString("Refreshing News", comment: "Refreshing news")
        sender.attributedTitle = NSAttributedString(string: refreshingTitle)

        if let context = managedObjectContext {
            AWArticleAPIHelper.updateArticles(viewContext: context) {
                sender.endRefreshing()
                sender.attributedTitle = attributedTitle
            }
        }
    }

    func updateArticles() {
        if let context = managedObjectContext {
            AWArticleAPIHelper.updateArticles(viewContext: context) {
            }
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
