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

protocol GetRouteInformationUseCase {
    func getInformation(from departure: StationEntity, to arraival: StationEntity, complition: @escaping SuccessResponse<RouteInformation>)
}

typealias StationChartsData = (trainWaitTime: ChartModel?, concurrence: ChartModel?)

protocol GetStationChartsUseCase {
    func getChartData(forStation station: String, complition: @escaping SuccessResponse<StationChartsData>)
}

protocol RouteUseCase: GetRouteInformationUseCase, GetStationChartsUseCase { }
