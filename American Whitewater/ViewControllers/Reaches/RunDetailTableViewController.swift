import UIKit
import GRDB

class RunDetailTableViewController: UITableViewController {
    var selectedRun:Reach?
    
    private lazy var reachUpdater = ReachUpdater()
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var runNameLabel: UILabel!
    @IBOutlet weak var runSectionLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var runLevelLabel: UILabel!
    @IBOutlet weak var runUnitsLabel: UILabel!
    @IBOutlet weak var runGaugeDeltaLabel: UILabel!
    @IBOutlet weak var runBannerImageCell: UITableViewCell!
    @IBOutlet weak var runBannerImageView: UIImageView!
    @IBOutlet weak var runSectionInfoLabel: UILabel!
    @IBOutlet weak var runDetailInfoTextView: UITextView!
    @IBOutlet weak var tapForMoreButton: UIButton!
    @IBOutlet weak var runClassLabel: UILabel!
    @IBOutlet weak var runLengthLabel: UILabel!
    @IBOutlet weak var runGradientLabel: UILabel!
    @IBOutlet weak var viewSegmentControl: UISegmentedControl!
    @IBOutlet weak var seeGaugeInfoCell: UITableViewCell!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var preview1ImageView: UIImageView!
    @IBOutlet weak var preview2ImageView: UIImageView!
    @IBOutlet weak var preview3ImageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    
    var imageLinks = [Photo]()
    
    private let detailTextMaxCount = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120

        self.runBannerImageCell.isHidden = true
        
        let selectedSegTitle = [NSAttributedString.Key.foregroundColor: UIColor(named: "primary") ?? UIColor.black]
                                as [NSAttributedString.Key : Any]
        viewSegmentControl.setTitleTextAttributes(selectedSegTitle, for: .selected)
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm:ss a"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tapForMoreButton.isHidden = false
        
        viewSegmentControl.selectedSegmentIndex = 0
        
        if let selectedRun = selectedRun {
            self.beginObserving()

            reachUpdater.updateReachDetail(reachId: selectedRun.id) { error in
                if let error = error {
                    // Only show an error state if there aren't details stored locally
                    if selectedRun.description == nil || selectedRun.description?.isEmpty == true {
                        self.isShowingError = true
                    }

                    print("Error: \(error.localizedDescription)")
                    return
                }
            }
        }
        
        // update photos listing
        self.queryPhotos()
       
        checkBannerImages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Stop observing changes
        observer = nil
    }
    
    
    @IBAction func tapForMoreButtonPressed(_ sender: Any) {
        guard let longDescription = selectedRun?.description else {
            return
        }
        
        runDetailInfoTextView.set(html: longDescription)
        tapForMoreButton.isHidden = true
        self.tableView.reloadData()
    }
    
    
    //
    // MARK: - Error state
    //
    
    /// Shows a loading error message instead of the default state ("no details available")
    /// Pretty kludgy way to do it, but since this is a UITableViewController with static cells, it's less straightforward to replace the tableview with an error view.
    /// See also numberOfSections(in:) below...
    private var isShowingError = false {
        didSet {
            tableView.tableFooterView = isShowingError ? loadingErrorLabel() : nil
            tableView.reloadData()
        }
    }
    
    private func loadingErrorLabel() -> UILabel {
        let l = UILabel()
        l.text = "Couldn't load details: please check your connection and try again"
        l.font = UIFont.preferredFont(forTextStyle: .title2)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        l.frame = CGRect(x: 0, y: 0, width: 0, height: 300)
        return l
    }
    
    func queryPhotos() {
        guard let selectedRun = selectedRun else { print("selected run is nil"); return }
        
        API.shared.getPhotos(reachId: selectedRun.id, page: 1, pageSize: 100) { (photos, error) in
            guard
                let photos = photos,
                error == nil
            else {
                print("Photos Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            print("Photo Posts count: \(photos.count)")
            self.imageLinks = photos
            
            self.updateImagePreviews()
            
            //self.tableView.reloadData()
        }
    }
    
    func checkBannerImages() {
        if let selectedRun = selectedRun {
            print("selectedRun: \(selectedRun.photoUrl ?? "n/a")")
            if let photoUrlString = selectedRun.photoUrl, let photoUrl = URL(string: photoUrlString) {
                runBannerImageCell.isHidden = false
                runBannerImageView.load(url: photoUrl, success: {
                    DispatchQueue.main.async {
                        self.runBannerImageCell.isHidden = false
                        self.tableView.reloadData()
                    }
                }) {
                    DispatchQueue.main.async {
                        self.runBannerImageCell.isHidden = true
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("selectedRun?.photoUrl:", selectedRun.photoUrl ?? "n/a")
                self.runBannerImageCell.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    func updateImagePreviews() {
        let thumbs = imageLinks
            .compactMap(\.thumbURL)
            .prefix(3)
    
        
        if thumbs.indices.contains(2) {
            preview3ImageView.load(url: thumbs[2])
        }
        
        if thumbs.indices.contains(1) {
            preview2ImageView.load(url: thumbs[1])
        }

        if thumbs.indices.contains(0) {
            preview1ImageView.load(url: thumbs[0])
        }
    }
    
    @IBAction func photoGalleryButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.gallerySeg.rawValue, sender: nil)
    }
    
    //
    // MARK: - Data observation
    //
    
    private var observer: DatabaseCancellable? = nil
    
    func beginObserving() {
        guard let selectedRun = self.selectedRun else { return }
        
        observer = ValueObservation
            .tracking(Reach.filter(id: selectedRun.id).fetchOne)
            .start(
                in: DB.shared.pool,
                onError: { error in
                    print("Unable to find matching details in db: \(error.localizedDescription)")
                }, onChange: { reach in
                    guard let reach = reach else {
                        return
                    }
                    
                    self.selectedRun = reach
                    self.updateDetailDisplay(reach)
                }
            )
    }
    
    private func updateDetailDisplay(_ reach: Reach) {
        runNameLabel.text = reach.name ?? "Unknown"
        runSectionLabel.text = reach.section ?? ""
        
        if let d = reach.detailUpdated {
            lastUpdateLabel.text = dateFormatter.string(from: d)
        } else {
            lastUpdateLabel.text = nil
        }
        
        runUnitsLabel.text = selectedRun?.unit ?? ""
        runGaugeDeltaLabel.text = selectedRun?.delta ?? ""
        runClassLabel.text = selectedRun?.classRating ?? "n/a"
        runLevelLabel.text = selectedRun?.currentGageReading ?? "n/a"
        
        let color = reach.runnabilityColor
        runLevelLabel.textColor = color
        runGaugeDeltaLabel.textColor = color
    
        seeGaugeInfoCell.isHidden = selectedRun?.condition == nil || selectedRun?.currentGageReading == nil
        
        runLengthLabel.text = reach.lengthFormatted ?? "n/a"
        runGradientLabel.text = reach.avgGradient == 0 ? "\(reach.avgGradient) fpm" : "n/a fpm"
        
        if let details = reach.description {
            let maxCount = min(details.count, detailTextMaxCount)
            let truncatedDetails = String(details.prefix(maxCount))
            runDetailInfoTextView.set(html: truncatedDetails)
        } else {
            runDetailInfoTextView.set(html: "<h3>No additional details provided</h3>")
        }
        
        self.favoriteButton.image = favoriteImage(selected: reach.favorite)
        
        checkBannerImages()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        isShowingError ? 1 : 4
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    /*
     This is a static table view but we're still using didSelectAt to handle when the user
     selects 'See Gage Info', 'Go to Website', and 'Share'
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                // Alerts
                self.performSegue(withIdentifier: Segue.riverAlertsSeg.rawValue, sender: nil)
            case 1:
                // Accidents
                self.performSegue(withIdentifier: Segue.riverAccidentsSeg.rawValue, sender: nil)
            case 2:
                // Gauge Info
                self.performSegue(withIdentifier: Segue.gaugeDetail.rawValue, sender: nil)
            case 3:
                // Handle go to website view
                guard let run = selectedRun,
                      let url = URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\(run.id)/") else { return }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case 4:
                // Share
                shareButtonPressed()
            default:
                break
            }
        }
    }

    @IBAction func shareButtonPressed() {
        guard let run = selectedRun else { return }
        let shareLink = "https://www.americanwhitewater.org/content/River/detail/id/\(run.id)/"
        
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapFavoriteButton() {
        guard let id = selectedRun?.id else {
            return
        }
        
        do {
            try DB.shared.write { db in
                guard var reach = try Reach.fetchOne(db, id: id) else {
                    return
                }
                
                reach.favorite.toggle()
                try reach.save(db)
            }
        } catch {
            showToast(message: "Couldn't update favorite")
        }
    }
    
    private func favoriteImage(selected: Bool) -> UIImage {
        let isFavorite = selectedRun?.favorite ?? false
        return UIImage(named: isFavorite ? "icon_favorite_selected" : "icon_favorite")!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if cell == runBannerImageCell {
            if runBannerImageCell.isHidden {
                return 0
            } else {
                return 180
            }
        }
        
        return UITableView.automaticDimension
    }
    
    @IBAction func detailViewSegmentChanged(_ segmentControl: UISegmentedControl) {
        performSegue(withIdentifier: Segue.reachMapEmbed.rawValue, sender: nil)
    }
    
    
    //
    // MARK: - Navigation
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segue.gaugeDetail.rawValue:
            let gaugeVC = segue.destination as? GageDetailsTableViewController
            gaugeVC?.selectedRun = selectedRun
        case Segue.reachMapEmbed.rawValue:
            let mapVC = segue.destination as? RunMapViewController
            mapVC?.reachId = selectedRun?.id
        case Segue.riverAlertsSeg.rawValue:
            let alertsVC = segue.destination as? RunAlertsViewController
            alertsVC?.selectedRun = selectedRun
        case Segue.riverAccidentsSeg.rawValue:
            let accidentsVC = segue.destination as? RunAccidentsViewController
            accidentsVC?.selectedRun = selectedRun
        case Segue.gallerySeg.rawValue:
            let galleryVC = segue.destination as? GalleryViewController
            galleryVC?.selectedRun = selectedRun
            galleryVC?.imageLinks = self.imageLinks
        case Segue.showFlowsSeg.rawValue:
            let addFlowVC = segue.destination as? RiverFlowsViewController
            addFlowVC?.selectedRun = self.selectedRun
        default:
            break
        }
    }
}

