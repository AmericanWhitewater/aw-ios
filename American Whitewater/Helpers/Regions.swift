import Foundation

struct Region {
    let code: String
    let title: String
    let country: String
    let apiResponse: String
    
    static let all: [Region] = [
        Region(code: "stAL", title: "Alabama", country: "US", apiResponse: "USA-ALB"),
        Region(code: "stAK", title: "Alaska", country: "US", apiResponse: "USA-ALK"),
        Region(code: "stAZ", title: "Arizona", country: "US", apiResponse: "USA-ARZ"),
        Region(code: "stAR", title: "Arkansas", country: "US", apiResponse: "USA-ARK"),
        Region(code: "stCA", title: "California", country: "US", apiResponse: "USA-CAL"),
        Region(code: "stCO", title: "Colorado", country: "US", apiResponse: "USA-COL"),
        Region(code: "stCT", title: "Connecticut", country: "US", apiResponse: "USA-CNN"),
        Region(code: "stDE", title: "Delaware", country: "US", apiResponse: "USA-DEL"),
        Region(code: "stDC", title: "District of Columbia", country: "US", apiResponse: "USA-DOC"),
        Region(code: "stFL", title: "Florida", country: "US", apiResponse: "USA-FLA"),
        Region(code: "stGA", title: "Georgia", country: "US", apiResponse: "USA-GEO"),
        Region(code: "stHI", title: "Hawaii", country: "US", apiResponse: "USA-HAW"),
        Region(code: "stID", title: "Idaho", country: "US", apiResponse: "USA-IDA"),
        Region(code: "stIL", title: "Illinois", country: "US", apiResponse: "USA-ILL"),
        Region(code: "stIN", title: "Indiana", country: "US", apiResponse: "USA-IND"),
        Region(code: "stIA", title: "Iowa", country: "US", apiResponse: "USA-IOW"),
        Region(code: "stKS", title: "Kansas", country: "US", apiResponse: "USA-KAN"),
        Region(code: "stKY", title: "Kentucky", country: "US", apiResponse: "USA-KEN"),
        Region(code: "stLA", title: "Louisiana", country: "US", apiResponse: "USA-LOU"),
        Region(code: "stME", title: "Maine", country: "US", apiResponse: "USA-MAI"),
        Region(code: "stMD", title: "Maryland", country: "US", apiResponse: "USA-MRY"),
        Region(code: "stMA", title: "Massachusetts", country: "US", apiResponse: "USA-MSS"),
        Region(code: "stMI", title: "Michigan", country: "US", apiResponse: "USA-MCH"),
        Region(code: "stMN", title: "Minnesota", country: "US", apiResponse: "USA-MNN"),
        Region(code: "stMS", title: "Mississippi", country: "US", apiResponse: "USA-MSP"),
        Region(code: "stMO", title: "Missouri", country: "US", apiResponse: "USA-MOS"),
        Region(code: "stMT", title: "Montana", country: "US", apiResponse: "USA-MNT"),
        Region(code: "stNE", title: "Nebraska", country: "US", apiResponse: "USA-NEB"),
        Region(code: "stNV", title: "Nevada", country: "US", apiResponse: "USA-NEV"),
        Region(code: "stNH", title: "New Hampshire", country: "US", apiResponse: "USA-NHM"),
        Region(code: "stNJ", title: "New Jersey", country: "US", apiResponse: "USA-NJR"),
        Region(code: "stNM", title: "New Mexico", country: "US", apiResponse: "USA-NME"),
        Region(code: "stNY", title: "New York", country: "US", apiResponse: "USA-NYO"),
        Region(code: "stNC", title: "North Carolina", country: "US", apiResponse: "USA-NCR"),
        Region(code: "stND", title: "North Dakota", country: "US", apiResponse: "USA-NDA"),
        Region(code: "stOH", title: "Ohio", country: "US", apiResponse: "USA-OHI"),
        Region(code: "stOK", title: "Oklahoma", country: "US", apiResponse: "USA-OKL"),
        Region(code: "stOR", title: "Oregon", country: "US", apiResponse: "USA-ORE"),
        Region(code: "stPA", title: "Pennsylvania", country: "US", apiResponse: "USA-PEN"),
        Region(code: "stPR", title: "Puerto Rico", country: "US", apiResponse: "USA-PRO"),
        Region(code: "stRI", title: "Rhode Island", country: "US", apiResponse: "USA-RHI"),
        Region(code: "stSC", title: "South Carolina", country: "US", apiResponse: "USA-SCR"),
        Region(code: "stSD", title: "South Dakota", country: "US", apiResponse: "USA-SDA"),
        Region(code: "stTN", title: "Tennessee", country: "US", apiResponse: "USA-TNN"),
        Region(code: "stTX", title: "Texas", country: "US", apiResponse: "USA-TEX"),
        Region(code: "stUT", title: "Utah", country: "US", apiResponse: "USA-UTA"),
        Region(code: "stVT", title: "Vermont", country: "US", apiResponse: "USA-VRM"),
        Region(code: "stVA", title: "Virginia", country: "US", apiResponse: "USA-VRG"),
        Region(code: "stWA", title: "Washington", country: "US", apiResponse: "USA-WSH"),
        Region(code: "stWV", title: "West Virginia", country: "US", apiResponse: "USA-WVR"),
        Region(code: "stWI", title: "Wisconsin", country: "US", apiResponse: "USA-WIS"),
        Region(code: "stWY", title: "Wyoming", country: "US", apiResponse: "USA-WYM"),
        
        /*    Region(code: "rgLP", title: "Lower Pacific", country: "US"),
         Region(code: "rgMC", title: "MidAtlantic", country: "US"),
         Region(code: "rgMW", title: "MidWest", country: "US"),
         Region(code: "rgNT", title: "North East", country: "US"),
         Region(code: "rgNW", title: "North West", country: "US"),
         Region(code: "rgSE", title: "South East", country: "US"),
         Region(code: "rgWT", title: "West", country: "US"), */
        
        //  Region(code: "stAB", title: "Alberta", country: "CA"),
        Region(code: "stBC", title: "British Columbia", country: "CA", apiResponse: "CAN-BCL"),
        Region(code: "stMB", title: "Manitoba", country: "CA", apiResponse: "CAN-MNT"),
        // Region(code: "stNB", title: "New Brunswick", country: "CA"),
        // Region(code: "stNF", title: "Newfoundland", country: "CA"),
        // Region(code: "stNS", title: "Nova Scotia", country: "CA"),
        // Region(code: "stNU", title: "Nunavut", country: "CA"),
        Region(code: "stON", title: "Ontario", country: "CA", apiResponse: "CAN-ONT"),
        // Region(code: "stPI", title: "Prince Edward Island", country: "CA"),
        Region(code: "stQC", title: "Quebec", country: "CA", apiResponse: "CAN-QUE"),
        // Region(code: "stSK", title: "Saskatchewan", country: "CA"),
        // Region(code: "stYT", title: "Yukon Territory", country: "CA"),
        Region(code: "stCR", title: "Costa Rica", country: "CS", apiResponse: "CRI-SJO"),
        Region(code: "stLV", title: "Dominican Republic", country: "DR", apiResponse: "DOM-SDM"),
        Region(code: "stMX", title: "Mexico", country: "MX", apiResponse: "MEX-DTD")
        // ,Region(code: "rgIN", title: "International", country: "N/A")
    ]
    
    static let states = all.filter { $0.country == "US" }
    static let international = all.filter { $0.country != "US" }
    
    static let grouped: [String: [Region]] = {
        var dict = Region.states.reduce(into: [:]) { dict, state in
            dict[String(state.title.first!).capitalized, default: []].append(state)
        }
        dict["International"] = Region.international
        return dict
    }()
    
    static let alphaGroupKeys: [String] = grouped.keys.sorted(by: {(first, second) in
        if second == "International" {
            return true
        } else if first == "International" {
            return false
        } else {
            return first < second
        }
    })
    
    static let apiDict = Dictionary(grouping: Region.all, by: { $0.apiResponse }).mapValues { $0.first! }
    
    func matches(searchText: String) -> Bool {
        return title.lowercased().contains(searchText.lowercased()) || country.lowercased().contains(searchText.lowercased())
    }
    
    static func regionByTitle(title: String) -> Region? {
        let regionsWithTitle = Region.all.filter { $0.title == title }
        return regionsWithTitle.first
    }
    
    static func regionByCode(code: String) -> Region? {
        let regionsWithCode = Region.all.filter { $0.code == code }
        return regionsWithCode.first
    }
}
