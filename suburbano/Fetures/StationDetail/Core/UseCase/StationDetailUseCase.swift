//
//  StationDetailUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/10/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

typealias StationChartsData = (trainWaitTime: ChartModel?, concurrence: ChartModel?)

protocol GetStationChartsUseCase {
    func getChartData(forStation station: String, complition: @escaping SuccessResponse<StationChartsData>)
}

protocol GetStationsSchedule {
    func getSchedule(complition: @escaping SuccessResponse<[StatiosScheduleEntity]>)
}

protocol StationDetailUseCase: GetStationChartsUseCase, GetStationsSchedule {}
