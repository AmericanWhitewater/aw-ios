import UIKit
import CoreLocation

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate,
                            UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    @IBOutlet weak var regionsContainerView: UIView!

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    /// States, filtered by search query
    var usaRegions = Region.states
    
    /// Intl regions, filtered by search query
    var internationalRegions = Region.international
    
    /// The filters currently being edited
    var filters = DefaultsManager.shared.filters
    
    /// A reference to the regions table, so it can be refreshed independently of the collection view
    weak var regionsTableView: UITableView? = nil
    
    /// A reference to the label under the distance slider, so it can be updated independently of the collection view
    weak var distanceFilterLabel: UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
             
        filterSegmentControl.fallBackToPreIOS13Layout(using: UIColor.white)
        let selectedSegTitle = [NSAttributedString.Key.foregroundColor: UIColor(named: "primary") ?? UIColor.black]
                                as [NSAttributedString.Key : Any]
        filterSegmentControl.setTitleTextAttributes(selectedSegTitle, for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentCollectionView.reloadData()
        
        if Location.shared.checkLocationStatusInBackground(manager: locationManager) {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Commit any changes that were made.
        // In the future, we could move this, and have a cancel button to allow discarding changes:
        DefaultsManager.shared.filters = filters
    }
    
    /// Changes the filter category (region/class/distance) and auto scrolls to the correct view for interaction
    @IBAction func filterTypeChanged(_ segmentControl: UISegmentedControl) {
        contentCollectionView.scrollToItem(
            at: IndexPath(item: segmentControl.selectedSegmentIndex, section: 0),
            at: .left,
            animated: true
        )
    }
    
    
    //
    // MARK -
    //
    
    private var selectedRegionsString: String {
        filters.regionsFilter
            .compactMap { Region.regionByCode(code: $0)?.title }
            .sorted() // List regions alphabetically
            .joined(separator: ", ")
    }
    
    private var distanceFilterDescription: String {
        if filters.distanceFilter == 0 {
            return "Search Any Distance"
        } else {
            return "\(Int(filters.distanceFilter)) miles"
        }
    }
    
    /// Clears regions from search and local storage
    @objc func didTapClearRegions(_ sender: Any) {
        filters.regionsFilter.removeAll()
        regionsTableView?.reloadData()
        contentCollectionView.reloadData()
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

            cell.selectedRegionsLabel.text = "Selected Regions: \(selectedRegionsString)"
            
            cell.clearRegionsButton.isEnabled = !filters.regionsFilter.isEmpty
            cell.clearRegionsButton.addTarget(self, action: #selector(didTapClearRegions(_:)), for: .touchUpInside)
            
            cell.searchBar.delegate = self
            cell.regionTableView.delegate = self
            cell.regionTableView.dataSource = self
            regionsTableView = cell.regionTableView
            cell.regionTableView.reloadData()
            
            // only show region info if we are using region filters
            cell.regionContainerView.isHidden = !filters.showRegionFilter
            cell.showRegionsViewSwitch.isOn = filters.showRegionFilter
            cell.showRegionsViewSwitch.addTarget(self, action: #selector(filterByRegionSwitchChanged(_:)), for: .valueChanged)
            
            return cell
            
        }
        // Filter by Class Views
        else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterClassCell", for: indexPath) as! FilterClassCollectionViewCell
            
            cell.classSwitch1.isOn = filters.classFilter.contains(1)
            cell.classSwitch2.isOn = filters.classFilter.contains(2)
            cell.classSwitch3.isOn = filters.classFilter.contains(3)
            cell.classSwitch4.isOn = filters.classFilter.contains(4)
            cell.classSwitch5.isOn = filters.classFilter.contains(5)
            
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
            if !filters.showDistanceFilter {
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
            cell.distanceFilterSlider.value = Float(Int(filters.distanceFilter))
            
            cell.currentLocationActivityIndicator.isHidden = false
            cell.currentLocationActivityIndicator.startAnimating()
            
            // check if we have an existing current location
            let location = DefaultsManager.shared.location
            
            // FIXME: probably CLLocationCoordinate2DIsValid() is what's wanted here?
            if location.coordinate.latitude > 0.0 && location.coordinate.longitude < 0.0 {
                // reverse geocode the location
                geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if error == nil {
                        let placemark = placemarks?.last
                        if let placemark = placemark {
                            cell.currentLocationTitleLabel?.text = placemark.name
                            cell.currentLocationAddressLabel?.text = "\(placemark.postalAddress?.street ?? ""), \(placemark.postalAddress?.city ?? ""), \(placemark.postalAddress?.state ?? "") \(placemark.postalAddress?.postalCode ?? "")"
                            
                            cell.currentLocationActivityIndicator.stopAnimating()
                        }
                    }
                }                
            } else {
                if Location.shared.checkLocationStatusInBackground(manager: locationManager) {
                    locationManager.startUpdatingLocation()
                }
            }
            
            distanceFilterLabel = cell.distanceFilterLabel
            
            cell.distanceFilterLabel.text = distanceFilterDescription
            cell.distanceFilterSlider.isContinuous = true
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
    
    private func region(for indexPath: IndexPath) -> Region {
        if indexPath.section == 0 {
            return usaRegions[indexPath.row]
        } else {
            return internationalRegions[indexPath.row]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return usaRegions.count
        case 1:
            return internationalRegions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "USA Regions:"
        case 1:
            return "International Regions:"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let region = region(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
        
        cell.textLabel?.text = "\(region.title), \(region.country)"
        cell.accessoryType = filters.regionsFilter.contains(region.code) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggle(region: region(for: indexPath))
        contentCollectionView.reloadData()
    }
    
    func toggle(region: Region) {
        if filters.regionsFilter.contains(region.code) {
            filters.regionsFilter.removeAll { $0 == region.code }
        } else {
            filters.regionsFilter.append(region.code)
        }
        
        // This used to write to DefaultsManager to try and indicate that the region filter had changed
        // AWTODO: should this broadcast changes? Use a Notification if so
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        usaRegions = search(Region.states, by: searchText)
        internationalRegions = search(Region.international, by: searchText)
        
        // Only reload the regions table; reloading the whole collection view would remove focus from the search bar
        regionsTableView?.reloadData()
    }
    
    private func search(_ regions: [Region], by query: String) -> [Region] {
        guard !query.isEmpty else {
            return regions
        }
        
        let q = query.uppercased()
        
        return regions.filter {
            $0.title.uppercased().contains(q) ||
            $0.country.uppercased().contains(q) ||
            $0.abbreviation.uppercased().contains(q)
        }
    }
    
    
    //
    // MARK - Class Filtering
    //
    
    /// Adds or removes a class filter based on the switch
    /// Note: this depends on tags beign set to the right number in the storyboard, and will break if that changes
    @objc func classFilterChanged(classSwitch: UISwitch) {
        let filterClass = classSwitch.tag

        if filters.classFilter.contains(filterClass) {
            filters.classFilter.removeAll { $0 == filterClass}
        } else {
            filters.classFilter.append(filterClass)
        }
    }

    
    //
    // MARK - Distance Filtering
    //
    
    @objc func updateLocationButtonPressed(_ sender: Any) {
        if Location.shared.checkLocationStatusOnUserAction(manager: locationManager) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()

            // store the location for future use
            DefaultsManager.shared.coordinate = location.coordinate

            // now load the UI info for the distance filter info
            contentCollectionView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func updateFilterBy(shouldFilterByRegion: Bool) {
        if shouldFilterByRegion {
            filters.showRegionFilter = true
            filters.showDistanceFilter = false
        } else {
            filters.showRegionFilter = false
            filters.showDistanceFilter = true
        }
        
        contentCollectionView.reloadData()
    }
    
    @objc func filterByRegionSwitchChanged(_ regionSwitch: UISwitch) {
        updateFilterBy(shouldFilterByRegion: regionSwitch.isOn)
    }
    
    @objc func filterByDistanceSwitchChanged(_ distanceSwitch: UISwitch) {
        updateFilterBy(shouldFilterByRegion: !distanceSwitch.isOn)
    }
    
    @objc func distanceSliderChanged(distanceSlider: UISlider) {
        filters.distanceFilter = Double(distanceSlider.value)
        distanceFilterLabel?.text = distanceFilterDescription
        contentCollectionView.reloadData()
    }
    
    //
    // MARK - Navigation
    //
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        // FIXME: why isn't this OK for the user to do?
        if filters.showRegionFilter, filters.regionsFilter.isEmpty {
            DuffekDialog.shared.showOkDialog(title: "Region Required", message: "Please select a region or choose to filter by Distance before continuing")
            
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
