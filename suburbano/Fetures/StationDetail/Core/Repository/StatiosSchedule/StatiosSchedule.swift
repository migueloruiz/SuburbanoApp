//
//  StatiosSchedule.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/10/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

protocol StatiosScheduleEntity {
    var id: String { get }
    var order: Int { get }
    var openTime: String { get }
    var closeTime: String { get }

    init(entity: StatiosScheduleEntity)
}

struct StatiosSchedule: StatiosScheduleEntity, Codable {
    let id: String
    let order: Int
    let openTime: String
    let closeTime: String

    init(entity: StatiosScheduleEntity) {
        self.id = entity.id
        self.order = entity.order
        self.openTime = entity.openTime
        self.closeTime = entity.closeTime
    }
}
