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
    private let stationChartDataRepository: StationChartDataRepository
    private let stationWaitTimeService: StationWaitTimeWebService

    init(pricesRepository: PriceRepository,
         pricesService: PricesWebService,
         trainsRepository: TrainRepository,
         stationWaitTimeRepository: StationChartDataRepository,
         stationWaitTimeService: StationWaitTimeWebService) {
        self.pricesRepository = pricesRepository
        self.pricesService = pricesService
        self.trainsRepository = trainsRepository
        self.stationChartDataRepository = stationWaitTimeRepository
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

    func getChartData(forStation station: String, complition: @escaping SuccessResponse<StationChartsData>) {
        let stationChartData = stationChartDataRepository.get(inStation: station)
        guard stationChartData.isEmpty else {
            complition(parseChartsData(stationChartData: stationChartData))
            return
        }

        stationWaitTimeService.getWaitTimes(success: { [weak self] stationChartData in
            guard let strongSelf = self else { return }
            strongSelf.stationChartDataRepository.add(stationChartData: stationChartData)
            let orderedStationChartData = strongSelf.stationChartDataRepository.get(inStation: station)
            complition(strongSelf.parseChartsData(stationChartData: orderedStationChartData))
            }, failure: {_  in complition((trainWaitTime: nil, concurrence: nil)) })
    }
}

extension RouteUseCaseImpl {
    private func parseChartsData(stationChartData: [StationChartDataEntity]) -> StationChartsData {
        var trainWaitDetals = [String: [ChartBarModel]]()
        var concurrenceDetals = [String: [ChartBarModel]]()

        for item in stationChartData {
            let display = item.displayTime.split(separator: ":").first ?? "•"

            let waitTimeModel = ChartBarModel(value: item.waitTime,
                                          label: String(display))
            let concurrenceModel = ChartBarModel(value: item.concurrence,
                                                  label: String(display))

            guard let day = WeekDays.init(rawValue: item.day) else { continue }

            let dayTitle = day.title
            if trainWaitDetals[dayTitle] == nil {
                trainWaitDetals[dayTitle] = [waitTimeModel]
            } else {
                trainWaitDetals[dayTitle]?.append(waitTimeModel)
            }

            if concurrenceDetals[dayTitle] == nil {
                concurrenceDetals[dayTitle] = [concurrenceModel]
            } else {
                concurrenceDetals[dayTitle]?.append(concurrenceModel)
            }
        }

        let trainWaitModel = ChartModel(
            chartSections: Array(trainWaitDetals.keys),
            chartData: Array(trainWaitDetals.values),
            maxValue: 20,
            anotations: ["5 min", "10 min", "15 min", "20 min"] // LOCALIZE
        )

        let concurrenceModel = ChartModel(
            chartSections: Array(concurrenceDetals.keys),
            chartData: Array(concurrenceDetals.values),
            maxValue: 20,
            anotations: ["Poca", "Media", "Alta", "Muy alta"] // LOCALIZE
        )

        return (trainWaitTime: trainWaitModel, concurrence: concurrenceModel)
    }

    private func getPrices(complition: @escaping SuccessResponse<[Price]>) {
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
