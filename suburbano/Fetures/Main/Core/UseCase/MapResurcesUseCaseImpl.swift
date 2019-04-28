//
//  LoadResurcesUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 3/12/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import CoreLocation

class MapResurcesUseCaseImpl: MapResurcesUseCase {

    let mapResurcesRepository: MapResurcesRepository

    init(mapResurcesRepository: MapResurcesRepository) {
        self.mapResurcesRepository = mapResurcesRepository
    }

    func getTrainRailCoordinates() -> [CLLocationCoordinate2D] {
        return mapResurcesRepository.getTrainRailCoordinates()
    }

    func getStations() -> [Station] {
        return mapResurcesRepository.getStations()
    }
}
