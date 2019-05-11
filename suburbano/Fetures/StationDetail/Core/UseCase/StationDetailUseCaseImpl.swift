//
//  StationDetailUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/10/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

class StationDetailUseCaseImpl: StationDetailUseCase {

    private let stationChartDataRepository: StationChartDataRepository
    private let stationChartsService: StationChartsService
    private let stationsScheduleRepository: StatiosScheduleRepository
    private let stationsScheduleService: StationsScheduleService

    init(stationChartDataRepository: StationChartDataRepository,
         stationChartsService: StationChartsService,
         stationsScheduleRepository: StatiosScheduleRepository,
         stationsScheduleService: StationsScheduleService) {
        self.stationChartDataRepository = stationChartDataRepository
        self.stationChartsService = stationChartsService
        self.stationsScheduleRepository = stationsScheduleRepository
        self.stationsScheduleService = stationsScheduleService
    }

    func getChartData(forStation station: String, complition: @escaping SuccessResponse<StationChartsData>) {
        let stationChartData = stationChartDataRepository.get(inStation: station)
        guard stationChartData.isEmpty else {
            complition(parseChartsData(stationChartData: stationChartData))
            return
        }

        stationChartsService.getWaitTimes(success: { [weak self] stationChartData in
            guard let strongSelf = self else { return }
            strongSelf.stationChartDataRepository.add(stationChartData: stationChartData)
            let orderedStationChartData = strongSelf.stationChartDataRepository.get(inStation: station)
            complition(strongSelf.parseChartsData(stationChartData: orderedStationChartData))
            }, failure: {_  in complition((trainWaitTime: nil, concurrence: nil)) })
    }

    func getSchedule(complition: @escaping SuccessResponse<[StatiosScheduleEntity]>) {
        let schelud = stationsScheduleRepository.getSchedule()
        guard schelud.isEmpty else {
            complition(schelud)
            return
        }

        stationsScheduleService.getSchedule(success: { [weak self] schelud in
            self?.stationsScheduleRepository.add(schedule: schelud)
            complition(schelud)
            }, failure: {_ in complition([]) })
    }
}

extension StationDetailUseCaseImpl {
    func parseChartsData(stationChartData: [StationChartDataEntity]) -> StationChartsData {
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
}
