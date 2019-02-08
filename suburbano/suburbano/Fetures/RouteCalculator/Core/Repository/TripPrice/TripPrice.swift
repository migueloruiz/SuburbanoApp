//
//  TripPrice.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Entity
protocol TripPriceEntity {
    var type: String { get }
    var price: Float { get }
    var lowLimit: Float { get }
    var topLimit: Float { get }
}

// MARK: Struct
struct TripPrice: TripPriceEntity, Codable {
    let type: String
    let price: Float
    let lowLimit: Float
    let topLimit: Float

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case price = "price"
        case lowLimit = "low_limit"
        case topLimit = "top_limit"
    }

    init(realmObject: RealmTripPrice) {
        self.type = realmObject.type
        self.price = realmObject.price
        self.lowLimit = realmObject.lowLimit
        self.topLimit = realmObject.topLimit
    }

    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            type = try values.decode(String.self, forKey: .type)
            price = try values.decode(Float.self, forKey: .price)
            lowLimit = try values.decode(Float.self, forKey: .lowLimit)
            topLimit = try values.decode(Float.self, forKey: .topLimit)
        } catch let jsonError {
            throw jsonError
        }
    }
}

// MARK: Realm
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
