import Foundation
import UIKit

struct Condition {
    let name: String
    let color: UIColor
    let icon: UIImage?

    static func fromApi(condition: String) -> Condition {
        switch condition {
        case "low":
            return Condition(name: "Low",
                             color: UIColor(named: "status_yellow")!,
                             icon: UIImage(named: "lowPin"))
        case "med":
            return Condition(name: "Runnable",
                             color: UIColor(named: "status_green")!,
                             icon: UIImage(named: "runnablePin"))
        case "high":
            return Condition(name: "High",
                             color: UIColor(named: "status_red")!,
                             icon: UIImage(named: "highPin"))
        default:
            return Condition(name: "No Info",
                             color: UIColor(named: "status_grey")!,
                             icon: UIImage(named: "noinfoPin"))
        }
    }
}
