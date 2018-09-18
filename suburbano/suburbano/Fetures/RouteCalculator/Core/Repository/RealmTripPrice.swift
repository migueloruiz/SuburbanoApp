//
//  RealmTripPrice.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTripPrice: Object, TripPriceEntity {
    @objc dynamic var type: String = ""
    @objc dynamic var price: Float = 0
    @objc dynamic var lowLimit: Float = 0
    @objc dynamic var topLimit: Float = 0
    
    override class func primaryKey() -> String? { return "type" }
}

extension RealmTripPrice {
    static func make(from entity: TripPrice) -> RealmTripPrice {
        let realmTripPrice = RealmTripPrice()
        realmTripPrice.type = entity.type
        realmTripPrice.price = entity.price
        realmTripPrice.lowLimit = entity.lowLimit
        realmTripPrice.topLimit = entity.topLimit
        return realmTripPrice
    }
}
