//
//  RouteUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/28/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

class RouteUseCaseImpl: RouteUseCase {

    private let pricesRepository: PriceRepository
    private let pricesService: PricesWebService
    private let trainsRepository: TrainRepository

    init(pricesRepository: PriceRepository,
         pricesService: PricesWebService,
         trainsRepository: TrainRepository) {
        self.pricesRepository = pricesRepository
        self.pricesService = pricesService
        self.trainsRepository = trainsRepository
    }

    func getInformation(from departure: StationEntity, to arraival: StationEntity, complition: @escaping SuccessResponse<RouteInformation>) {
        let time = abs(departure.time - arraival.time)
        let distance = abs(departure.distance - arraival.distance)

        getPrices { tripPrices in
            let tripPrice = tripPrices.first(where: { $0.lowLimit < distance && $0.topLimit >= distance })
            complition(RouteInformation(time: time, distance: distance, price: tripPrice?.price ?? 0))
        }
    }
}

extension RouteUseCaseImpl {
    private func getPrices(complition: @escaping SuccessResponse<[Price]>) {
        guard let cachedPrices = pricesRepository.getPrices(), !cachedPrices.isEmpty else {
            getPricesFromService(complition: complition)
            return
        }
        complition(cachedPrices)
    }

    private func getPricesFromService(complition: @escaping SuccessResponse<[Price]>) {
        pricesService.getPrices(success: { [weak self] prices in
            guard let strongSelf = self else { return }
            strongSelf.pricesRepository.add(objects: prices, update: true)
            complition(prices)
            }, failure: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.getPricesFromResilienceFile(complition: complition)
        })
    }

    private func getPricesFromResilienceFile(complition: @escaping SuccessResponse<[Price]>) {
        pricesRepository.getPricesFromResilienceFile(complition: complition)
    }

}
