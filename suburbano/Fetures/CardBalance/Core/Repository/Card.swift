//
//  Card.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import UIKit

protocol CardEntity {
    var id: String { get }
    var balance: String { get }
    var icon: String { get }
    var color: Data { get }
    var displayDate: String { get }
    var date: Double { get }

    init(entity: CardEntity)
}

struct Card: CardEntity, Codable {
    let id: String
    var balance: String
    var icon: String
    var color: Data
    var displayDate: String
    var date: Double
}

extension Card {
    init(entity: CardEntity) {
        self.id = entity.id
        self.balance = entity.balance
        self.icon = entity.icon
        self.color = entity.color
        self.displayDate = entity.displayDate
        self.date = entity.date
    }

    init(id: String, icon: String, color: Data) {
        self.id = id
        self.balance = ""
        self.icon = icon
        self.color = color
        self.displayDate = ""
        self.date = 0
    }
}
