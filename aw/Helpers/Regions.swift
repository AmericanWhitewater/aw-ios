//
//  Regions.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation

struct Region {
    let code: String
    let title: String
    let country: String
    
    static let all: [Region] = [
        Region(code: "stAL", title: "Alabama", country: "US"),
        Region(code: "stAK", title: "Alaska", country: "US"),
        Region(code: "stAZ", title: "Arizona", country: "US"),
        Region(code: "stAR", title: "Arkansas", country: "US"),
        Region(code: "stCA", title: "California", country: "US"),
        Region(code: "stCO", title: "Colorado", country: "US"),
        Region(code: "stCT", title: "Connecticut", country: "US"),
        Region(code: "stDE", title: "Delaware", country: "US"),
        Region(code: "stDC", title: "District of Columbia", country: "US"),
        Region(code: "stFL", title: "Florida", country: "US"),
        Region(code: "stGA", title: "Georgia", country: "US"),
        Region(code: "stHI", title: "Hawaii", country: "US"),
        Region(code: "stID", title: "Idaho", country: "US"),
        Region(code: "stIL", title: "Illinois", country: "US"),
        Region(code: "stIN", title: "Indiana", country: "US"),
        Region(code: "stIA", title: "Iowa", country: "US"),
        Region(code: "stKS", title: "Kansas", country: "US"),
        Region(code: "stKY", title: "Kentucky", country: "US"),
        Region(code: "stLA", title: "Louisiana", country: "US"),
        Region(code: "stME", title: "Maine", country: "US"),
        Region(code: "stMD", title: "Maryland", country: "US"),
        Region(code: "stMA", title: "Massachusetts", country: "US"),
        Region(code: "stMI", title: "Michigan", country: "US"),
        Region(code: "stMN", title: "Minnesota", country: "US"),
        Region(code: "stMS", title: "Mississippi", country: "US"),
        Region(code: "stMO", title: "Missouri", country: "US"),
        Region(code: "stMT", title: "Montana", country: "US"),
        Region(code: "stNE", title: "Nebraska", country: "US"),
        Region(code: "stNV", title: "Nevada", country: "US"),
        Region(code: "stNH", title: "New Hampshire", country: "US"),
        Region(code: "stNJ", title: "New Jersey", country: "US"),
        Region(code: "stNM", title: "New Mexico", country: "US"),
        Region(code: "stNY", title: "New York", country: "US"),
        Region(code: "stNC", title: "North Carolina", country: "US"),
        Region(code: "stND", title: "North Dakota", country: "US"),
        Region(code: "stOH", title: "Ohio", country: "US"),
        Region(code: "stOK", title: "Oklahoma", country: "US"),
        Region(code: "stOR", title: "Oregon", country: "US"),
        Region(code: "stPA", title: "Pennsylvania", country: "US"),
        Region(code: "stPR", title: "Puerto Rico", country: "US"),
        Region(code: "stRI", title: "Rhode Island", country: "US"),
        Region(code: "stSC", title: "South Carolina", country: "US"),
        Region(code: "stSD", title: "South Dakota", country: "US"),
        Region(code: "stTN", title: "Tennessee", country: "US"),
        Region(code: "stTX", title: "Texas", country: "US"),
        Region(code: "stUT", title: "Utah", country: "US"),
        Region(code: "stVT", title: "Vermont", country: "US"),
        Region(code: "stVA", title: "Virginia", country: "US"),
        Region(code: "stWA", title: "Washington", country: "US"),
        Region(code: "stWV", title: "West Virginia", country: "US"),
        Region(code: "stWI", title: "Wisconsin", country: "US"),
        Region(code: "stWY", title: "Wyoming", country: "US"),
        Region(code: "rgLP", title: "Lower Pacific", country: "US"),
        Region(code: "rgMC", title: "MidAtlantic", country: "US"),
        Region(code: "rgMW", title: "MidWest", country: "US"),
        Region(code: "rgNT", title: "North East", country: "US"),
        Region(code: "rgNW", title: "North West", country: "US"),
        Region(code: "rgSE", title: "South East", country: "US"),
        Region(code: "rgWT", title: "West", country: "US"),
        Region(code: "stAB", title: "Alberta", country: "CA"),
        Region(code: "stBC", title: "British Columbia", country: "CA"),
        Region(code: "stMB", title: "Manitoba", country: "CA"),
        Region(code: "stNB", title: "New Brunswick", country: "CA"),
        Region(code: "stNF", title: "Newfoundland", country: "CA"),
        Region(code: "stNS", title: "Nova Scotia", country: "CA"),
        Region(code: "stNU", title: "Nunavut", country: "CA"),
        Region(code: "stON", title: "Ontario", country: "CA"),
        Region(code: "stPI", title: "Prince Edward Island", country: "CA"),
        Region(code: "stQC", title: "Quebec", country: "CA"),
        Region(code: "stSK", title: "Saskatchewan", country: "CA"),
        Region(code: "stYT", title: "Yukon Territory", country: "CA"),
        Region(code: "stCR", title: "Costa Rica", country: "CS"),
        Region(code: "stLV", title: "Dominican Republic", country: "DR"),
        Region(code: "stMX", title: "Mexico", country: "MX"),
        Region(code: "rgIN", title: "International", country: "N/A")
    ]
}
