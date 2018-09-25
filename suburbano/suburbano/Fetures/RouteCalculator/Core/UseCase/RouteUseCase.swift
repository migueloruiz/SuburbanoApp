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

typealias RouteInformationResponse = (RouteInformation) -> Void
typealias TripPriceResponse = ([TripPriceEntity]) -> Void
typealias TrainResponse = ([TrainEntity]) -> Void
typealias WaitTimeResponse = ([StationWaitTimeEntity]) -> Void

protocol GetRouteInformationUseCase {
    func getInformation(from departure: StationEntity, to arraival: StationEntity, complition: @escaping RouteInformationResponse)
}

protocol GetRouteScheduleUseCase {
    func getSchedule(from departure: StationEntity, to arraival: StationEntity, day: TripDay, complition: @escaping TrainResponse)
}

protocol GetRouteWaitTimeUseCase {
    func getWaitTime(inStation station: String, complition: @escaping WaitTimeResponse)
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
    
    func getInformation(from departure: StationEntity, to arraival: StationEntity, complition: @escaping RouteInformationResponse) {
        let time = abs(departure.time - arraival.time)
        let distance = abs(departure.distance - arraival.distance)
        
        getPrices { tripPrices in
            let tripPrice = tripPrices.first(where: { $0.lowLimit < distance && $0.topLimit >= distance })
            complition(RouteInformation(time: time, distance: distance, price: tripPrice?.price ?? 0))
        }
    }
    
    func getWaitTime(inStation station: String, complition: @escaping WaitTimeResponse) {
        let waitTime = stationWaitTimeRepository.get(inStation: station)
        guard waitTime.isEmpty else {
            complition(waitTime)
            return
        }
        stationWaitTimeService.getWaitTimes { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let response, _):
                strongSelf.stationWaitTimeRepository.add(objects: response)
                let waitTimeReponse = strongSelf.stationWaitTimeRepository.get(inStation: station)
                complition(waitTimeReponse)
            case .failure:
                complition([])
            }
        }
    }
    
    func getSchedule(from departure: StationEntity, to arraival: StationEntity, day: TripDay, complition: @escaping TrainResponse) {
        let direction = TrainDirection.get(from: departure, to: arraival)

        guard let trains = trainsRepository.get(withDirection: direction.rawValue, day: day.rawValue) as? [Train],
            !trains.isEmpty else {
                trainsService.getTrains { [weak self] (response) in
                    guard let strongSelf = self else { return }
                    switch response {
                    case .success(let trains, _):
                        strongSelf.trainsRepository.add(objects: trains, update: true)
                        let result = strongSelf.trainsRepository.get(withDirection: "North", day: "Normal") as? [Train]
                        complition(result ?? [])
                    case .failure:
                        complition([])
                    }
                }
            return
        }
        complition(trains)
    }
}

extension RouteUseCaseImpl {
    func getPrices(complition: @escaping TripPriceResponse) {
        guard let cachedPrices = pricesRepository.get(predicateFormat: nil), !cachedPrices.isEmpty else {
            getPricesFromService(complition: complition)
            return
        }
        complition(cachedPrices)
    }
    
    private func getPricesFromService(complition: @escaping TripPriceResponse) {
        pricesService.getPrices { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let prices, _):
                strongSelf.pricesRepository.add(objects: prices, update: true)
                complition(prices)
            case .failure:
                strongSelf.getPricesFromResilienceFile(complition: complition)
            }
        }
    }
    
    private func getPricesFromResilienceFile(complition: @escaping TripPriceResponse) {
        guard let rawSattions = resilienceHandler.loadLocalJSON(from: Constants.fileName),
            let reciliencePrices = try? JSONDecoder().decode([TripPrice].self, from: rawSattions) else {
            complition([])
            return
        }
        complition(reciliencePrices)
    }

}
