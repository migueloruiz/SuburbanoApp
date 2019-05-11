//
//  RealmStationWaitTime.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/23/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStationChartData: Object, StationChartDataEntity {
    @objc dynamic var id: String = ""
    @objc dynamic var concurrence: Int = 0
    @objc dynamic var displayTime: String = ""
    @objc dynamic var waitTime: Int = 0
    @objc dynamic var station: String = ""
    @objc dynamic var day: Int = 0
    @objc dynamic var timestamp: Int = 0

    override class func primaryKey() -> String? { return "id" }
    override static func indexedProperties() -> [String] {
        return ["station", "day", "timestamp"]
    }

    convenience init(entity: StationChartDataEntity) {
        self.init()
        self.id = "\(entity.station)-\(entity.day)-\(entity.timestamp)"
        self.station = entity.station
        self.day = entity.day
        self.concurrence = entity.concurrence
        self.displayTime = entity.displayTime
        self.timestamp = entity.timestamp
        self.waitTime = entity.waitTime
    }
}
