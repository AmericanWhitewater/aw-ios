import CoreLocation

extension CLLocationCoordinate2D {
    /// Checks if either latitude or longitude has changed by more than a certain amount
    /// This is often done in the app as a kind of significant change check
    func hasChanged(from other: CLLocationCoordinate2D, byMoreThan degrees: CLLocationDegrees) -> Bool {
        return abs(latitude - other.latitude) > degrees || abs(longitude - other.longitude) > degrees
    }
}
