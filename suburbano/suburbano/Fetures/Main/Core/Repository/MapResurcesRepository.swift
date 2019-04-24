//
//  MapResurcesRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/23/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapResurcesRepository: Repository {
    func getTrainRailCoordinates() -> [CLLocationCoordinate2D]
    func getStations() -> [Station]
}

class MapResurcesRepositoryImpl: MapResurcesRepository, ResilienceRepository {

    typealias Cordinates = [[Double]]

    func getTrainRailCoordinates() -> [CLLocationCoordinate2D] {
        guard let rawCoordinates: Cordinates = try? load(resource: AppResources.TrainRail) else { return [] }
        return rawCoordinates.map { cordinate in
            return CLLocationCoordinate2D(latitude: cordinate.last ?? 0, longitude: cordinate.first ?? 0)
        }
    }

    func getStations() -> [Station] {
        guard let stations: [Station] = try? load(resource: AppResources.Stations) else { return [] }
        return stations
    }

}
