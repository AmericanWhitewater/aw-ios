import UIKit
import CoreData
import OneSignal
import SwiftyJSON
import CoreLocation
import KeychainSwift

class RunsListViewController: UIViewController {
    
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultsController: NSFetchedResultsController<Reach>?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var runnableFilterContainerView: UIView!
    @IBOutlet weak var runnableSwitch: UISwitch!
    @IBOutlet weak var legendContainerView: UIView!
    @IBOutlet weak var mainLegendBackgroundView: UIView!
    @IBOutlet weak var legendCloseButton: UIButton!
    
    var predicates: [NSPredicate] = []
    
    var lastUpdatedDate:Date?
    let dateFormatter = DateFormatter()
    
    let searchBar = UISearchBar()
    let refreshControl = UIRefreshControl()
    
    var isLoadingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup our search bar to show correctly
        setupSearchBar()
        
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        // setup pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshRiverData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // add tap-away from search to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGesture)
        
        mainLegendBackgroundView.layer.cornerRadius = 15
        mainLegendBackgroundView.clipsToBounds = true
        legendCloseButton.layer.cornerRadius = legendCloseButton.frame.height / 2
        legendCloseButton.clipsToBounds = true
        
        runnableSwitch.isOn = DefaultsManager.runnableFilter        
    }
    
    @objc func dismissKeyboard() {
        self.searchBar.textField?.resignFirstResponder()
        self.searchBar.textField?.endEditing(true)
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        // set the right nav button based on chosen filters
        // needed due to a visual bug in XCode 11 when
        // manually setting the image
        updateFilterButton()
        
        // first fetch the rivers we have stored locally
        fetchRiversFromCoreData();
        
        if checkIfOnboardingNeeded() == false {
            print("Onboading needed == false")
            
            if let date = DefaultsManager.lastUpdated {
                if let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute, diff > 2 {
                    
                    print("2 mins has passed so update is needed")
                    self.refresh()
                } else {
                    print("2 mins has not passed yet")
                }
                
            } else { // if we haven't set a date yet just refresh
                print("no first lastUpdated")
                self.refresh()
            }
            
            // if regions fitler has changed then refresh
            if DefaultsManager.regionsUpdated {
                DefaultsManager.regionsUpdated = false
                self.refresh();
            }
        }
        
        // show the ugly legend until we design a better one
        if DefaultsManager.legendFirstRun == false {
            showLegend([])
           DefaultsManager.legendFirstRun = true
        }


        // check if user is logged in
        let keychain = KeychainSwift();
        //keychain.set(credential.oauthToken, forKey: "ios-aw-auth-key")
        //keychain.delete("ios-aw-auth-key") // for sign out
        if keychain.get(AWGC.AuthKeychainToken) == nil {
            self.showLoginScreen()
        } else {
            print("Session authenticated")
        }        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
    }
    
    
    func updateFilterButton() {
        navigationItem.rightBarButtonItem?.title = ""
        if DefaultsManager.classFilter.count < 5 || DefaultsManager.showDistanceFilter == true || DefaultsManager.showRegionFilter == true {
            navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "filterOn"), for: .normal, barMetrics: .default)
        } else {
            navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "filterOff"), for: .normal, barMetrics: .default)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func fetchRiversFromCoreData() {
        
        print("Fetching rivers from core data")
        
        let request = Reach.fetchRequest() as NSFetchRequest<Reach>

        // setup sort filters
        if DefaultsManager.showDistanceFilter && DefaultsManager.distanceFilter > 0 {
            print("Using distance filter")
            
            request.sortDescriptors = [
                NSSortDescriptor(key: "distance", ascending: true),
                NSSortDescriptor(key: "name", ascending: true)
            ]
        } else {
            request.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true),
                NSSortDescriptor(key: "sortName", ascending: true)
            ]
        }

        // based on our filtering settings (distance, region, or class) we request Reaches that
        // match these settings
        let combinedPredicates: [NSPredicate] = filterPredicates().compactMap { $0 } + predicates
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: combinedPredicates)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
//drn        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("Error fetching reaches from CoreData: \(error), \(error.userInfo)")
            DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.userInfo.description)
        }
        
        tableView.reloadData()
        
        // Here we determined if the user has downloaded their local
        // region data. Then if they haven't already we start downloading
        // all reaches in the background.
        // Since the Onboarding is now modal this may be completely hidden
        // from the user and it wont impact their experience
        if !DefaultsManager.completedFirstRun {
            print("downloading all reaches")
            DefaultsManager.completedFirstRun = true
            AWApiReachHelper.shared.downloadAllReachesInBackground {
                print("Completed downloading all data")
            }
        }
    }
    
    func checkIfOnboardingNeeded() -> Bool {
        let appVersion = Double( (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "" ) ?? 0.0
        print("AppVersion: \(appVersion) - Defaults: \(DefaultsManager.appVersion ?? 0.0)")
        
        // This ads version checking and forces users to onboard if their version is less than the current version
        // we might want to adjust this in the next release
        if DefaultsManager.appVersion == nil || DefaultsManager.appVersion! < appVersion || !DefaultsManager.onboardingCompleted {
            
            if let modalOnboadingVC = self.storyboard?.instantiateViewController(withIdentifier: "ModalOnboardingVC") as? OnboardLocationViewController {
                modalOnboadingVC.modalPresentationStyle = .overCurrentContext
                modalOnboadingVC.referenceViewController = self
                tabBarController?.present(modalOnboadingVC, animated: true, completion: nil)
                return true
            }
        }
        
        return false
    }

/* Debug Screen Only */
    func showLoginScreen() {
        if let modalSignInVC = self.storyboard?.instantiateViewController(withIdentifier: "ModalOnboardLogin") as? SignInViewController {
            modalSignInVC.modalPresentationStyle = .overCurrentContext
            modalSignInVC.referenceViewController = self
            tabBarController?.present(modalSignInVC, animated: true, completion: nil)
        }
    }
    
    
    func refresh(regions: [Region] = Region.all) {
        
        // don't update if the tableView is already updating
        if tableView.hasUncommittedUpdates {
            print("already updating")
            refreshControl.endRefreshing()
            return
        }
    
        if DefaultsManager.showRegionFilter {
            print("Updating reaches by region")
            var codes: [String] = []
                    
            // DEBUG: Force all regions
            //DefaultsManager.regionsFilter = []
        
            // if the regionsFilter is set, only pull those regions
            if DefaultsManager.regionsFilter.count > 0 {
                codes = DefaultsManager.regionsFilter
            } else {
                codes = regions.map { $0.code }
                print("Refreshing all regions")
            }
            
            
            // Check if we're pulling ALL data - if so let the user know
            // a full refresh takes 30-60 seconds to complete
            if codes.count == Region.all.count {
                DuffekDialog.shared.showStandardDialog(title: "Pull All Data?", message: "No regions selected. All river data will be updated. This will take a few minutes.\n\nYou can set filters to speed this up.", buttonTitle: "Continue", buttonFunction: {
                    // User wants to continue
                    self.refreshData(with: codes)
                }, cancelFunction: {
                    // cancelled so end refresh
                    self.refreshControl.endRefreshing()
                });
            } else {
                refreshData(with: codes)
            }
        } else {
            print("Updating reaches by distance")
            // Show locations by distance
            refreshDistanceData()
        }
    }
    
    func refreshDistanceData() {
        // get all the reaches that are within a certain distance
        let request = Reach.fetchRequest() as NSFetchRequest<Reach>
        request.sortDescriptors = [
           NSSortDescriptor(key: "distance", ascending: true),
           NSSortDescriptor(key: "name", ascending: true)
        ]

        // based on our filtering settings (distance, region, or class) we request Reaches that
        // match these settings
        let combinedPredicates: [NSPredicate] = filterPredicates().compactMap { $0 } + predicates
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: combinedPredicates)

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                             managedObjectContext: managedObjectContext,
                                                             sectionNameKeyPath: nil, cacheName: nil)
//drn        fetchedResultsController?.delegate = self
       
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("Error fetching reaches from coredata: \(error), \(error.userInfo)")
            DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.userInfo.description)
        }

        tableView.reloadData() // drn
        
        // update those reaches
        if let results = fetchedResultsController?.fetchedObjects {
            let reachIds = results.map{ "\($0.id)" }
            AWApiReachHelper.shared.updateReaches(reachIds: reachIds, callback: {
                self.refreshControl.endRefreshing()
                // finished - load the data again for display
                self.fetchRiversFromCoreData()
                
            }) { (error) in
                self.refreshControl.endRefreshing()
                
                if let error = error {
                    print("Error updating reaches: \(error.localizedDescription)")
                    DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.localizedDescription)
                } else {
                    print("Error updating reaches: Unknown why")
                    DuffekDialog.shared.showOkDialog(title: "Connection Error", message: "Unknown Reason")
                }
            }
        }
    }
    
    func refreshData(with codes: [String]) {

        AWApiReachHelper.shared.updateRegionalReaches(regionCodes: codes, callback: {
            // handle success
            self.refreshControl.endRefreshing()
            print("Fetched Regions From Server")
            
            self.fetchRiversFromCoreData()

            // we need this to update section headers
            self.tableView.reloadSections([0], with: .automatic)
            
        }) { (error) in
            self.refreshControl.endRefreshing()
            
            if let error = error {
                print("Error updating reaches: \(error.localizedDescription)")
                DuffekDialog.shared.showOkDialog(title: "Connection Error", message: error.localizedDescription)
            } else {
                print("Error updating reaches: Unknown why")
                DuffekDialog.shared.showOkDialog(title: "Connection Error", message: "Unknown Reason")
            }
        }

    }
    
    @IBAction func showLegend(_ sender: Any) {
        legendContainerView.isHidden = false
    }
    
    @IBAction func hideLegendView(_ sender: Any) {
        legendContainerView.isHidden = true
    }
    
    
    @objc func refreshRiverData(refreshControl: UIRefreshControl) {
        self.refresh()
    }
    
    @IBAction func runnableFilterChanged(_ runnableSwitch: UISwitch) {
        DefaultsManager.runnableFilter = runnableSwitch.isOn
        fetchRiversFromCoreData()
    }

    private func calculateDistanceToRiver(riverLatString: String?, riverLonString: String?) -> Double? {
        
        // get river info
        guard let riverLat = Double(riverLatString ?? ""), let riverLon = Double(riverLonString ?? "") else { return nil }
        let riverLocation = CLLocation(latitude: riverLat, longitude: riverLon)
        
        // get user location and check it
        let currentLatitude = DefaultsManager.latitude
        let currentLongitude = DefaultsManager.longitude
        if currentLatitude > 1 && currentLongitude < 0 {
            
            let currentUserLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
            
            return currentUserLocation.distance(from: riverLocation) / 1609
        }
        
        return nil
    }
    
    // MARK: - Get Filter Information
    @objc func changeFiltersPressed() {
        performSegue(withIdentifier: Segue.showFilters.rawValue, sender: nil)
    }
    
    @IBAction func selectFiltersPressed(_ sender: Any) {
        changeFiltersPressed()
    }
    
    @objc func favoriteButtonPressed(_ sender: UIButton?) {
        if let button = sender {
            
            // This is a good time to ask for permissions!
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })

            
            guard let reach = fetchedResultsController?.object(at: IndexPath(row: button.tag, section: 0)) else { return }
            reach.favorite = !reach.favorite
            
            do {
                try managedObjectContext.save()
            } catch { print("Unable to save context after save button pressed") }
        }
    }
    
    
    func searchPredicate() -> NSPredicate? {
        guard let searchText = searchBar.textField?.text, searchText.count > 0 else { return nil }
        
        let searchName = NSPredicate(format: "name contains[cd] %@", searchText)
        let searchSection = NSPredicate(format: "section contains[cd] %@", searchText)
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: [searchName, searchSection])
    }
    
    func runnablePredicate() -> NSPredicate? {
        if DefaultsManager.runnableFilter {
            return NSPredicate(format: "condition == %@ || condition == %@", "med", "high")
        }
        
        return nil
    }
    
    func difficultiesPredicate() -> NSCompoundPredicate? {
    
        var classPredicates: [NSPredicate] = []

        for difficulty in DefaultsManager.classFilter {
            classPredicates.append(NSPredicate(format: "difficulty\(difficulty) == TRUE"))
        }

        if classPredicates.count == 0 {
            return nil
        }

        return NSCompoundPredicate(orPredicateWithSubpredicates: classPredicates)
    }
    
    func regionsPredicate() -> NSPredicate? {
        // if we are filtering by distance then ignore regions
        if DefaultsManager.showDistanceFilter {
            return nil
        }
        
        let regionCodes = DefaultsManager.regionsFilter
        var states:[String] = []
        for regionCode in regionCodes {
            if let region = Region.regionByCode(code: regionCode) {
                states.append(region.apiResponse)
            }
        }

        if states.count == 0 {
            return nil
        }
        return NSPredicate(format: "state IN[cd] %@", states)
    }

    func distancePredicate() -> NSPredicate? {
        // check if user is using the distance filter or if
        // they have turned it off
        if !DefaultsManager.showDistanceFilter { return nil }
        
        let distance = DefaultsManager.distanceFilter
        if distance == 0 { return nil }
        let predicates: [NSPredicate] = [
            NSPredicate(format: "distance <= %lf", distance),
            NSPredicate(format: "distance != 0")] // hide invalid distances
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    func filterPredicates() -> [NSPredicate?] {
        var predis = [searchPredicate(), difficultiesPredicate(), runnablePredicate()]
        
        if DefaultsManager.showDistanceFilter {
            predis = predis + [distancePredicate()]
        } else {
            predis = predis + [regionsPredicate()]
        }
        
        return predis
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let reach = sender as? Reach {
            if segue.identifier == Segue.runDetail.rawValue {
                let detailVC = segue.destination as! RunDetailTableViewController
                detailVC.selectedRun = reach
            }
        }
        
    }
}


extension RunsListViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // AWTODO: when 0 items exist we return 1 to show placeholder values
        // i.e. Check your filters before searching
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // handle the case when a filter shows 0 items
        if (fetchedResultsController?.fetchedObjects?.count ?? 0) == 0 {

            if isLoadingData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingRiversCell", for: indexPath)
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoRiversCell", for: indexPath) as! NoRiversTableViewCell
                cell.noRiversButton.addTarget(self, action: #selector(changeFiltersPressed), for: .touchUpInside)
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath) as! RunsListTableViewCell

        guard let reach = fetchedResultsController?.object(at: indexPath) else { return cell }

        cell.runTitleLabel.text = reach.name ?? "Unknown"
        cell.runSectionLabel.text = reach.section ?? "Unknown Section"
        
        var level = reach.currentGageReading ?? "n/a"
        level = level.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.runLevelAndClassLabel.text = "Level: \(level) Class: \(reach.difficulty ?? "n/a")"
        
        // set highlight color
        if let status = reach.condition {
            if status == "low" {
                cell.runStatusLeftBar.backgroundColor = UIColor.AW.Low
                cell.runLevelAndClassLabel.textColor = UIColor.AW.Low
            } else if status == "med" {
                cell.runStatusLeftBar.backgroundColor = UIColor.AW.Med
                cell.runLevelAndClassLabel.textColor = UIColor.AW.Med
            } else if status == "high" || status == "hi" {
                cell.runStatusLeftBar.backgroundColor = UIColor.AW.High
                cell.runLevelAndClassLabel.textColor = UIColor.AW.High
            } else {
                cell.runStatusLeftBar.backgroundColor = UIColor.AW.Unknown
                cell.runLevelAndClassLabel.textColor = UIColor.AW.Unknown
            }
        }
        
        // show star filled or not filled if it's a favorite
        if reach.favorite {
            cell.runFavoritesButton.setImage(UIImage(named: "icon_favorite_selected"), for: .normal)
        } else {
            cell.runFavoritesButton.setImage(UIImage(named: "icon_favorite"), for: .normal)
        }
        
// DEBUG ONLY!
        if let name = reach.name, name.lowercased().contains("watauga") {
            cell.runAlertsButton.setImage(UIImage(named: "alert-filled"), for: .normal)
        } else {
            cell.runAlertsButton.setImage(UIImage(named: "alert-empty"), for: .normal)
        }
        
        // show distance to the river if we have it
        // this 999999 value is an ugly hack for invalid distance values to prevent
        // them from showing up first in the listing
        cell.runDistanceAwayLabel.isHidden = true
        if reach.distance == 999999 || reach.distance == 0.0 {
            cell.runDistanceAwayLabel.text = "n/a miles"
            cell.runDistanceAwayLabel.isHidden = false
        } else if reach.distance > 0.0 {
            cell.runDistanceAwayLabel.text = String(format: "%.1f miles", reach.distance)
            cell.runDistanceAwayLabel.isHidden = false
        }
            
        // set index on button for later lookup
        cell.runFavoritesButton.tag = indexPath.row
        
        // add click target for the button
        cell.runFavoritesButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let selectedRun = fetchedResultsController?.object(at: indexPath) else { return }
        performSegue(withIdentifier: Segue.runDetail.rawValue, sender: selectedRun)

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        
        var lastUpdatedMessage = "Refreshing..."
        if let lastUpdatedDate = DefaultsManager.lastUpdated {
            lastUpdatedMessage = "Last Updated: \(dateFormatter.string(from: lastUpdatedDate))"
        }
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        label.text = lastUpdatedMessage
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-|", options: .alignAllCenterY, metrics: nil, views: ["label": label, "view": view])
        view.addConstraints(horizontallayoutContraints)

        let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalLayoutContraint)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}



//extension RunsListViewController: NSFetchedResultsControllerDelegate {
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//
//        if fetchedResultsController == nil {
//            print("FetchedResultsController is nil... ignoring update")
//            return
//        } else if tableView == nil {
//            print("tableView is nil... ignoring update of table")
//            return
//        }
//
//
//        tableView.endUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//
//        switch type {
//            case .insert:
//                guard let insertIndex = newIndexPath else { return }
//                tableView.insertRows(at: [insertIndex], with: .automatic)
//            case .delete:
//                guard let deleteIndex = indexPath else { return }
//                tableView.deleteRows(at: [deleteIndex], with: .automatic)
//            case .move:
//                guard let fromIndex = indexPath, let toIndex = newIndexPath else { return }
//                tableView.moveRow(at: fromIndex, to: toIndex)
//            case .update:
//                guard let updateIndex = indexPath else { return }
//                tableView.reloadRows(at: [updateIndex], with: .automatic)
//            default:
//                break
//        }
//    }
//}

extension RunsListViewController: UISearchBarDelegate {

    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.setTextField(color: UIColor.white)
        searchBar.tintColor = UIColor(named: "primary") ?? UIColor.AW.Unknown
        searchBar.textField?.textColor = UIColor.AW.Unknown
        searchBar.placeholder = "Search for a Run"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            clearButton.addTarget(self, action: #selector(self.clearButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func clearButtonPressed() {
        searchBar.textField?.resignFirstResponder()
        fetchRiversFromCoreData()
    }

    // hide keyboard on search press
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        fetchRiversFromCoreData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            fetchRiversFromCoreData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

class SearchBarContainerView: UIView {

    let searchBar: UISearchBar

    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)

        addSubview(searchBar)
    }

    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
