import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class GageDetailsTableViewController: UITableViewController {

    var selectedRun: Reach?
    var gagesList: [ [String: String] ]?
    var gageFlowData = [[String:Any?]]()
    
                        //Day,  Week, Month, Year
    let graphResolutions = [1, 21600, 86400, 172800]
    var currentResolutionIndex = 0
    
    var dateFormatter = DateFormatter();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm:ss a"
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if let selectedRun = selectedRun{
            print("Selected Run ReachID: \(selectedRun.id)")
            API.shared.getGauges(reachId: selectedRun.id) { (gagesResult) in
                
                self.gagesList = gagesResult
                self.tableView.reloadData()
                
                for gage in gagesResult {
                    print("Gage: \(gage["gageName"] ?? "n/a")")
                    print("-> \(gage["source"] ?? "n/a")")
                    print("-> \(gage["metricName"] ?? "n/a")")
                    print("-> \(gage["unit"] ?? "n/a")")
                }
            }
        } else {
            print("Selected run issue")
        }

        // get the graph data
        refreshGraphData()
    }
    
    func refreshGraphData() {
        getGageGraphData { (results) in
            self.gageFlowData = results
            print("Refreshing table data: \(results.count)")
            self.tableView.reloadData()
        }
    }
    
    func getDateSpan(index: Int) -> [Int]? {
        let now = Date()
        var dayComponent = DateComponents()
        let theCalendar = Calendar.current
        
        // Day
        if index == 0 {
            dayComponent.day = -1
        }
        // Week
        else if index == 1 {
            dayComponent.day = -7
        }
        // Month
        else if index == 2 {
            dayComponent.day = -30
        }
        // Year
        else {
            dayComponent.day = -365
        }
        
        let startDate = theCalendar.date(byAdding: dayComponent, to: now)
        let startDateEpoch = Int(round(startDate!.timeIntervalSince1970))
        let endDateEpoch = Int(round(now.timeIntervalSince1970))
        print("startDate Epoch: \(startDateEpoch)")
        print("now Epoch: \(endDateEpoch)")

        return [startDateEpoch, endDateEpoch]

    }
    
    func getGageGraphData(callback: @escaping ([ [String: Any?] ]) -> Void ) {
        
        guard let gageId = selectedRun?.gageId else { print("no gage for this river"); return }
        
        let selectedIndex = currentResolutionIndex
        let currentResolution = graphResolutions[selectedIndex]
        guard let dateSpan = getDateSpan(index: selectedIndex) else { print("unable to get epoch dates"); return}
                
        let urlString = "https://www.americanwhitewater.org/api/gauge/\(gageId)/flows/2?from=\(dateSpan[0])&to=\(dateSpan[1])&resolution=\(currentResolution)"
        print(urlString)
        
        AF.request(urlString).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):

                    var flowData = [[String:Any?]]()
                             
                    let json = JSON(value)
                    
                    if let flowArray = json.array {
                        for flow in flowArray {
                            var flowDict = [String: Any?]()
                            flowDict["gauge_id"] = flow["gauge_id"].intValue
                            flowDict["metric"] = flow["metric"].intValue
                            flowDict["nv"] = flow["nv"].doubleValue
                            flowDict["reading"] = flow["reading"].stringValue
                            flowDict["updated"] = flow["updated"].doubleValue 
                            flowDict["id"] = flow["id"].int32Value
                            flowData.append(flowDict)
                        }
                    }
                    
                    print("Total flow data points from server: \(json.count)")
                                        
                    // convert epoc date/times to date objects
                
                    callback(flowData)

                case .failure(let error):
                    print("Failed trying to call: \(urlString)")
                    print("Response: \(response)")
                    print("Response Description: \(response.debugDescription)")
                    print("HTTP Response: \(response.response.debugDescription)")
                    print("Error:", error)
            }
            
        }
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
            return gagesList?.count ?? 0
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
            let gage = gagesList?[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "GageForRunCell", for: indexPath) as! GageForRunCell
            
            if let gage = gage {
                cell.gageTitleLabel.text = gage["gageName"] ?? ""
                cell.gageDetailsLabel.text = "Type: \(gage["source"] ?? "n/a") - Metric: \(gage["metricName"] ?? "n/a") - Unit: \(gage["unit"] ?? "n/a")"
            }

            return cell
        }
    }
    
    func setTimePeriodForIndex(cell: GageGraphCell) {
        if currentResolutionIndex == 0 {
            cell.currentTimePeriod = .Day
        } else if currentResolutionIndex == 1 {
            cell.currentTimePeriod = .Week
        } else if currentResolutionIndex == 2 {
            cell.currentTimePeriod = .Month
        } else {
            cell.currentTimePeriod = .Year
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


    }

}
