//
//  RouteUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

struct RouteInformation {
    let time: Int
    let distance: Float
    let price: Float
}

protocol GetRouteInformationUseCase {
    func getInformation(from departure: StationEntity, to arraival: StationEntity, complition:  @escaping SuccessResponse<RouteInformation>)
}

protocol GetRouteScheduleUseCase {
    func getSchedule(from departure: StationEntity, to arraival: StationEntity, day: TripDay, complition: @escaping SuccessResponse<[TrainEntity]>)
}

protocol GetRouteWaitTimeUseCase {
    func getWaitTime(inStation station: String, complition: @escaping SuccessResponse<[StationWaitTimeEntity]>)
}

protocol RouteUseCase: GetRouteInformationUseCase, GetRouteScheduleUseCase, GetRouteWaitTimeUseCase { }

class RouteUseCaseImpl: RouteUseCase {

    struct Constants {
        static let fileName = "prices"
    }

    private let pricesRepository: TripPriceRepository
    private let pricesService: PricesWebService
    private let trainsService: TrainsWebSercive
    private let trainsRepository: TrainRepository
    private let stationWaitTimeRepository: StationWaitTimeRepository
    private let stationWaitTimeService: StationWaitTimeWebService
    private let resilienceHandler: ResilienceFileHandler

    init(pricesRepository: TripPriceRepository,
         pricesService: PricesWebService,
         trainsService: TrainsWebSercive,
         trainsRepository: TrainRepository,
         stationWaitTimeRepository: StationWaitTimeRepository,
         stationWaitTimeService: StationWaitTimeWebService,
         resilienceHandler: ResilienceFileHandler) {
        self.pricesRepository = pricesRepository
        self.pricesService = pricesService
        self.trainsService = trainsService
        self.trainsRepository = trainsRepository
        self.stationWaitTimeRepository = stationWaitTimeRepository
        self.stationWaitTimeService = stationWaitTimeService
        self.resilienceHandler = resilienceHandler
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
            strongSelf.stationWaitTimeRepository.add(objects: waitTimes)
            let waitTimeReponse = strongSelf.stationWaitTimeRepository.get(inStation: station)
            complition(waitTimeReponse)
        }, failure: {_  in complition([])})
    }

    func getSchedule(from departure: StationEntity, to arraival: StationEntity, day: TripDay, complition: @escaping SuccessResponse<[TrainEntity]>) {
        let direction = TrainDirection.get(from: departure, to: arraival)
        let trains = trainsRepository.get(withDirection: direction.rawValue, day: day.rawValue)

        guard trains.isEmpty else {
            complition(trains)
            return
        }

        trainsService.getTrains(success: { [weak self] trains in
            guard let strongSelf = self else { return }
            strongSelf.trainsRepository.add(objects: trains, update: true)
            let result = strongSelf.trainsRepository.get(withDirection: "North", day: "Normal") as? [Train]
            complition(result ?? [])
        }, failure: { _ in complition([]) })
    }
}

extension RouteUseCaseImpl {
    func getPrices(complition: @escaping SuccessResponse<[TripPrice]>) {
        guard let cachedPrices = pricesRepository.get(predicateFormat: nil), !cachedPrices.isEmpty else {
            getPricesFromService(complition: complition)
            return
        }
        complition(cachedPrices)
    }

    private func getPricesFromService(complition: @escaping SuccessResponse<[TripPrice]>) {
        pricesService.getPrices(success: { [weak self] prices in
            guard let strongSelf = self else { return }
            strongSelf.pricesRepository.add(objects: prices, update: true)
            complition(prices)
        }, failure: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.getPricesFromResilienceFile(complition: complition)
        })
    }

    private func getPricesFromResilienceFile(complition: @escaping SuccessResponse<[TripPrice]>) {
        guard let rawPrices = resilienceHandler.loadLocalJSON(from: Constants.fileName),
            let reciliencePrices = try? JSONDecoder().decode([TripPrice].self, from: rawPrices) else {
            complition([])
            return
        }
        complition(reciliencePrices)
    }

}
