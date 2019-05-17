//
//  RealmTrainStop.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/22/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

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

    required convenience init(entity: TrainStopEntity) {
        self.init()
        self.id = entity.id
        self.arraival = entity.arraival
        self.arraivalTimestamp = entity.arraivalTimestamp
        self.departure = entity.departure
        self.departureTimestamp = entity.departureTimestamp
    }
}
