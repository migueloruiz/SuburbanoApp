//
//  LoadResurcesUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 3/12/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import CoreLocation

class LoadResurcesUseCaseImpl: LoadResurcesUseCase {

    let resilienceHandler: ResilienceFileHandler

    init(resilienceHandler: ResilienceFileHandler) {
        self.resilienceHandler = resilienceHandler
    }

    typealias Cordinates = [[Double]]

    func getTrainRailCoordinates() -> [CLLocationCoordinate2D] {
        guard let rawCoordinates: Cordinates = try? resilienceHandler.load(resource: AppResources.TrainRail) else { return [] }
        return rawCoordinates.map { cordinate in
            return CLLocationCoordinate2D(latitude: cordinate.last ?? 0, longitude: cordinate.first ?? 0)
        }
    }

    func getStations() -> [Station] {
        guard let stations: [Station] = try? resilienceHandler.load(resource: AppResources.Stations) else { return [] }
        return stations
    }
}
