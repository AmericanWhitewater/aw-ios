import Foundation

extension Rapid {
    var subtitle: String {
        var subtitle: String
        
        if let classRating = classRating, !classRating.isEmpty {
            subtitle = "Class \(classRating): "
        } else {
            subtitle = ""
        }
        
        if isHazard {
            subtitle += "Hazard, Use Caution!"
        } else if isPlaySpot {
            subtitle += "Play Spot"
        } else {
            subtitle += "Rapid"
        }
            
        return subtitle
    }
    
    var photoUrl: URL? {
        guard
            let photoId = photoId,
            let url = URL(string: "\(AWGC.AW_BASE_URL)/photos/archive/medium/\(photoId).jpg")
        else {
            return nil
        }
        
        return url
    }
}
