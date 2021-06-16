//
//  GageGraphCell.swift
//  American Whitewater
//
//  Created by David Nelson on 1/11/21.
//  Copyright © 2021 American Whitewater. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class GageGraphCell: UITableViewCell {
    
    @IBOutlet weak var gageTimeSegmentControl: UISegmentedControl!
    @IBOutlet weak var gageLineChart: LineChartView!
    
    enum TimePeriod { case Day, Week, Month, Year }
    
    var gageFlowData:[ [String:Any?] ]?
    var flowReadings = [Double]()
    var timeStamps = [Double]()
    var currentTimePeriod = TimePeriod.Day
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gageTimeSegmentControl.defaultConfiguration(font: UIFont.boldSystemFont(ofSize: 12), color: .black)
        gageTimeSegmentControl.selectedConfiguration(font: UIFont.boldSystemFont(ofSize: 12), color: .white)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateChart() {
        guard let gageFlowData = gageFlowData else { print("No gage data yet"); return }

        //print("GageFlowData:", gageFlowData)
        
        flowReadings.removeAll()
        timeStamps.removeAll()
        
        for flow in gageFlowData {
            // get readings
            //print("Flow Reading: \((flow["reading"] as? String) ?? "n/a")")
            if let reading = flow["reading"] as? String {
                //print("Reading: \(reading)")
                flowReadings.append(Double(reading) ?? 0.0)
            }
            
            // get timestamps as strings
            //print("TimeStamp:", flow["updated"] ?? "n/a"    )
            if let timeStamp = flow["updated"] as? Double {
                timeStamps.append(timeStamp)
            }
        }
        //print("Time Stamps:", timeStamps.debugDescription)
        
        self.setChart(dataPoints: timeStamps, values: flowReadings)
    }
    
    func epochToDateString(epoch: Double) -> String {
        let date = Date(timeIntervalSince1970: epoch)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func setChart(dataPoints: [Double], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
                
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = timeStamps.min() {
            referenceTimeInterval = minTimeInterval
        }
        
        let formatter = DateFormatter()
        if currentTimePeriod == .Year {
            formatter.dateFormat = "yyyy"
        } else if currentTimePeriod == .Month {
            formatter.dateFormat = "M/d"
        } else if currentTimePeriod == .Week {
            formatter.dateFormat = "M/d"
        } else {
            formatter.dateFormat = "M/d h:mma"
        }
        
        
        //formatter.dateFormat = "h:mma"
        formatter.locale = Locale.current

        let xAxis = gageLineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 8
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = false
        xAxis.wordWrapEnabled = false
        if currentTimePeriod == .Day {
            xAxis.labelRotationAngle =  30
        } else {
            xAxis.labelRotationAngle = 0
        }
        //xAxis.labelWidth = 100

        // Set the x values date formatter
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)

        xValuesNumberFormatter.dateFormatter = formatter
        xAxis.valueFormatter = xValuesNumberFormatter

        gageLineChart.leftAxis.axisMinimum = 0
        gageLineChart.leftAxis.axisMaximum = (values.max() ?? 1.0) + (values.max() ?? 1.0) / 2
        
        for i in 0..<dataPoints.count {
            let xValue = (dataPoints[i] - referenceTimeInterval) / (3600*24)
            print("X-vlaue:", xValue)
            let dataEntry = ChartDataEntry(x: xValue, y: values[i])
            dataEntries.append(dataEntry)
        }

        let primaryColor = UIColor(named: "primary") ?? UIColor.red
        let colors = [NSUIColor(cgColor: primaryColor.cgColor)]
        
        let line1 = LineChartDataSet(entries: dataEntries, label: "Number")
        line1.colors = colors
        line1.circleRadius = 2
        line1.drawCircleHoleEnabled = false
        line1.circleColors = colors
        line1.mode = .cubicBezier
        line1.drawValuesEnabled = false
        
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

}
