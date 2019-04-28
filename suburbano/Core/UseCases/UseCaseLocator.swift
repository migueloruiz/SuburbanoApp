//
//  UseCaseLocator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class UseCaseLocator {

    static func getUseCase<UseCase>(ofType type: UseCase.Type) -> UseCase? {
        switch String(describing: type) {

        case String(describing: UpdateCardsBalanceUseCase.self),
             String(describing: GetCardBalanceUseCase.self),
             String(describing: GetCardUseCase.self),
             String(describing: DeleteCardUseCase.self),
             String(describing: CardUseCase.self):
            return CardUseCaseImpl(
                cardBalanceWebService: CardBalanceWebServiceImpl(),
                cardRepository: CardRepositoryImpl()
            ) as? UseCase

        case String(describing: GetStationsUseCase.self),
             String(describing: GetTrainRailUseCase.self),
             String(describing: MapResurcesUseCase.self):
            return MapResurcesUseCaseImpl(mapResurcesRepository: MapResurcesRepositoryImpl()) as? UseCase

        case String(describing: GetRouteInformationUseCase.self),
             String(describing: GetRouteWaitTimeUseCase.self),
             String(describing: RouteUseCase.self):
            return RouteUseCaseImpl(pricesRepository: TripPriceRepositoryRealmImpl(),
                                    pricesService: PricesWebServiceImpl(),
                                    trainsRepository: TrainRepositoryImpl(),
                                    stationWaitTimeRepository: StationWaitTimeRepositoryImpl(),
                                    stationWaitTimeService: StationWaitTimeWebServiceImpl()) as? UseCase
        default:
            return nil
        }
    }
}
