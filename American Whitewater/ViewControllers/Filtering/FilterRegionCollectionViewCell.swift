import UIKit

class FilterRegionCollectionViewCell: UICollectionViewCell {
    
    // region filter options
    @IBOutlet weak var regionTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clearRegionsButton: UIButton!
    @IBOutlet weak var selectedRegionsLabel: UILabel!
    @IBOutlet weak var regionContainerView: UIView!
    @IBOutlet weak var showRegionsViewSwitch: UISwitch!
}
