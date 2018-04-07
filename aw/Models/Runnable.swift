//
//  Runnable.swift
//  aw
//
//  Created by Alex Kerney on 4/7/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation

/*
 "11036"    "" - unknown

 "196"    "H0" - "Above Recommended" - "Too high"
 "1373"    "H1"
 "3461"    "H2"
 "2348"    "H3"
 "299"    "H4"
 "188"    "H5"
 "1116"    "H6"
 "2391"    "H7"
 "5244"    "H8"
 "3807"    "H9"

 "61"    "L0" - "Below Recommended" - "Too low"
 "1256"    "L1"
 "10185"    "L2"
 "3063"    "L3"
 "1403"    "L4"
 "3954"    "L5"
 "6650"    "L6"
 "1157"    "L7"
 "3468"    "L8"
 "1703"    "L9"

 "11037"    "R0" - "Lower Runnable" - "running"
 "697"    "R1"
 "3801"    "R2"
 "3865"    "R3" - "Runnable"
 "2433"    "R4"
 "3754"    "R5"
 "2417"    "R6"
 "2111"    "R7" - "Upper Runnable"
 "91"    "R8"
 "3436"    "R9"
 */

struct Runnable {
    static func fromRc(rcString: String) -> String {
        switch rcString {
        case "H0", "H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9":
            return "Above Recommended"
        case "L0", "L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8", "L9":
            return "Below Recommended"
        case "R0", "R1", "R2":
            return "Lower Runnable"
        case "R3", "R4", "R5", "R6":
            return "Runnable"
        case "R7", "R8", "R9":
            return "Upper Runnable"
        default:
            return ""
        }
    }
}
