//
//  TripPriceRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol TripPriceRepository {
    func get(predicateFormat: NSPredicate?) -> [TripPrice]?
    func add(objects: [TripPrice], update: Bool)
    func deleteAll()
}

class TripPriceRepositoryRealmImpl: TripPriceRepository {

    let realmHandler: RealmHandler

    init(realmHandler: RealmHandler) {
        self.realmHandler = realmHandler
    }

    func get(predicateFormat: NSPredicate? = nil) -> [TripPrice]? {
        guard let realmActivities = realmHandler.get(type: RealmTripPrice.self, predicateFormat: predicateFormat) else { return nil }
        return realmActivities.map { TripPrice(realmObject: $0) }
    }

    func add(objects: [TripPrice], update: Bool) {
        let realmTripPrice = objects.map { RealmTripPrice.make(from: $0) }
        realmHandler.add(objects: realmTripPrice)
    }

    func deleteAll() {
        realmHandler.deleteAll(forType: RealmTripPrice.self)
    }
}
