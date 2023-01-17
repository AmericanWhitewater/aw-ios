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
    
    enum TimePeriod {
        case day, week, month, year
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            switch self {
            case .year: formatter.dateFormat = "yyyy"
            case .month: formatter.dateFormat = "M/d"
            case .week: formatter.dateFormat = "M/d"
            case .day: formatter.dateFormat = "M/d h:mma"
            }
            formatter.locale = Locale.current
            return formatter
        }
    }
    
    var gageFlowData = [GaugeDataPoint]()
    var currentTimePeriod = TimePeriod.day
    
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
        self.setChart(
            dataPoints: gageFlowData.map(\.date),
            values: gageFlowData.map(\.reading)
        )
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

    func setChart(dataPoints: [Date], values: [Double]) {
        let referenceTimeInterval = dataPoints.min()?.timeIntervalSince1970 ?? 0
        let formatter = currentTimePeriod.dateFormatter
        
        let xAxis = gageLineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 8
        xAxis.drawLabelsEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = false
        xAxis.wordWrapEnabled = false
        if currentTimePeriod == .day {
            xAxis.labelRotationAngle =  30
        } else {
            xAxis.labelRotationAngle = 0
        }
        //xAxis.labelWidth = 100

        // Set the x values date formatter
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)
        xAxis.valueFormatter = xValuesNumberFormatter

        let entries = zip(dataPoints, values).map { (date, value) in
            ChartDataEntry(
                x: (date.timeIntervalSince1970 - referenceTimeInterval) / (3600*24),
                y: value
            )
        }
        
        let primaryColor = UIColor(named: "primary") ?? UIColor.red
        
        let line1 = LineChartDataSet(entries: entries, label: "Number")
        line1.colors = [primaryColor]
        line1.circleColors = [primaryColor]
        line1.circleRadius = 2
        line1.drawCircleHoleEnabled = false
        line1.mode = .cubicBezier
        line1.drawValuesEnabled = false
        
        let data = LineChartData(dataSet: line1)
        gageLineChart.data = data
        
        gageLineChart.leftAxis.axisMinimum = 0
        gageLineChart.leftAxis.axisMaximum = (values.max() ?? 1.0) + (values.max() ?? 1.0) / 2
        //gageLineChart.chartDescription?.text = "River Gage Data"
        gageLineChart.chartDescription.enabled = false
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
