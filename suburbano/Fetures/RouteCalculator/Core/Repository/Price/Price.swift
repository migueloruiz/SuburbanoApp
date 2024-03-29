//
//  TripPrice.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol PriceEntity {
    var type: String { get }
    var price: Float { get }
    var lowLimit: Float { get }
    var topLimit: Float { get }

    init(entity: PriceEntity)
}

struct Price: PriceEntity, Codable {
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

    init(entity: PriceEntity) {
        type = entity.type
        price = entity.price
        lowLimit = entity.lowLimit
        topLimit = entity.topLimit
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
