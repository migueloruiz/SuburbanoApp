//
//  UseCaseLocator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class UseCaseLocator {

    static func getUseCase<Abstraction>(ofType type: Abstraction.Type) -> Abstraction? {
        switch String(describing: type) {

        case String(describing: AnalyticsUseCase.self):
            return AnalyticsUseCaseImpl() as? Abstraction

        case String(describing: UpdateCardsBalanceUseCase.self),
             String(describing: GetCardBalanceUseCase.self),
             String(describing: GetCardUseCase.self),
             String(describing: DeleteCardUseCase.self),
             String(describing: CardUseCase.self):
            return CardUseCaseImpl(
                cardBalanceWebService: CardBalanceWebServiceImpl(),
                cardRepository: CardRepositoryImpl()
            ) as? Abstraction

        case String(describing: GetStationsUseCase.self),
             String(describing: GetTrainRailUseCase.self),
             String(describing: MapResurcesUseCase.self):
            return MapResurcesUseCaseImpl(mapResurcesRepository: MapResurcesRepositoryImpl()) as? Abstraction

        case String(describing: GetRouteInformationUseCase.self),
             String(describing: GetStationChartsUseCase.self),
             String(describing: RouteUseCase.self):
            return RouteUseCaseImpl(pricesRepository: TripPriceRepositoryRealmImpl(),
                                    pricesService: PricesWebServiceImpl(),
                                    trainsRepository: TrainRepositoryImpl(),
                                    stationWaitTimeRepository: StationChartDataRepositoryImpl(),
                                    stationWaitTimeService: StationWaitTimeWebServiceImpl()) as? Abstraction
        default:
            return nil
        }
    }
}
