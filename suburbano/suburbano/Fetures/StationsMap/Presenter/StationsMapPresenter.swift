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
    
    var markerIdentifier: String {
        return "StationMarker-\(titleSide ? "right" : "left")"
    }
}

protocol StationsMapPresenterProtocol {
    func getStations() -> [StationMarker]
    func getStationMarker(withName name: String) -> StationMarker?
    func getStation(withName name: String) -> Station?
    func getCards() -> [Card]
}

protocol StationsViewDelegate: class {
    func update(cards: [Card])
}

class StationsMapPresenter: StationsMapPresenterProtocol {

    private let getCardUseCase: GetCardUseCase?
    private let getStationsUseCase: GetStationsUseCase?
    
    weak var viewDelegate: StationsViewDelegate?
    private var stationsMarkers: [String: StationMarker] = [:]
    private var stations: [String: Station] = [:]
    
    init(getCardUseCase: GetCardUseCase?, getStationsUseCase: GetStationsUseCase?) {
        self.getCardUseCase = getCardUseCase
        self.getStationsUseCase = getStationsUseCase
        
        NotificationCenter.default.addObserver(self, selector: #selector(StationsMapPresenter.updateCards), name: .UpdateCards, object: nil)
    }
    
    func getStations() -> [StationMarker] {
        guard stationsMarkers.isEmpty else { return Array(stationsMarkers.values) }
        guard let rawStation = getStationsUseCase?.getStations() else { return [] }
        
        for station in rawStation {
            let stationMarker = StationMarker(name: station.name,
                                              latitude: station.railLocation.latitude,
                                              longitude: station.railLocation.longitude,
                                              markerImage: station.markerImage,
                                              markerTitleImage: station.markerTitleImage,
                                              titleSide: station.titleSide)
            stationsMarkers[station.name] = stationMarker
            stations[station.name] = station
        }
    
        return Array(stationsMarkers.values)
    }
    
    func getStationMarker(withName name: String) -> StationMarker? {
        return stationsMarkers[name]
    }
    
    func getStation(withName name: String) -> Station? {
        return stations[name]
    }
    
    func getCards() -> [Card] {
        return getCardUseCase?.get() ?? []
    }
    
    @objc func updateCards() {
        viewDelegate?.update(cards: getCards())
    }
}
