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
    private let stationWaitTimeRepository: StationWaitTimeRepository
    private let stationWaitTimeService: StationWaitTimeWebService

    init(pricesRepository: PriceRepository,
         pricesService: PricesWebService,
         trainsRepository: TrainRepository,
         stationWaitTimeRepository: StationWaitTimeRepository,
         stationWaitTimeService: StationWaitTimeWebService) {
        self.pricesRepository = pricesRepository
        self.pricesService = pricesService
        self.trainsRepository = trainsRepository
        self.stationWaitTimeRepository = stationWaitTimeRepository
        self.stationWaitTimeService = stationWaitTimeService
    }

    func getInformation(from departure: StationEntity, to arraival: StationEntity, complition: @escaping SuccessResponse<RouteInformation>) {
        let time = abs(departure.time - arraival.time)
        let distance = abs(departure.distance - arraival.distance)

        getPrices { tripPrices in
            let tripPrice = tripPrices.first(where: { $0.lowLimit < distance && $0.topLimit >= distance })
            complition(RouteInformation(time: time, distance: distance, price: tripPrice?.price ?? 0))
        }
    }

    func getWaitTime(inStation station: String, complition: @escaping SuccessResponse<[StationWaitTimeEntity]>) {
        let waitTime = stationWaitTimeRepository.get(inStation: station)
        guard waitTime.isEmpty else {
            complition(waitTime)
            return
        }

        stationWaitTimeService.getWaitTimes(success: { [weak self] waitTimes in
            guard let strongSelf = self else { return }
            strongSelf.stationWaitTimeRepository.add(waitTimes: waitTimes)
            let waitTimeReponse = strongSelf.stationWaitTimeRepository.get(inStation: station)
            complition(waitTimeReponse)
        }, failure: {_  in complition([])})
    }
}

extension RouteUseCaseImpl {
    func getPrices(complition: @escaping SuccessResponse<[Price]>) {
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
