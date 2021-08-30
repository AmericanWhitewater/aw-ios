import Foundation
import Charts

class ChartXAxisFormatter: NSObject {
    var dateFormatter: DateFormatter
    var referenceTimeInterval: TimeInterval

    init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
        
        super.init()
    }
}


extension ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }

}
