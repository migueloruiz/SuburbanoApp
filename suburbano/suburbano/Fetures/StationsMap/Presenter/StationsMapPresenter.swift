//
//  StationsMapPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import CoreLocation

struct StationMarker {
    let name: String
    let latitude: Double
    let longitude: Double
    let markerImage: String
    let markerTitleImage: String
    let titleSide: Bool
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

protocol StationsMapPresenterProtocol {
    func getStations() -> [StationMarker]
    func getStation(withName: String) -> StationMarker?
    func getCards() -> [Card]
}

protocol StationsViewDelegate: class {
    func update(cards: [Card])
}

class StationsMapPresenter: StationsMapPresenterProtocol {
    
    private let getCardUseCase: GetCardUseCase?
    private let getStationsUseCase: GetStationsUseCase?
    weak var viewDelegate: StationsViewDelegate?
    var stations: [String: StationMarker] = [:]
    
    init(getCardUseCase: GetCardUseCase?, getStationsUseCase: GetStationsUseCase?) {
        self.getCardUseCase = getCardUseCase
        self.getStationsUseCase = getStationsUseCase
        
        NotificationCenter.default.addObserver(self, selector: #selector(StationsMapPresenter.updateCards), name: .UpdateCards, object: nil)
    }
    
    func getStations() -> [StationMarker] {
        guard stations.isEmpty else { return Array(stations.values) }
        guard let rawStation = getStationsUseCase?.getStations() else { return [] }
        
        for station in rawStation {
            let stationMarker = StationMarker(name: station.name,
                                              latitude: station.railLocation.latitude,
                                              longitude: station.railLocation.longitude,
                                              markerImage: station.markerImage,
                                              markerTitleImage: station.markerTitleImage,
                                              titleSide: station.titleSide)
            stations[station.name] = stationMarker
        }
    
        return Array(stations.values)
    }
    
    func getStation(withName: String) -> StationMarker? {
        return stations[withName]
    }
    
    func getCards() -> [Card] {
        return getCardUseCase?.get() ?? []
    }
    
    @objc func updateCards() {
        viewDelegate?.update(cards: getCards())
    }
}
