import UIKit
import GRDB

class NewsTableViewController: UITableViewController {
    @IBOutlet weak var donateButton: UIButton!
    
    private var selectedImage: UIImage?
    private lazy var updater = ArticleUpdater()
    
    var articles = [NewsArticle]()
    
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
        super.viewWillAppear(animated)
        
        beginObserving()
        
        // Update from server, at most every 120 sec
        let lastUpdated = DefaultsManager.shared.articlesLastUpdated
        if lastUpdated == nil || (lastUpdated?.timeIntervalSinceNow ?? 0) < -120 {
            self.refresh()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Clearing the observer reference stops db observation:
        articleObserver = nil
    }
    
    /// Opens the donate view in Safari per Apple's guidelines
    @IBAction func donateButtonPressed(_ sender: Any) {
        let urlString = "https://www.americanwhitewater.org/content/Membership/donate"
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
    
    /// Handles pull down refresh gestures
    @objc func getArticleData(refreshControl: UIRefreshControl) {
        // refresh the data from the server at the users request
        refresh()
    }
    
    /// Requests updated articles from the server
    func refresh() {
        updater.updateArticles { error in
            self.refreshControl?.endRefreshing()

            if let error = error {
                self.showToast(message: "Connection Error: " + error.localizedDescription)
                return
            }
        }
    }
    
    //
    // MARK: - Data observation
    //
    
    private var articleObserver: DatabaseCancellable? = nil
    
    func beginObserving() {
        let observer = ValueObservation.tracking(
            NewsArticle
                .order(NewsArticle.Columns.releaseDate.desc)
                .fetchAll
        )
        
        articleObserver = observer.start(
            in: DB.shared.pool,
            onError: { error in
                self.showToast(message: "Error: " + error.localizedDescription)
            }, onChange: { articles in
                // TODO: for now, this just fetches articles and reloads the whole tableView. This could be made much more elegant by using a UITableViewDiffableDataSource
                self.articles = articles
                self.tableView.reloadData()
            }
        )
    }
    
    //
    // MARK: - Navigation
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let article = sender as? NewsArticle {
            if segue.identifier == Segue.articleDetail.rawValue {
                let detailVC = segue.destination as! SingleArticleViewController
                detailVC.selectedArticle = article
                detailVC.selectedImage = self.selectedImage
            }
        }
    }
    
    //
    // MARK: - Formatters
    //
    
    private let simpleDateFormatter = DateFormatter(dateFormat: "MMM dd, yyyy h:mm a")
}

/// Table view data source
extension NewsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // AWTODO: add place holder cell if no objects are returned
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell2", for: indexPath) as! NewsTableViewCell
        let article = articles[indexPath.row]
        
        var releasedDatePretty = ""
        if let releaseDate = article.releaseDate {
            releasedDatePretty = simpleDateFormatter.string(from: releaseDate)
        }
        
        cell.articleImageView.image = nil
        if let abstractPhoto = article.abstractImage, !abstractPhoto.isEmpty {
            let url = !abstractPhoto.contains("http") ? "\(AWGC.AW_BASE_URL)\(abstractPhoto)" : "\(abstractPhoto)"
            cell.activityIndicator.startAnimating()
            cell.articleImageView.load(url: URL(string: url)!) {
                cell.activityIndicator.stopAnimating()
            } failed: {
                cell.activityIndicator.stopAnimating()
                print("image failed to load: \(url)")
            }
        }
        
        cell.articleTitleLabel.text = article.title
        cell.articleAuthorAndDateLabel.text = "By: " + (article.author ?? "") + ((releasedDatePretty.count > 0) ? " - \(releasedDatePretty)" : "")
        cell.articleAbstractLabel.text = stripHTML(string: article.abstract)
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        
        // FIXME: wat (this is using an instance var as a kind of argument to prepareForSegue)
        // lots of reasons to change this, starting with: tap an article, go back, tap one with no image, it will pass the wrong image
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
    // FIXME: this won't reliably remove all tags, also there's a second, different stripHTML() defined in RunRapidDetailsTableViewController
    private func stripHTML(string: String?) -> String {
        if let string = string {
            let strippedString = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            return strippedString
        } else {
            return ""
        }
    }
}
