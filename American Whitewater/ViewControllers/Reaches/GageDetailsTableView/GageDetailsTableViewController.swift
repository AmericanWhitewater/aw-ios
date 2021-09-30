import UIKit
import Foundation

class GageDetailsTableViewController: UITableViewController {

    var selectedRun: Reach?
    var gauges = [Gauge]()
    var gageFlowData = [GaugeDataPoint]()
    
                        //Day,  Week, Month, Year
    let graphResolutions = [1, 21600, 86400, 172800]
    var currentResolutionIndex = 0
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm:ss a"
    }

    override func viewDidAppear(_ animated: Bool) {
        if let selectedRun = selectedRun{
            print("Selected Run ReachID: \(selectedRun.id)")
            API.shared.getGauges(reachId: selectedRun.id) { (gauges, error) in
                guard let gauges = gauges, error == nil else {
                    print("Error getting gauges: \(String(describing: error))")
                    return
                }
                
                self.gauges = gauges
                self.tableView.reloadData()
            }
        } else {
            print("Selected run issue")
        }

        // get the graph data
        refreshGraphData()
    }
    
    func refreshGraphData() {
        guard let gageId = selectedRun?.gageId else { print("no gage for this river"); return }
        
        let currentResolution = graphResolutions[currentResolutionIndex]
        
        API.shared.getGaugeGraphData(
            gaugeId: Int(gageId),
            dateInterval: dateInterval(index: currentResolutionIndex),
            resolution: currentResolution
        ) { (results, error) in
            guard
                let results = results,
                error == nil
            else {
                print("Error getting gauge data: \(String(describing: error))")
                return
            }
            
            self.gageFlowData = results
            print("Refreshing table data: \(results.count)")
            self.tableView.reloadData()
        }
    }
    
    func dateInterval(index: Int) -> DateInterval {
        let days: Int
        switch index {
        case 0: days = 1 // Day
        case 1: days = 7 // Week
        case 2: days = 30 // Month (lol, sort of)
        default: days = 365 // Year
        }
        
        return .init(
            start: Calendar.current.date(byAdding: .day, value: -days, to: Date())!,
            end: Date()
        )
    }

    @IBAction func graphResolutionChanged(segment: UISegmentedControl) {
        currentResolutionIndex = segment.selectedSegmentIndex
        refreshGraphData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else if (indexPath.section == 1) {
            return 317
        } else {
            return 80
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return gauges.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GageDetailOverviewCell", for: indexPath) as! GageDetailsCell
            
            cell.reachNameLabel.text = selectedRun?.name ?? "Unknown"
            cell.reachSectionLabel.text = selectedRun?.section ?? ""
            cell.reachLevelLabel.text = selectedRun?.currentGageReading ?? "n/a"
            cell.reachUnitLabel.text = selectedRun?.unit ?? ""
            cell.reachGageDeltaLabel.text = selectedRun?.delta ?? ""
            cell.lastUpdatedLabel.text = dateFormatter.string(from: Date())
            
            let color = selectedRun?.runnabilityColor
            cell.reachLevelLabel.textColor = color
            cell.reachGageDeltaLabel.textColor = color
            
            return cell
        
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GageGraphCell", for: indexPath) as! GageGraphCell
            setTimePeriodForIndex(cell: cell)
            cell.gageTimeSegmentControl.addTarget(self, action: #selector(self.graphResolutionChanged), for: .valueChanged)
            cell.gageFlowData = self.gageFlowData
            cell.updateChart()
            return cell
            
        } else { //if indexPath.section == 2
            let gage = gauges[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "GageForRunCell", for: indexPath) as! GageForRunCell
            
            cell.gageTitleLabel.text = gage.name
            cell.gageDetailsLabel.text = "Type: \(gage.source ?? "n/a") - Metric: \(gage.metric?.name ?? "n/a") - Unit: \(gage.metric?.unit ?? "n/a")"

            return cell
        }
    }
    
    func setTimePeriodForIndex(cell: GageGraphCell) {
        if currentResolutionIndex == 0 {
            cell.currentTimePeriod = .day
        } else if currentResolutionIndex == 1 {
            cell.currentTimePeriod = .week
        } else if currentResolutionIndex == 2 {
            cell.currentTimePeriod = .month
        } else {
            cell.currentTimePeriod = .year
        }
    }
}
