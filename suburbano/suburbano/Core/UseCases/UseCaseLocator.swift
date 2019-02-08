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
                cardRepository: CardRepository(realmHandler: RealmHandler.shared)
            ) as? UseCase

        case String(describing: GetStationsUseCase.self),
             String(describing: LoadStationsUseCase.self),
             String(describing: StationsUseCase.self):
            return StationsUseCaseImpl(resilienceHandler: ResilienceFileHandlerImpl()) as? UseCase

        case String(describing: GetRouteInformationUseCase.self),
             String(describing: GetRouteScheduleUseCase.self),
             String(describing: GetRouteWaitTimeUseCase.self),
             String(describing: RouteUseCase.self):
            return RouteUseCaseImpl(pricesRepository: TripPriceRepositoryRealmImpl(realmHandler: RealmHandler.shared),
                                    pricesService: PricesWebServiceImpl(),
                                    trainsService: TrainsWebSerciveImpl(),
                                    trainsRepository: TrainRepositoryRealmImpl(realmHandler: RealmHandler.shared),
                                    stationWaitTimeRepository: StationWaitTimeRepositoryImpl(realmHandler: RealmHandler.shared),
                                    stationWaitTimeService: StationWaitTimeWebServiceImpl(),
                                    resilienceHandler: ResilienceFileHandlerImpl()) as? UseCase
        default:
            return nil
        }
    }
}
