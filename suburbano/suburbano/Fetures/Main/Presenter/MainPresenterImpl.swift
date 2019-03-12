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

enum TripDirection {
    case buenavistaToCuautitlan
    case cuautitlanToBuenavista

    var direction: Double {
        switch self {
        case .buenavistaToCuautitlan: return -90
        case .cuautitlanToBuenavista: return 90
        }
    }
}

protocol StationsMapPresenter {
    func getStations() -> [Station]
    func getMarkers() -> [StationMarker]
    func getStationMarker(withName name: String) -> StationMarker?
    func getStation(withName name: String) -> Station?
    func tripDirection(from departure: Station, to arrival: Station) -> TripDirection
    func getTrainRailCoordinates() -> [CLLocationCoordinate2D]
    func getTrainRailCoordinates(from departure: Station, to arraival: Station, direction: TripDirection) -> [CLLocationCoordinate2D]
}

protocol CardBalancePickerPresenter {
    var viewDelegate: StationsViewDelegate? { get set }
    func getCards() -> [Card]
}

protocol MainPresenter: StationsMapPresenter, CardBalancePickerPresenter {}

protocol StationsViewDelegate: class {
    func update(cards: [Card])
}

class MainPresenterImpl: MainPresenter {

    private let getCardUseCase: GetCardUseCase?
    private let loadResurcesUseCase: LoadResurcesUseCase?

    weak var viewDelegate: StationsViewDelegate?
    private var stationsMarkers: [String: StationMarker] = [:]
    private var stations: [String: Station] = [:]
    private var railCordinates = [CLLocationCoordinate2D]()

    init(getCardUseCase: GetCardUseCase?, loadResurcesUseCase: LoadResurcesUseCase?) {
        self.getCardUseCase = getCardUseCase
        self.loadResurcesUseCase = loadResurcesUseCase

        NotificationCenter.default.addObserver(self, selector: #selector(MainPresenterImpl.updateCards), name: .UpdateCards, object: nil)
    }

    func getStations() -> [Station] {
        return Array(stations.values).sorted(by: { $0.id > $1.id })
    }

    func getMarkers() -> [StationMarker] {
        guard stationsMarkers.isEmpty else { return Array(stationsMarkers.values) }
        guard let rawStation = loadResurcesUseCase?.getStations() else { return [] }

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

    func tripDirection(from departure: Station, to arrival: Station) -> TripDirection {
        return departure.id < arrival.id ? .cuautitlanToBuenavista : .buenavistaToCuautitlan
    }

    @objc func updateCards() {
        viewDelegate?.update(cards: getCards())
    }

    func getTrainRailCoordinates() -> [CLLocationCoordinate2D] {
        railCordinates = loadResurcesUseCase?.getTrainRailCoordinates() ?? []
        return railCordinates
    }

    func getTrainRailCoordinates(from departure: Station, to arraival: Station, direction: TripDirection) -> [CLLocationCoordinate2D] {
        switch direction {
        case .buenavistaToCuautitlan:
            return Array(railCordinates[arraival.id...departure.id])
        case .cuautitlanToBuenavista:
            return Array(railCordinates[departure.id...arraival.id])
        }
    }
}
