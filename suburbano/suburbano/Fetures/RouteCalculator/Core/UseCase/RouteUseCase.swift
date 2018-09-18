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
typealias TripPriceResponse = ([TripPrice]) -> Void

protocol GetRouteInformationUseCase {
    func getInformation(from departure: Station, to arraival: Station, complition: @escaping RouteInformationResponse)
}

protocol GetRouteScheduleUseCase {
    func getSchedule(from departure: Station, to arraival: Station)
}

protocol RouteUseCase: GetRouteInformationUseCase, GetRouteScheduleUseCase { }

class RouteUseCaseImpl: RouteUseCase {
    
    struct Constants {
        static let fileName = "prices"
    }
    
    private let repository: TripPriceRepository
    private let service: PricesWebService
    private let resilienceHandler: ResilienceFileHandler
    
    init(repository: TripPriceRepository, service: PricesWebService, resilienceHandler: ResilienceFileHandler) {
        self.repository = repository
        self.service = service
        self.resilienceHandler = resilienceHandler
    }
    
    func getInformation(from departure: Station, to arraival: Station, complition: @escaping RouteInformationResponse) {
        let time = abs(departure.time - arraival.time)
        let distance = abs(departure.distance - arraival.distance)
        
        getPrices { tripPrices in
            let tripPrice = tripPrices.first(where: { $0.lowLimit < distance && $0.topLimit >= distance })
            complition(RouteInformation(time: time, distance: distance, price: tripPrice?.price ?? 0))
        }
    }
    
    func getSchedule(from departure: Station, to arraival: Station) {}
}

extension RouteUseCaseImpl {
    func getPrices(complition: @escaping TripPriceResponse) {
        guard let cachedPrices = repository.get(predicateFormat: nil), !cachedPrices.isEmpty else {
            getPricesFromService(complition: complition)
            return
        }
        complition(cachedPrices)
    }
    
    private func getPricesFromService(complition: @escaping TripPriceResponse) {
        service.getPrices { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let prices, _):
                strongSelf.repository.add(objects: prices, update: true)
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
