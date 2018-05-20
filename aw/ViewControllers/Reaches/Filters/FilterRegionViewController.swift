import UIKit

class FilterRegionViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectedRegionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewBottomConstraint: NSLayoutConstraint!

    var selectedRegions: [String] = []

    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: .UIKeyboardDidHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extension
extension FilterRegionViewController {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor(named: "grey_divider")

        selectedRegions = DefaultsManager.regionsFilter

        setRegionsLabel()
        selectedRegionsLabel.apply(style: .Headline1)
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else { return }

        tableviewBottomConstraint.constant = keyboardFrameValue.cgRectValue.size.height
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else { return }

        tableviewBottomConstraint.constant = 0
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }

    func setRegionsLabel() {
        if selectedRegions.count == 0 {
            selectedRegionsLabel.text = "Showing runs from everywhere"
        } else if selectedRegions.count == 1 {
            selectedRegionsLabel.text = "Your selected region: \(selectedRegions.first ?? "")"
        } else {
            selectedRegionsLabel.text = "Your selected regions: \(selectedRegions.joined(separator: ", "))"
        }
    }

    func regionsForSection(section: Int) -> [Region] {
        let header = Region.alphaGroupKeys[section]

        guard let region = Region.grouped[header] else {
            fatalError("Unable find section: \(section)")
        }

        if searchText != "" {
            return region.filter { region in
                return region.title.lowercased().contains(searchText.lowercased()) || region.country.lowercased().contains(searchText.lowercased())
            }
        }

        return region
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
        self.searchText = searchText
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterRegionViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Region.alphaGroupKeys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionsForSection(section: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let region = regionsForSection(section: indexPath.section)[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "regionFilterCell", for: indexPath)

        cell.textLabel?.apply(style: .Text3)

        if ["US", "CA"].contains(region.country) {
            cell.textLabel?.text = "\(region.title), \(region.country)"
        } else {
            cell.textLabel?.text = region.title
        }


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

        guard let regionName = cell?.textLabel?.text?.split(separator: ",").first else {
            fatalError("No cell text")
        }

        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell?.accessoryType = .none
            selectedRegions = selectedRegions.filter { $0 != String(regionName) }
        } else {
            cell?.accessoryType = .checkmark
            selectedRegions.append(String(regionName))
        }

        setRegionsLabel()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Region.alphaGroupKeys[section]
    }
}
