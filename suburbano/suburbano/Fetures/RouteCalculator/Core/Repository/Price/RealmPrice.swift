//
//  RealmPrice.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/23/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPrice: Object, PriceEntity {

    @objc dynamic var type: String = ""
    @objc dynamic var price: Float = 0
    @objc dynamic var lowLimit: Float = 0
    @objc dynamic var topLimit: Float = 0

    override class func primaryKey() -> String? { return "type" }

    required convenience init(entity: PriceEntity) {
        self.init()
        type = entity.type
        price = entity.price
        lowLimit = entity.lowLimit
        topLimit = entity.topLimit
    }
}
