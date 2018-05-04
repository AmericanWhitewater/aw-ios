import UIKit

class FilterRegionViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectedRegionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var selectedRegions: [String] = []

    var isFiltered = false
    var filteredRegions: [Region] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

// MARK: - Extension
extension FilterRegionViewController {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = .done

        selectedRegions = DefaultsManager.regionsFilter

        setRegionsLabel()
    }

    func setRegionsLabel() {
        if selectedRegions.count == 0 {
            selectedRegionsLabel.text = "Showing runs from everywhere"
        } else {
            selectedRegionsLabel.text = "Showing runs from: \(selectedRegions.joined(separator: ", "))"
        }
    }
}

// MARK: - FilterViewControllerType
extension FilterRegionViewController: FilterViewControllerType {
    func save() {
        DefaultsManager.regionsFilter = selectedRegions
    }
}

extension FilterRegionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isFiltered = false
        } else {
            isFiltered = true
            filteredRegions = Region.all.filter { (region) in
                return region.title.contains(searchText)
            }
        }
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterRegionViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return filteredRegions.count
        } else {
            return Region.all.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let region: Region

        if isFiltered {
            region = filteredRegions[indexPath.row]
        } else {
            region = Region.all[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionFilterCell", for: indexPath)

        cell.textLabel?.text = region.title

        if selectedRegions.contains(region.title) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let cell = tableView.cellForRow(at: indexPath)

        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell?.accessoryType = .none
            selectedRegions = selectedRegions.filter { $0 != cell?.textLabel?.text }
        } else {
            cell?.accessoryType = .checkmark
            selectedRegions.append((cell?.textLabel?.text)!)
        }

        setRegionsLabel()
    }
}
