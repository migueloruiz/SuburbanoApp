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

protocol GetRouteInformationUseCase {
    func getInformation(from departure: StationEntity, to arraival: StationEntity, complition: @escaping RouteInformationResponse)
}

protocol GetRouteScheduleUseCase {
    func getSchedule(from departure: StationEntity, to arraival: StationEntity, day: TripDay, complition: @escaping TrainResponse)
}

protocol RouteUseCase: GetRouteInformationUseCase, GetRouteScheduleUseCase { }

class RouteUseCaseImpl: RouteUseCase {
    
    struct Constants {
        static let fileName = "prices"
    }
    
    private let pricesRepository: TripPriceRepository
    private let pricesService: PricesWebService
    private let trainsService: TrainsWebSercive
    private let trainsRepository: TrainRepository
    private let resilienceHandler: ResilienceFileHandler
    
    init(pricesRepository: TripPriceRepository,
         pricesService: PricesWebService,
         trainsService: TrainsWebSercive,
         trainsRepository: TrainRepository,
         resilienceHandler: ResilienceFileHandler) {
        self.pricesRepository = pricesRepository
        self.pricesService = pricesService
        self.trainsService = trainsService
        self.trainsRepository = trainsRepository
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
