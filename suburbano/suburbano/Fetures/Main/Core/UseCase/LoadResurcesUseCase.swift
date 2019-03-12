//
//  TrainRailUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 3/12/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import CoreLocation

protocol GetTrainRailUseCase {
    func getTrainRailCoordinates() -> [CLLocationCoordinate2D]
}

protocol GetStationsUseCase {
    func getStations() -> [Station]
}

protocol LoadResurcesUseCase: GetTrainRailUseCase, GetStationsUseCase { }
