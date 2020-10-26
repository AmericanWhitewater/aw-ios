import UIKit
import Charts

class GageDetailsTableViewController: UITableViewController {

    
    @IBOutlet weak var reachNameLabel: UILabel!
    @IBOutlet weak var reachSectionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var reachLevelLabel: UILabel!
    @IBOutlet weak var reachUnitLabel: UILabel!
    @IBOutlet weak var reachGageDeltaLabel: UILabel!
    @IBOutlet weak var gageTimeSegmentControl: UISegmentedControl!
    @IBOutlet weak var gageLineChart: LineChartView!
    
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gageTimeSegmentControl.defaultConfiguration(font: UIFont.boldSystemFont(ofSize: 12), color: .black)
        gageTimeSegmentControl.selectedConfiguration(font: UIFont.boldSystemFont(ofSize: 12), color: .white)
        
        setChart(dataPoints: months, values: unitsSold)
    }

    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let primaryColor = UIColor(named: "primary") ?? UIColor.red
        let colors = [NSUIColor(cgColor: primaryColor.cgColor)]
        
        let line1 = LineChartDataSet(entries: dataEntries, label: "Number")
        line1.colors = colors
        line1.circleRadius = 2
        line1.drawCircleHoleEnabled = false
        line1.circleColors = colors
        
        let data = LineChartData()
        data.addDataSet(line1)
        gageLineChart.data = data
        
        //gageLineChart.chartDescription?.text = "River Gage Data"
        gageLineChart.chartDescription?.enabled = false
        gageLineChart.dragEnabled = true
        gageLineChart.setScaleEnabled(true)
        gageLineChart.pinchZoomEnabled = true
        gageLineChart.rightAxis.enabled = false
        gageLineChart.legend.enabled = false
        gageLineChart.xAxis.drawAxisLineEnabled = false
        gageLineChart.animate(xAxisDuration: 0.4, yAxisDuration: 0.0, easingOption: .linear)
        
        
        gageLineChart.xAxis.labelPosition = .bottom
        
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
