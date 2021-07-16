import UIKit

class FilterDistanceCollectionViewCell: UICollectionViewCell {
    
    // distance filter options
    @IBOutlet weak var filterDistanceSliderViewContainer: UIView!
    @IBOutlet weak var currentLocationViewContainer: UIView!
    @IBOutlet weak var filterByDistanceSwitch: UISwitch!
    @IBOutlet weak var distanceFilterSlider: UISlider!
    @IBOutlet weak var distanceFilterLabel: UILabel!
    @IBOutlet weak var currentLocationTitleLabel: UILabel!
    @IBOutlet weak var currentLocationAddressLabel: UILabel!
    @IBOutlet weak var updateLocationButton: UIButton!
    @IBOutlet weak var currentLocationActivityIndicator: UIActivityIndicatorView!
    
}
