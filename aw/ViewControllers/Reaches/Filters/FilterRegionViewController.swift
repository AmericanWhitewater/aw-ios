//
//  FilterRegionViewController.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import UIKit

class FilterRegionViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectedRegionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRegions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

extension FilterRegionViewController {
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension FilterRegionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Region.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let region = Region.all[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionFilterCell", for: indexPath)
        
        cell.textLabel?.text = region.title
        
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
