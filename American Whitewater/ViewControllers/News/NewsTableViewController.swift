import UIKit
import CoreData
import Crashlytics

class NewsTableViewController: UITableViewController {

    @IBOutlet weak var donateButton: UIButton!

    // CoreData properties we use for managing the context and fetched results
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Article>?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        donateButton.layer.cornerRadius = 22.5
     
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
        
        // setup pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getArticleData(refreshControl:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        // get the data from CoreData if there is any to display
        fetchArticlesFromCoreData()
        self.tableView.reloadData()
        
        // check how long it's been since we updated from the server
        // if it's too long we just update
        if let lastUpdated = DefaultsManager.articlesLastUpdated {
            if lastUpdated < Date(timeIntervalSinceNow: -600) { //60s * 10m == 600s
                self.refresh()
            }
        } else {
            self.refresh()
        }
    }
    
    /*
     donateButtonPressed()
     opens the donate view in Safari per Apple's guidelines
    */
    @IBAction func donateButtonPressed(_ sender: Any) {
        let urlString = "https://www.americanwhitewater.org/content/Membership/donate"
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
    
    /*
     getArticleData(refreshControl:)
     used by the refreshControl to handle pull down refresh gestures
    */
    @objc func getArticleData(refreshControl: UIRefreshControl) {
        // refresh the data from the server at the users request
        self.refresh()
    }
    
    /*
     refresh()
     This is our work horse that will pull a fresh version of the articles
     down from the server and will store them in CoreData. When then
     fetch the results and reload
    */
    func refresh() {
        AWApiArticleHelper.shared.updateArticles(callback: {
            self.refreshControl?.endRefreshing()
            
            print("Articles fetched and updated!")
            self.fetchArticlesFromCoreData()
            
        }) { (error) in
            self.refreshControl?.endRefreshing()
            
            var message = "Unknown Reason"
            if let error = error { message = error.localizedDescription }
            print("Error updating articles: \(message)")
            DuffekDialog.shared.showOkDialog(title: "Connection Error", message: message)
        }
    }
    
    /*
     fetchArticlesFromCoreData()
     Uses a NSFetchRequest to request a sorted list of articles from
     the local CoreData storage
    */
    func fetchArticlesFromCoreData() {
        // setup fetched results controller
        //let request = NSFetchRequest<Article>(entityName: "Article")
        let request = Article.fetchRequest() as NSFetchRequest<Article>
        request.sortDescriptors = [NSSortDescriptor(key: "posted", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("Error fetching articles from coredata: \(error), \(error.userInfo)")
            DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.userInfo.description)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let article = sender as? Article {
            if segue.identifier == Segue.articleDetail.rawValue {
                let detailVC = segue.destination as! SingleArticleViewController
                detailVC.selectedArticle = article
            }
        }

    }
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
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        
        switch type {
            case .insert:
                tableView.insertRows(at: [cellIndex], with: .automatic)
            case .delete:
                tableView.deleteRows(at: [cellIndex], with: .automatic)
            case .update:
                tableView.reloadRows(at: [cellIndex], with: .automatic)
            default:
                break;
        }
    }
}


// MARK: - Table view data source

extension NewsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // AWTODO: add place holder cell if no objects are returned
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell

        guard let awArticle = fetchedResultsController?.object(at: indexPath) else { return cell }
        
        // get the date into a sexy format
        var releaseDatePretty = ""
        if let releaseDate = awArticle.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ssZ"
            let date = dateFormatter.date(from: releaseDate)
            let simpleDateFormat = DateFormatter()
            simpleDateFormat.dateFormat = "MMM dd, yyyy"
            
            if date != nil {
                releaseDatePretty = simpleDateFormat.string(from: date!)
            }
        }
        
        cell.articleTitleLabel.text = (awArticle.title ?? "")
        cell.articleAuthorAndDateLabel.text = "By: " + (awArticle.author ?? "") + ((releaseDatePretty.count > 0) ? " - \(releaseDatePretty)" : "")
        cell.articleAbstractLabel.text = stripHTML(string: awArticle.abstract)
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedArticle = fetchedResultsController?.object(at: indexPath) else { return }
        
        performSegue(withIdentifier: Segue.articleDetail.rawValue, sender: selectedArticle)
    }
    
    /*
     stripHTML()
     Helper function to strip out HTML tags for display as a UILabel
     NOTE: Used multiple times, should be put in a helper wrapper
    */
    private func stripHTML(string: String?) -> String {
        if let string = string {
            let strippedString = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            return strippedString
        } else {
            return ""
        }
    }
}
