//
//  TrainStop.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Entity
protocol TrainStopEntity {
    var id: String { get }
    var arraival: String? { get }
    var arraivalTimestamp: Int? { get }
    var departure: String? { get }
    var departureTimestamp: Int? { get }
}

// MARK: Struct
struct TrainStop: TrainStopEntity, Codable {
    let id: String
    let arraival: String?
    let arraivalTimestamp: Int?
    let departure: String?
    let departureTimestamp: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case arraival = "arraival"
        case arraivalTimestamp = "arraival_timestamp"
        case departure = "departure"
        case departureTimestamp = "departure_timestamp"
    }
    
    init(id: String) {
        self.id = id
        self.arraival = nil
        self.arraivalTimestamp = nil
        self.departure = nil
        self.departureTimestamp = nil
    }
    
    init(entity: TrainStopEntity) {
        self.id = entity.id
        self.arraival = entity.arraival
        self.arraivalTimestamp = entity.arraivalTimestamp
        self.departure = entity.departure
        self.departureTimestamp = entity.departureTimestamp
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            arraival = try values.decodeIfPresent(String.self, forKey: .arraival)
            arraivalTimestamp = try values.decodeIfPresent(Int.self, forKey: .arraivalTimestamp)
            departure = try values.decodeIfPresent(String.self, forKey: .departure)
            departureTimestamp = try values.decodeIfPresent(Int.self, forKey: .departureTimestamp)
        } catch let jsonError {
            throw jsonError
        }
    }
}

// MARK: Realm
class RealmTrainStop: Object, TrainStopEntity {
    @objc dynamic var id: String = ""
    @objc dynamic var arraival: String?
    @objc dynamic var rawArraivalTimestamp: NSNumber? = 0
    @objc dynamic var departure: String?
    @objc dynamic var rawDepartureTimestamp: NSNumber? = 0
    
    var arraivalTimestamp: Int? {
        get {
            return rawArraivalTimestamp as? Int
        }
        set(newValue) {
            rawArraivalTimestamp = newValue as NSNumber?
        }
    }
    
    var departureTimestamp: Int? {
        get {
            return rawDepartureTimestamp as? Int
        }
        set(newValue) {
            rawDepartureTimestamp = newValue as NSNumber?
        }
    }
    
    override class func primaryKey() -> String? { return "id" }
    
    convenience init(entity: TrainStopEntity? = nil) {
        self.init()
        guard let safeEntity = entity else { return }
        self.id = safeEntity.id
        self.arraival = safeEntity.arraival
        self.arraivalTimestamp = safeEntity.arraivalTimestamp
        self.departure = safeEntity.departure
        self.departureTimestamp = safeEntity.departureTimestamp
    }
}
