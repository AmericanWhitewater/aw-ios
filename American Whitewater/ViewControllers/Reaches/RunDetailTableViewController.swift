import UIKit
import CoreData

class RunDetailTableViewController: UITableViewController {

    var selectedRun:Reach?
    
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Reach>?
    
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
    
    var imageLinks = [ [String:String?] ]()
    
    var detailTextMaxCount = 400
    var originalDetailsDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120

        self.runBannerImageCell.isHidden = true
        
        let selectedSegTitle = [NSAttributedString.Key.foregroundColor: UIColor(named: "primary") ?? UIColor.black]
                                as [NSAttributedString.Key : Any]
        viewSegmentControl.setTitleTextAttributes(selectedSegTitle, for: .selected)
        
        
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm:ss a"
        
        runNameLabel.text = selectedRun?.name ?? "Unknown"
        runSectionLabel.text = selectedRun?.section ?? ""
        lastUpdateLabel.text = dateFormatter.string(from: Date())
        
        runLevelLabel.text = selectedRun?.currentGageReading ?? "n/a"
        runUnitsLabel.text = selectedRun?.unit ?? ""
        runGaugeDeltaLabel.text = selectedRun?.delta ?? ""
        
        runClassLabel.text = selectedRun?.difficulty ?? "n/a"
        runLengthLabel.text = "n/a" //selectedRun. how do we get this?
        runGradientLabel.text = "n/a" // need to find this one too
        
        if let cond = selectedRun?.condition {
            if cond == "low" {
                runLevelLabel.textColor = UIColor.AW.Low
                runGaugeDeltaLabel.textColor = UIColor.AW.Low
            } else if cond == "med" {
                runLevelLabel.textColor = UIColor.AW.Med
                runGaugeDeltaLabel.textColor = UIColor.AW.Med
            } else if cond == "high" {
                runLevelLabel.textColor = UIColor.AW.High
                runGaugeDeltaLabel.textColor = UIColor.AW.High
            } else {
                runLevelLabel.textColor = UIColor.AW.Unknown
                runGaugeDeltaLabel.textColor = UIColor.AW.Unknown
            }
        }
        
        if selectedRun?.condition == nil || selectedRun?.currentGageReading == nil {
            seeGaugeInfoCell.isHidden = true
        } else {
            seeGaugeInfoCell.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tapForMoreButton.isHidden = false
        
        viewSegmentControl.selectedSegmentIndex = 0
        
        if let selectedRun = selectedRun {
            AWApiReachHelper.shared.updateReachDetail(reachId: "\(selectedRun.id)", callback: {
                self.fetchDetailsFromCoreData()
            }) { (error) in
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // update photos listing
        self.queryPhotos()
       
        checkBannerImages()
    }
    
    
    @IBAction func tapForMoreButtonPressed(_ sender: Any) {
        runDetailInfoTextView.set(html: originalDetailsDescription)
        tapForMoreButton.isHidden = true
        self.tableView.reloadData()
    }
    
    
    func queryPhotos() {
        
        guard let selectedRun = selectedRun else { print("selected run is nil"); return }
                
        AWGQLApiHelper.shared.getPhotosForReach(reach_id: Int(selectedRun.id), page: 1, page_size: 100 , callback: { (photoResults) in
            if let photoResults = photoResults {
                print("Photo Posts count: \(photoResults.count)")
                self.imageLinks.removeAll()
                for result in photoResults {
                    let photos = result.photos
                    for photo in photos {
                        if let image = photo.image, let uri = image.uri,
                           let thumb = uri.thumb, let medium = uri.medium, let big = uri.big {
                            
                            var uri = [String:String?]()
                            uri["thumb"] = thumb
                            uri["med"] = medium
                            uri["big"] = big
                            uri["caption"] = photo.caption ?? ""
                            uri["author"] = photo.author ?? ""
                            uri["photoDate"] = photo.photoDate ?? ""
                            self.imageLinks.append(uri)
                        }
                    }
                }
                
                self.updateImagePreviews()
                
            } else {
                print("No photos returned")
            }

            //self.tableView.reloadData()
        }) { (error, message) in
            print("Photos Error: ", GQLError.handleGQLError(error: error, altMessage: message))
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
        
        if imageLinks.count >= 3 {
            if let thumb = imageLinks[2]["thumb"] as? String, let url = URL(string: "\(AWGC.AW_BASE_URL)\(thumb)") {
                preview3ImageView.load(url: url)
            }
        }
        
        if imageLinks.count >= 2 {
            if let thumb = imageLinks[1]["thumb"] as? String, let url = URL(string: "\(AWGC.AW_BASE_URL)\(thumb)") {
                preview2ImageView.load(url: url)
            }
        }

        if imageLinks.count > 0 {
            if let thumb = imageLinks[0]["thumb"] as? String, let url = URL(string: "\(AWGC.AW_BASE_URL)\(thumb)") {
                preview1ImageView.load(url: url)
            }
        }
    }
    
    @IBAction func photoGalleryButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.gallerySeg.rawValue, sender: nil)
    }
    
    
    func fetchDetailsFromCoreData() {
        guard let selectedRun = self.selectedRun else { return }
        
        let request = Reach.reachFetchRequest() as NSFetchRequest<Reach>
        request.predicate = NSPredicate(format: "id == %i", selectedRun.id)
        
        guard let result = try? managedObjectContext.fetch(request), let fetchedReach = result.first else {
            print("Unable to find matching details in db")
            return
        }
        
        self.runLengthLabel.text = fetchedReach.length ?? "n/a"
        self.runGradientLabel.text = fetchedReach.avgGradient == 0 ? "\(fetchedReach.avgGradient) fpm" : "n/a fpm"
        if var details = fetchedReach.longDescription {
            originalDetailsDescription = details
            
            let maxCount = detailTextMaxCount > details.count ? details.count : detailTextMaxCount
            details = String(details.prefix(maxCount))
            runDetailInfoTextView.set(html: details)
            
        } else {
            runDetailInfoTextView.set(html: "<h3>No additional details provided</h3>")
        }
        
        checkBannerImages()
        self.tableView.reloadData()
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
            
            // check what option the user selected
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: Segue.riverAlertsSeg.rawValue, sender: nil)
            } else if indexPath.row == 1 {
                self.performSegue(withIdentifier: Segue.riverAccidentsSeg.rawValue, sender: nil)
            } else if indexPath.row == 2 {
                // Handle 'See Gauge Info'
                self.performSegue(withIdentifier: Segue.gaugeDetail.rawValue, sender: nil)
            } else if indexPath.row == 3 {
                
                // Handle go to website view
                guard let run = selectedRun,
                      let url = URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\(run.id)/") else { return }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else if indexPath.row == 4 {
                // Handle share button pressed
                shareButtonPressed()
            }
        }
    }

    @IBAction func shareButtonPressed() {
        guard let run = selectedRun else { return }
        let shareLink = "https://www.americanwhitewater.org/content/River/detail/id/\(run.id)/"
        
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        present(vc, animated: true, completion: nil)
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
    
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.gaugeDetail.rawValue {
            let gaugeVC = segue.destination as? GageDetailsTableViewController //GaugeDetailViewController
            gaugeVC?.selectedRun = selectedRun
        } else if segue.identifier == Segue.reachMapEmbed.rawValue {
            let mapVC = segue.destination as? RunMapViewController
            mapVC?.selectedRun = selectedRun
        } else if segue.identifier == Segue.riverAlertsSeg.rawValue {
            let alertsVC = segue.destination as? RunAlertsViewController
            alertsVC?.selectedRun = selectedRun
        } else if segue.identifier == Segue.riverAccidentsSeg.rawValue {
            let accidentsVC = segue.destination as? RunAccidentsViewController
            accidentsVC?.selectedRun = selectedRun
        } else if segue.identifier == Segue.gallerySeg.rawValue {
            let galleryVC = segue.destination as? GalleryViewController
            galleryVC?.selectedRun = selectedRun
            galleryVC?.imageLinks = self.imageLinks
        } else if segue.identifier == Segue.showFlowsSeg.rawValue {
            let addFlowVC = segue.destination as? RiverFlowsViewController
            addFlowVC?.selectedRun = self.selectedRun
        }
    }
}

