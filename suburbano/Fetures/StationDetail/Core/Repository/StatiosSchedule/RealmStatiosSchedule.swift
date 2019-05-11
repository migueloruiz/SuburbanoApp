//
//  RealmStatiosSchedule.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/10/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStatiosSchedule: Object, StatiosScheduleEntity {
    @objc dynamic var id: String = ""
    @objc dynamic var order: Int = 0
    @objc dynamic var openTime: String = ""
    @objc dynamic var closeTime: String = ""

    override class func primaryKey() -> String? { return "id" }
    override static func indexedProperties() -> [String] {
        return ["order"]
    }

    required convenience init(entity: StatiosScheduleEntity) {
        self.init()
        self.id = entity.id
        self.order = entity.order
        self.openTime = entity.openTime
        self.closeTime = entity.closeTime
    }
}
