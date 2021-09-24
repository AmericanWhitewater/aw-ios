import Foundation
import MapKit

extension Reach {
    var title: String? {
        if let classRating = classRating, let name = name {
            return "\(name) (\(classRating))"
        } else {
            return name
        }
    }

    var readingFormatted: String {
        guard let currentReading = currentGageReading, let unit = unit else {
            return "n/a"
        }
        return "\(currentReading) \(unit)"
    }

    var lengthFormatted: String? {
        guard let length = length else {
            return nil
        }
        return "\(length) mi"
    }

    var updatedString: String? {
        guard let date = gageUpdated else {
            if detailUpdated != nil {
                return "No flow information"
            }
            return nil
        }
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.doesRelativeDateFormatting = true

        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"

        return "\(dateFormat.string(from: date)) at \(timeFormat.string(from: date))"
    }

    var photoUrl: String? {
        if photoId != 0 {
            return "https://www.americanwhitewater.org/photos/archive/medium/\(photoId).jpg"
        } else {
            return nil
        }
    }

    var runnable: String {
        if let rcString = rc {
            return Runnable.fromRc(rcString: rcString)
        } else {
            return ""
        }
    }
    
    /// Returns the 'runnability' color for a reaches condition
    var runnabilityColor: UIColor {
        switch condition {
        case "low": return UIColor.AW.Low
        case "med": return UIColor.AW.Med
        case "high": return UIColor.AW.High
        default: return UIColor.AW.Unknown
        }
    }

    var url: URL? {
        return URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\( id )/")
    }

    var runnableClass: String {
        return "Level: \(readingFormatted) Class: \(classRating ?? "Unknown")"
    }
    
    var gageMaxRecommended: String {
        if let gageUnit = unit, let max = gageMax, let maxFloat = Float(max) {
            let formatString = gageUnit == "cfs" ? "%.0f" : "%.2f"
            
            return String(format: formatString, maxFloat)
        } else {
            return ""
        }
    }
    
    var gageMinRecommended: String {
        if let gageUnit = unit, let min = gageMin, let minFloat = Float(min) {
            let formatString = gageUnit == "cfs" ? "%.0f" : "%.2f"
            
            return String(format: formatString, minFloat)
        } else {
            return ""
        }
    }
}
