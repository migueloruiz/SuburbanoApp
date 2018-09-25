//
//  StationWaitTime.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Entity
protocol StationWaitTimeEntity {
    var station: String { get }
    var day: Int { get }
    var concurence: Int { get }
    var displayTime: String { get }
    var timestap: Int { get }
}

// MARK: Struct
struct StationWaitTime: StationWaitTimeEntity, Codable {
    let station: String
    let day: Int
    let concurence: Int
    let displayTime: String
    let timestap: Int
    
    enum CodingKeys: String, CodingKey {
        case station = "station"
        case day = "day"
        case concurence = "concurence"
        case displayTime = "time"
        case timestap = "houre"
    }
    
    init(entity: StationWaitTimeEntity) {
        self.station = entity.station
        self.day = entity.day
        self.concurence = entity.concurence
        self.displayTime = entity.displayTime
        self.timestap = entity.timestap
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            station = try values.decode(String.self, forKey: .station)
            day = try values.decode(Int.self, forKey: .day)
            concurence = try values.decode(Int.self, forKey: .concurence)
            displayTime = try values.decode(String.self, forKey: .displayTime)
            timestap = try values.decode(Int.self, forKey: .timestap)
        } catch let jsonError {
            throw jsonError
        }
    }
}

// MARK: Realm

class RealmStationWaitTime: Object, StationWaitTimeEntity {
    @objc dynamic var id: String = ""
    @objc dynamic var concurence: Int = 0
    @objc dynamic var displayTime: String = ""
    
    @objc dynamic var station: String = "" {
        didSet {
            id = "\(station)-\(day)-\(timestap)"
        }
    }
    
    @objc dynamic var day: Int = 0 {
        didSet {
            id = "\(station)-\(day)-\(timestap)"
        }
    }
    
    @objc dynamic var timestap: Int = 0 {
        didSet {
            id = "\(station)-\(day)-\(timestap)"
        }
    }
    
    override class func primaryKey() -> String? { return "id" }
    override static func indexedProperties() -> [String] {
        return ["station", "day", "timestap"]
    }
    
    convenience init(entity: StationWaitTimeEntity) {
        self.init()
        self.station = entity.station
        self.day = entity.day
        self.concurence = entity.concurence
        self.displayTime = entity.displayTime
        self.timestap = entity.timestap
    }
}
