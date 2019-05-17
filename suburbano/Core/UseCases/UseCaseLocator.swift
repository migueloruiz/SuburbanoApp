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
             String(describing: RouteUseCase.self):
            return RouteUseCaseImpl(pricesRepository: TripPriceRepositoryRealmImpl(),
                                    pricesService: PricesWebServiceImpl(),
                                    trainsRepository: TrainRepositoryImpl()) as? Abstraction

        case String(describing: GetStationChartsUseCase.self),
             String(describing: GetStationsSchedule.self),
             String(describing: StationDetailUseCase.self):
            return StationDetailUseCaseImpl(stationChartDataRepository: StationChartDataRepositoryImpl(),
                                            stationChartsService: StationChartsServiceImpl(),
                                            stationsScheduleRepository: StatiosScheduleRepositoryImpl(),
                                            stationsScheduleService: StationsScheduleServiceImpl()) as? Abstraction
        default:
            return nil
        }
    }
}
