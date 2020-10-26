import UIKit
import CoreData
import Crashlytics

class NewsTableViewController: UITableViewController {

    @IBOutlet weak var donateButton: UIButton!

    // CoreData properties we use for managing the context and fetched results
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<NewsArticle>?
        
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        donateButton.layer.cornerRadius = 22.5
     
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 280
        
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
            if lastUpdated < Date(timeIntervalSinceNow: -120) { //60s * 10m == 600s
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
        //AWApiArticleHelper.shared.updateArticles(callback: {
        AWGQLArticleApiHelper.shared.updateArticles(callback: {
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
        let request = NewsArticle.fetchRequest() as NSFetchRequest<NewsArticle>
        request.sortDescriptors = [NSSortDescriptor(key: "postedDate", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        print("Fetched results: \(fetchedResultsController?.fetchedObjects?.count ?? -1)")
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

        if let article = sender as? NewsArticle {
            if segue.identifier == Segue.articleDetail.rawValue {
                let detailVC = segue.destination as! SingleArticleViewController
                detailVC.selectedArticle = article
                detailVC.selectedImage = self.selectedImage
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
        let count = fetchedResultsController?.fetchedObjects?.count ?? 0
        print("Count:", count)
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell2", for: indexPath) as! NewsTableViewCell

        guard let awArticle = fetchedResultsController?.object(at: indexPath) else { return cell }
        
        // get the date into a sexy format
        var releasedDatePretty = ""
        if let releaseDate = awArticle.releaseDate {
            //print("Posted Date: \(releaseDate)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: releaseDate)
            let simpleDateFormat = DateFormatter()
            simpleDateFormat.dateFormat = "MMM dd, yyyy h:mm a"
            
            if date != nil {
                releasedDatePretty = simpleDateFormat.string(from: date!)
            }
        }
        print(awArticle.abstractImage ?? "no abstract photo")
        cell.articleImageView.image = nil
        
        if let abstractPhoto = awArticle.abstractImage, abstractPhoto.count > 0 {
            let url = !abstractPhoto.contains("http") ? "\(AWGC.AW_BASE_URL)\(abstractPhoto)" : "\(abstractPhoto)"
            cell.activityIndicator.startAnimating()
            cell.articleImageView.load(url: URL(string: url)!) {
                cell.activityIndicator.stopAnimating()
            } failed: {
                cell.activityIndicator.stopAnimating()
                print("image failed to load: \(url)")
            }
        }
        
        cell.articleTitleLabel.text = (awArticle.title ?? "")
        cell.articleAuthorAndDateLabel.text = "By: " + (awArticle.author ?? "") + ((releasedDatePretty.count > 0) ? " - \(releasedDatePretty)" : "")
        cell.articleAbstractLabel.text = stripHTML(string: awArticle.abstract)
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedArticle = fetchedResultsController?.object(at: indexPath) else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell, let img = cell.articleImageView.image {
            self.selectedImage = img
        }
        
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
