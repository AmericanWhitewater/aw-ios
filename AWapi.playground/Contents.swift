//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

import CoreData
import Foundation

let baseURL = "https://www.americanwhitewater.org/content/"

let riverURL = baseURL + "River/search/.json"

struct AWReachInfo: Codable {
    //swiftlint:disable:next identifier_name
    let id: Int //
    let abstract: String? //
    let avgGradient: Int16? //
    let photoId: Int32? //
    let length: String? //
    let maxGradient: Int16? //
    let description: String? //
    let shuttleDetails: String? //
    let zipcode: String?

    enum CodingKeys: String, CodingKey {
        //swiftlint:disable:next identifier_name
        case id, abstract
        case avgGradient = "avggradient"
        case photoId = "photoid"
        case length
        case maxGradient = "maxgradient"
        case description
        case shuttleDetails = "shuttledetails"
        case zipcode
    }
}

struct AWReachMain: Codable {
    let info: AWReachInfo
}

struct AWReachDetailSubResponse: Codable {
    let main: AWReachMain

    enum CodingKeys: String, CodingKey {
        case main = "CRiverMainGadgetJSON_main"
    }
}

struct AWReachDetailResponse: Codable {
    let view: AWReachDetailSubResponse

    enum CodingKeys: String, CodingKey {
        case view = "CContainerViewJSON_view"
    }
}

struct AWApiHelper {
    typealias UpdateCallback = () -> Void
    typealias ReachDetailCallback = (AWReachMain) -> Void

    static func fetchReachDetail(reachID: String, callback: @escaping ReachDetailCallback) {
        let url = URL(string: "https://www.americanwhitewater.org/content/River/detail/id/\(reachID)/.json")!

        let task = URLSession.shared.dataTask(with: url) { dataOptional, response, error in
            let decoder = JSONDecoder()

            guard let data = dataOptional,
                let detail = try? decoder.decode(AWReachDetailResponse.self, from: data) else {
                    print("Unable to decode \(reachID)")
                    if let data = dataOptional, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("info:")
                        print(json)
                    } else {
                        print("JSONSerilization can't unwrap it")
                    }
                    return

            }
            callback(detail.view.main)
        }
        task.resume()
    }
}

AWApiHelper.fetchReachDetail(reachID: "10647") { (reach) in
    print("fetched sucessfully")
    print(reach)
}
