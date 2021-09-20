import Foundation

class ReachUpdater {
    private let api = API.shared
    
    public func updateReaches(regionCodes: [String], completion: @escaping (Error?) -> Void) {
        api.updateReaches(regionCodes: regionCodes, completion: completion)
    }
    
    public func updateReaches(reachIds: [Int], completion: @escaping (Error?) -> Void) {
        api.updateReaches(reachIds: reachIds, completion: completion)
    }
    
    public func updateAllReaches(completion: @escaping () -> Void) {
        api.updateAllReaches(completion: completion)
    }
    
    public func updateReachDetail(reachId: Int, completion: @escaping (Error?) -> Void) {
        api.updateReachDetail(reachId: reachId, completion: completion)
    }
    
    public func updateAllReachDistances(completion: @escaping () -> Void) {
        api.updateAllReachDistances(completion: completion)
    }
}
