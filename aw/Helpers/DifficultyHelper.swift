//
//  DifficultyHelper.swift
//  aw
//
//  Created by Alex Kerney on 3/25/18.
//  Copyright © 2018 Alex Kerney. All rights reserved.
//

import Foundation

struct DifficultyHelper {
    enum Difficulty: String {
        case class1 = "I"
        case class2 = "II"
        case class3 = "III"
        case class4 = "IV"
        case class5 = "V"

        func toInteger() -> Int {
            switch self {
            case .class1:
                return 1
            case .class2:
                return 2
            case .class3:
                return 3
            case .class4:
                return 4
            case .class5:
                return 5
            }
        }
    }

    static func parseDifficulty(difficulty: String) -> [Int] {
        var cleanedDifficulty = difficulty.replacingOccurrences(of: "+", with: "")
        cleanedDifficulty = String(cleanedDifficulty.split(separator: "(").first!)

        var range: [Int] = []

        if cleanedDifficulty.contains("-") {
            let split = cleanedDifficulty.split(separator: "-")
            let splitDifficulties = split.compactMap { Difficulty(rawValue: String($0))}.compactMap { $0?.toInteger() }
            range = Array(splitDifficulties.first! ..< splitDifficulties.last!)
            range.append(splitDifficulties.last!)
        } else {
            if let single = Difficulty(rawValue: cleanedDifficulty)?.toInteger() {
                range.append(single)
            }
        }
        return range
    }
}
