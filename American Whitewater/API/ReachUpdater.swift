import Foundation
import GRDB
import CoreLocation

class ReachUpdater {
    private let api = API.shared
    
    //
    // MARK: - Public API
    //
    
    private static var isFetchingReaches = false
    
    /// Requests reaches matching the given `regionCodes` from the network and creates or updates the local copies
    public func updateReaches(regionCodes: [String], completion: @escaping (Error?) -> Void) {
        guard !Self.isFetchingReaches else {
            completion(Errors.alreadyFetchingReaches)
            return
        }
        
        Self.isFetchingReaches = true
        
        api.getReaches(regionCodes: regionCodes) { awReaches, error in
            defer {
                Self.isFetchingReaches = false
            }
            
            guard
                let awReaches = awReaches,
                error == nil
            else {
                completion(error)
                return
            }
         
            do {
                try DB.shared.write { db in
                    try self.createOrUpdateReaches(newReaches: awReaches, database: db)
                    DefaultsManager.shared.lastUpdated = Date()
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    /// Requests reaches with the given `reachIds` from the network and creates or updates the local copies
    public func updateReaches(reachIds: [Int], completion: @escaping (Error?) -> Void) {
        api.getReaches(reachIds: reachIds) { awReaches, error in
            guard
                let awReaches = awReaches,
                error == nil
            else {
                completion(error)
                return
            }
            
            do {
                try DB.shared.write { db in
                    try self.createOrUpdateReaches(newReaches: awReaches, database: db)
                    
                    DefaultsManager.shared.lastUpdated = Date()
                    
                    // FIXME: This call is used for things other than favorites. This needs to be set elsewhere
                    DefaultsManager.shared.favoritesLastUpdated = Date()
                }
            } catch {
                completion(error)
            }
        }
    }
    
    /// Requests reach detail for a single reach, and updates the locally stored Reach
    // TODO: split this into a ReachDetail model
    public func updateReachDetail(reachId: Int, completion: @escaping (Error?) -> Void) {
        api.getReachDetail(reachId: reachId) { detail, error in
            guard
                let detail = detail,
                error == nil
            else {
                completion(error)
                return
            }
            
            do {
                try DB.shared.write { db in
                    try self.updateDetail(reachId: reachId, details: detail, database: db)
                }
            } catch {
                completion(error)
            }
        }
    }
    
    private func createOrUpdateReaches(newReaches: [AWApiReachHelper.AWReach], database db: Database) throws {
        for newReach in newReaches { 
            guard let id = newReach.id else {
                continue
            }
            
            let existingReach = try? Reach.fetchOne(db, id: id)
            let difficultyRange = DifficultyHelper.parseDifficulty(difficulty: newReach.classRating ?? existingReach?.classRating ?? "")
            
            // FIXME: what a mess, pull into funcs on model objects
            // FIXME: and split into Reach/Details/Favorites?
            let reach = Reach(
                id: id,
                createdAt: Date(),
                altname: newReach.altname ?? existingReach?.altname,
                avgGradient: newReach.detailAverageGradient ?? existingReach?.avgGradient ?? 0,
                maxGradient: existingReach?.maxGradient ?? 0, // not available from response
                condition: newReach.cond ?? existingReach?.condition,
                county: newReach.county ?? existingReach?.county,
                currentGageReading: newReach.gauge_reading ?? existingReach?.currentGageReading,
                delta: newReach.reading_delta ?? existingReach?.delta,
                description: newReach.detailDescription ?? existingReach?.description,
                detailUpdated: existingReach?.detailUpdated, // FIXME: never set
                classRating: newReach.classRating ?? existingReach?.classRating,
                isClass1: difficultyRange.contains(1),
                isClass2: difficultyRange.contains(2),
                isClass3: difficultyRange.contains(3),
                isClass4: difficultyRange.contains(4),
                isClass5: difficultyRange.contains(5),
                favorite: existingReach?.favorite ?? false,
                gageId: newReach.gauge_id ?? existingReach?.gageId,
                gageMax: newReach.gauge_max ?? existingReach?.gageMax,
                gageMetric: newReach.gauge_metric ?? existingReach?.gageMetric ?? -1,
                gageMin: newReach.gauge_min ?? existingReach?.gageMin,
                gageUpdated: dateFromTimeAgoInSeconds(newReach.last_gauge_updated) ?? existingReach?.gageUpdated,
                lastGageReading: newReach.last_gauge_reading ?? existingReach?.lastGageReading,
                length: Double(newReach.detailLength ?? "") ?? existingReach?.length,
                name: newReach.name ?? existingReach?.name,
                photoId: existingReach?.photoId ?? 0, //FIXME: not available
                putInLat: Double(newReach.plat ?? "") ?? existingReach?.putInLat,
                putInLon: Double(newReach.plon ?? "") ?? existingReach?.putInLon,
                takeOutLat: Double(newReach.tlat ?? "") ?? existingReach?.takeOutLat,
                takeOutLon: Double(newReach.tlon ?? "") ?? existingReach?.takeOutLon,
                rc: newReach.rc ?? existingReach?.rc,
                river: newReach.river ?? existingReach?.river,
                section: newReach.section ?? existingReach?.section,
                shuttleDetails: newReach.detailShuttleDescription ?? existingReach?.shuttleDetails,
                state: newReach.state ?? existingReach?.state,
                unit: newReach.unit ?? existingReach?.unit ?? existingReach?.unit,
                zipcode: newReach.zipcode ?? existingReach?.zipcode
            )
            
            try reach.save(db)
        }
    }
    
    private func updateDetail(reachId: Int, details: AWApiReachHelper.AWReachDetail, database db: Database) throws {
        guard var reach = try Reach.fetchOne(db, id: reachId) else {
            throw Errors.noMatchingReach
        }
        
        reach.avgGradient = details.detailAverageGradient ?? 0
        reach.photoId = details.detailPhotoId ?? 0
        reach.maxGradient = details.detailMaxGradient ?? 0
        reach.length = Double(details.detailLength ?? "")
        reach.description = details.detailDescription
        reach.shuttleDetails = details.detailShuttleDescription
        reach.detailUpdated = Date()
        
        try reach.save(db)
        
        if let rapidsList = details.detailRapids {
            // Remove existing rapids for reach -- this will keep server side deletions in sync
            try Rapid.filter(Rapid.Columns.reachId == reach.id).deleteAll(db)
            
            // Re-add rapids
            try rapidsList
                .map { rapid(awRapid: $0, reach: reach) }
                .forEach { try $0.save(db) }
        }
    }
    
    // TODO: rapid creation
    private func rapid(awRapid: AWApiReachHelper.AWRapid, reach: Reach) -> Rapid {
        Rapid(
            id: awRapid.rapidId,
            reachId: reach.id,
            name: awRapid.name,
            description: awRapid.description,
            classRating: awRapid.difficulty,
            isHazard: awRapid.isHazard,
            isPlaySpot: awRapid.isPlaySpot,
            isPortage: awRapid.isPortage,
            isPutIn: awRapid.isPutIn,
            isTakeOut: awRapid.isTakeOut,
            isWaterfall: awRapid.isWaterfall,
            lat: Double(awRapid.rapidLatitude ?? ""),
            lon: Double(awRapid.rapidLongitude ?? "")
        )
    }
    
    //
    // MARK: - Helpers
    //
    
    private func dateFromTimeAgoInSeconds(_ timeString: String?) -> Date? {
        guard
            let timeString = timeString,
            let seconds = Double(timeString)
        else {
            return nil
        }
        
        return Date(timeIntervalSinceNow: -seconds)
    }

    
    //
    // MARK: - Errors
    //
    
    enum Errors: Error {
        case alreadyFetchingReaches
        case noMatchingReach
    }
}
