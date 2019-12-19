import UIKit
import CoreLocation

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate,
                            UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
       
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var selectedRegions:[Region] = []
    var selectedRegionsOrig:[Region] = []
    var usaRegions = Region.states
    var internationalRegions = Region.international
    var classFilters:[Int] = DefaultsManager.classFilter

    @IBOutlet weak var regionsContainerView: UIView!
        
    var regionsTableViewRef: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        filterSegmentControl.fallBackToPreIOS13Layout(using: UIColor.white)
        let selectedSegTitle = [NSAttributedString.Key.foregroundColor: UIColor(named: "primary") ?? UIColor.black]
                                as [NSAttributedString.Key : Any]
        filterSegmentControl.setTitleTextAttributes(selectedSegTitle, for: .selected)

    }

    func imageWithColor(color: UIColor) -> UIImage? {
        
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        guard let img = image else { return nil }

        return img
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRegions()

        contentCollectionView.reloadData()
        
    }
    
    
    
    // Filter Type Changed changes the filter category (region/class/distance)
    // and auto scrolls to the correct view for interaction
    @IBAction func filterTypeChanged(_ segmentControl: UISegmentedControl) {
        
        contentCollectionView.scrollToItem(at: IndexPath(item: segmentControl.selectedSegmentIndex, section: 0), at: .left, animated: true)
        
    }
    
    
    //
    // MARK - Regional Filtering
    //
    
    
    // Clears regions from search and local stroage
    @objc func clearReagionsButtonPressed(_ sender: Any) {
        
        selectedRegions.removeAll()
        DefaultsManager.regionsFilter.removeAll()
        
        contentCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK - Collection View Delegate / Datasource functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentCollectionView.frame.width, height: contentCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 3
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Filter by Region Views
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterRegionCell", for: indexPath) as! FilterRegionCollectionViewCell

            cell.clearRegionsButton.addTarget(self, action: #selector(clearReagionsButtonPressed(_:)), for: .touchUpInside)
            
            
            cell.searchBar.delegate = self
            cell.regionTableView.delegate = self
            cell.regionTableView.dataSource = self
            regionsTableViewRef = cell.regionTableView
            
            // setup selected regions
            var selectedRegionsString = ""
            for item in selectedRegions {
                if item.code == selectedRegions.first?.code {
                    selectedRegionsString = "\(item.title)"
                } else {
                    selectedRegionsString = "\(selectedRegionsString), \(item.title)"
                }
            }
            
            cell.selectedRegionsLabel.text = "Selected Regions: \(selectedRegionsString)"

            // only show region info if we are using region filters
            cell.showRegionsViewSwitch.isOn = DefaultsManager.showRegionFilter
            cell.showRegionsViewSwitch.addTarget(self, action: #selector(filterByRegionSwitchChanged(_:)), for: .valueChanged)
            
            if cell.showRegionsViewSwitch.isOn {
                cell.regionContainerView.isHidden = false
            } else {
                cell.regionContainerView.isHidden = true
            }
            
            return cell
            
        }
        // Filter by Class Views
        else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterClassCell", for: indexPath) as! FilterClassCollectionViewCell
            
             classFilters = DefaultsManager.classFilter
            
             for classFilter in classFilters {
                if classFilter == 1 {
                    cell.classSwitch1.isOn = true
                } else if classFilter == 2 {
                    cell.classSwitch2.isOn = true
                } else if classFilter == 3 {
                    cell.classSwitch3.isOn = true
                } else if classFilter == 4 {
                    cell.classSwitch4.isOn = true
                } else if classFilter == 5 {
                    cell.classSwitch5.isOn = true
                }
            }
             
            print("ClassFilters: \(classFilters)")

            
            cell.classSwitch1.addTarget(self, action: #selector(classFilterChanged(classSwitch:)), for: .valueChanged)
            cell.classSwitch2.addTarget(self, action: #selector(classFilterChanged(classSwitch:)), for: .valueChanged)
            cell.classSwitch3.addTarget(self, action: #selector(classFilterChanged(classSwitch:)), for: .valueChanged)
            cell.classSwitch4.addTarget(self, action: #selector(classFilterChanged(classSwitch:)), for: .valueChanged)
            cell.classSwitch5.addTarget(self, action: #selector(classFilterChanged(classSwitch:)), for: .valueChanged)
            
            return cell
            
        }
        // Filter by Distance Views
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterDistanceCell", for: indexPath) as! FilterDistanceCollectionViewCell
            
            // style button like all buttons
            cell.updateLocationButton.layer.cornerRadius = 22.5
            cell.updateLocationButton.clipsToBounds = true
            cell.updateLocationButton.addTarget(self, action: #selector(updateLocationButtonPressed(_:)), for: .touchUpInside)
            
            // initially hide the location info until it's displayed
            cell.currentLocationTitleLabel.text = ""
            cell.currentLocationAddressLabel.text = ""
            
            // setup filter switch and visibility as needed
            if DefaultsManager.showDistanceFilter == false {
                cell.filterByDistanceSwitch.isOn = false
                cell.currentLocationViewContainer.isHidden = true
                cell.filterDistanceSliderViewContainer.isHidden = true
                cell.updateLocationButton.isHidden = true
            } else {
                cell.filterByDistanceSwitch.isOn = true
                cell.currentLocationViewContainer.isHidden = false
                cell.filterDistanceSliderViewContainer.isHidden = false
                cell.updateLocationButton.isHidden = false
            }

            // set the filter to the correct value and show on UI
            cell.distanceFilterSlider.value = Float(Int(DefaultsManager.distanceFilter))
            
            cell.currentLocationActivityIndicator.isHidden = false
            cell.currentLocationActivityIndicator.startAnimating()
            
            // check if we have an existing current location
            let latitude = DefaultsManager.latitude
            let longitude = DefaultsManager.longitude

            if latitude > 0.0 && longitude < 0.0 {
                
                // reverse geocode the location
                let location = CLLocation(latitude: latitude, longitude: longitude)
                geoCoder.reverseGeocodeLocation(location) { (placemakrs, error) in
                    if error == nil {
                        let placemark = placemakrs?.last
                        if let placemark = placemark {
                            cell.currentLocationTitleLabel?.text = placemark.name
                            cell.currentLocationAddressLabel?.text = "\(placemark.postalAddress?.street ?? ""), \(placemark.postalAddress?.city ?? ""), \(placemark.postalAddress?.state ?? "") \(placemark.postalAddress?.postalCode ?? "")"
                            
                            cell.currentLocationActivityIndicator.stopAnimating()
                        }
                    }
                }                
            } else {
                print("No geo points so get user location")
                getUsersLocation()
            }

            DefaultsManager.distanceFilter = Double(cell.distanceFilterSlider.value)
            
            if cell.distanceFilterSlider.value == 0 {
                cell.distanceFilterLabel.text = "Search Any Distance"
            } else {
                cell.distanceFilterLabel.text = "\(Int(cell.distanceFilterSlider.value)) miles"
            }

            cell.distanceFilterSlider.addTarget(self, action: #selector(distanceSliderChanged(distanceSlider:)), for: .valueChanged)
            cell.filterByDistanceSwitch.addTarget(self, action: #selector(filterByDistanceSwitchChanged(_:)), for: .valueChanged)
            
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = contentCollectionView.indexPathsForVisibleItems.first {
            
            filterSegmentControl.selectedSegmentIndex = indexPath.row
            
        }
    }

    
    
    // MARK - Region UITableViewDelegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return usaRegions.count
        } else {
            return internationalRegions.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "USA Regions:"
        } else {
            return "International Regions:"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let region = indexPath.section == 0 ? usaRegions[indexPath.row] : internationalRegions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
        
        cell.textLabel?.text = "\(region.title), \(region.country)"
        
        if selectedRegions.contains(where: { $0.code == region.code }) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let regions = indexPath.section == 0 ? usaRegions : internationalRegions
        let region = regions[indexPath.row]
        
        if selectedRegions.contains(where: { $0.code == region.code }) {
            selectedRegions.removeAll { $0.code == region.code }
        } else {
            selectedRegions.append(region)
        }
                
        // save regions
        saveRegionChoices()
        
        // reloading the table view
        guard let tableView = regionsTableViewRef else { return }
        tableView.reloadData()
        
        contentCollectionView.reloadData()
    }
    
    func saveRegionChoices() {
        var regionCodes:[String] = []
        for item in selectedRegions {
            regionCodes.append(item.code)
        }
        
        DefaultsManager.regionsFilter = regionCodes

        // make it known that the regions have changed
        DefaultsManager.regionsUpdated = true
    }
    
    func loadRegions() {
        selectedRegions.removeAll()
        
        let regionStrings:[String] = DefaultsManager.regionsFilter
        for item in regionStrings {
            let region = Region.regionByCode(code: item)
            if let region = region {
                selectedRegions.append(region)
            }
        }
        
        selectedRegionsOrig = selectedRegions
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            usaRegions = Region.states
            internationalRegions = Region.international
        } else {
            usaRegions = Region.states.filter {
                
                let codeIndex = $0.code.index($0.code.endIndex, offsetBy: -2)
                let codeString = String($0.code.suffix(from: codeIndex))
                
                return $0.title.uppercased().contains(searchText.uppercased()) || $0.country.uppercased().contains(searchText.uppercased()) ||  codeString.uppercased().contains(searchText.uppercased())
            }
                    
            internationalRegions = Region.international.filter {
                let codeIndex = $0.code.index($0.code.endIndex, offsetBy: -2)
                let codeString = String($0.code.suffix(from: codeIndex))
                
                return $0.title.uppercased().contains(searchText.uppercased()) || $0.country.uppercased().contains(searchText.uppercased()) || codeString.uppercased().contains(searchText.uppercased())
            }
        }

        guard let tableView = regionsTableViewRef else { return }
        tableView.reloadData()
    }
    
    
    //
    // MARK - Class Filtering
    //
    

    // Update the switch and store changes in UserDefauts
    @objc func classFilterChanged(classSwitch: UISwitch) {
        addRemoveClassFilter(filterClass: classSwitch.tag)
    }
    
    
    // Checks if class filter exists and adds / removes
    // as needed - then stores in persistant storage
    func addRemoveClassFilter(filterClass: Int) {

        if classFilters.contains(filterClass) {
            if let removeIndex = classFilters.firstIndex(of: filterClass) {
                classFilters.remove(at: removeIndex)
            }
        } else {
            classFilters.append(filterClass)
        }
        
        // sotre any changes in user defaults
        DefaultsManager.classFilter = classFilters
    }

    
    //
    // MARK - Distance Filtering
    //

    
    @objc func updateLocationButtonPressed(_ sender: Any) {
        getUsersLocation()
    }
        
    func getUsersLocation() {
        self.locationManager.delegate = self

        let authStatus = CLLocationManager.authorizationStatus()
        
        switch authStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            
            case .authorizedWhenInUse:
                print("authorized")
                // start updating location info
                if CLLocationManager.locationServicesEnabled() {
                    print("Starting updating Location")
                    locationManager.startUpdatingLocation()
                }
            
            case .denied:
                //currentLocationActivityIndicator.stopAnimating()
                contentCollectionView.reloadData()
                
                DuffekDialog.shared.showStandardDialog(title: "Permission Denied", message: "You chose to deny this app location permissions so we are unable to use your current location. Please update your settings and try again.", buttonTitle: "Change Settings", buttonFunction: {
                    
                    // take user to change their settings
                    if let bundleId = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                }, cancelFunction: {})
            
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {

            //print("Got the latest location: \(location.debugDescription)")

            // stop updating
            locationManager.stopUpdatingLocation()

            // store the location for future use
            DefaultsManager.latitude = location.coordinate.latitude
            DefaultsManager.longitude = location.coordinate.longitude
            //DefaultsManager.distanceFilter = Double(distanceFilterSlider.value)

            // now load the UI info for the distance filter info
            //loadDistanceFilterLocationInfo()
            contentCollectionView.reloadData()
        }
    }
    
    // if the user changed their settings we need to react to this
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func updateFilterBy(shouldFilterByRegion: Bool) {
        if shouldFilterByRegion {
            DefaultsManager.showRegionFilter = true
            DefaultsManager.showDistanceFilter = false
        } else {
            DefaultsManager.showRegionFilter = false
            DefaultsManager.showDistanceFilter = true
        }
        
        contentCollectionView.reloadData()
    }
    
    @objc func filterByRegionSwitchChanged(_ regionSwitch: UISwitch) {

        updateFilterBy(shouldFilterByRegion: regionSwitch.isOn)
        
        regionsTableViewRef?.reloadData()
    }
    
    @objc func filterByDistanceSwitchChanged(_ distanceSwitch: UISwitch) {
        
        updateFilterBy(shouldFilterByRegion: !distanceSwitch.isOn)
        
        contentCollectionView.reloadData()
    }
    
    @objc func distanceSliderChanged(distanceSlider: UISlider) {
        
        DefaultsManager.distanceFilter = Double(distanceSlider.value)
        
        contentCollectionView.reloadData()
    }
    
    
    //
    // MARK - Navigation
    //
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if DefaultsManager.showRegionFilter && DefaultsManager.regionsFilter.count == 0 {
            DuffekDialog.shared.showOkDialog(title: "Region Required", message: "Please select a region or choose to filter by Distance before continuing")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
