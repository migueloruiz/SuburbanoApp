//
//  StationWaitTime.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationWaitTimeEntity {
    var station: String { get }
    var day: Int { get }
    var concurrence: Int { get }
    var displayTime: String { get }
    var timestamp: Int { get }
    var waitTime: Int { get }
}

struct StationWaitTime: StationWaitTimeEntity, Codable {

    let station: String
    let day: Int
    let concurrence: Int
    let displayTime: String
    let timestamp: Int
    let waitTime: Int

    enum CodingKeys: String, CodingKey {
        case station = "station"
        case day = "day"
        case concurrence = "concurrence"
        case displayTime = "time"
        case timestamp = "houre"
        case waitTime = "wait_time"
    }

    init(entity: StationWaitTimeEntity) {
        self.station = entity.station
        self.day = entity.day
        self.concurrence = entity.concurrence
        self.displayTime = entity.displayTime
        self.timestamp = entity.timestamp
        self.waitTime = entity.waitTime
    }

    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            station = try values.decode(String.self, forKey: .station)
            day = try values.decode(Int.self, forKey: .day)
            concurrence = try values.decode(Int.self, forKey: .concurrence)
            displayTime = try values.decode(String.self, forKey: .displayTime)
            timestamp = try values.decode(Int.self, forKey: .timestamp)
            waitTime = try values.decode(Int.self, forKey: .waitTime)
        } catch let jsonError {
            throw jsonError
        }
    }
}
