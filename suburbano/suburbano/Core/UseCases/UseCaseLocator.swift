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
        case String(describing: UpdateActivitiesUseCase.self),
             String(describing: GetActivitiesUseCase.self),
             String(describing: ActivitiesUseCase.self):
            return ActivitiesUseCaseImpl(
                activitiesWebService: ActivitiesWebServiceImpl(),
                activitiesRepository: ActivitiesRepository(realmHandler: RealmHandler())
            ) as? UseCase

        case String(describing: UpdateCardsBalanceUseCase.self),
             String(describing: GetCardBalanceUseCase.self),
             String(describing: GetCardUseCase.self),
             String(describing: DeleteCardUseCase.self),
             String(describing: CardUseCase.self):
            return CardUseCaseImpl(
                cardBalanceWebService: CardBalanceWebServiceImpl(),
                cardRepository: CardRepository(realmHandler: RealmHandler())
            ) as? UseCase
            
        case String(describing: GetStationsUseCase.self),
             String(describing: LoadStationsUseCase.self),
             String(describing: StationsUseCase.self):
            return StationsUseCaseImpl(resilienceHandler: ResilienceFileHandlerImpl()) as? UseCase
            
        case String(describing: GetRouteInformationUseCase.self),
             String(describing: GetRouteScheduleUseCase.self),
             String(describing: RouteUseCase.self):
            return RouteUseCaseImpl(repository: TripPriceRepositoryRealmImpl(realmHandler: RealmHandler()),
                                    service: PricesWebServiceImpl(),
                                    resilienceHandler: ResilienceFileHandlerImpl()) as? UseCase
        default:
            return nil
        }
    }
}
