//
//  TripPriceRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol PriceRepository: Repository {
    func getPrices() -> [Price]?
    func add(objects: [Price], update: Bool)
    func deleteAllPrices()
    func getPricesFromResilienceFile(complition: @escaping SuccessResponse<[Price]>)
}

class TripPriceRepositoryRealmImpl: PriceRepository, RealmRepository, ResilienceRepository {
    func getPrices() -> [Price]? {
        guard let realmActivities = get(type: RealmPrice.self) else { return nil }
        return realmActivities.map { Price(entity: $0) }
    }

    func add(objects: [Price], update: Bool) {
        let realmTripPrice = objects.map { RealmPrice(entity: $0) }
        add(objects: realmTripPrice)
    }

    func deleteAllPrices() {
        deleteAll(forType: RealmPrice.self)
    }

    func getPricesFromResilienceFile(complition: @escaping SuccessResponse<[Price]>) {
        guard let reciliencePrices: [Price] = try? load(resource: AppResources.Prices) else {
            complition([])
            return
        }
        complition(reciliencePrices)
    }
}
