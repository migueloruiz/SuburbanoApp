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

class StationsMapPresenter: StationsMapPresenterProtocol {
    
    private let getCardUseCase: GetCardUseCase?
    
    init(getCardUseCase: GetCardUseCase?) {
        self.getCardUseCase = getCardUseCase
    }
    
    private var stations: [String: StationMarker] = [
        "Buenavista": StationMarker(name: "Buenavista", latitude: 19.4485249, longitude: -99.1519117, markerImage: "BuenavistaMarker", markerTitleImage: "BuenavistaMarkerTitle", titleSide: true),
        "Fortuna": StationMarker(name: "Fortuna", latitude: 19.4919398, longitude: -99.1710413, markerImage: "FortunaMarker", markerTitleImage: "FortunaMarkerTitle", titleSide: false),
        "Talnepantla": StationMarker(name: "Talnepantla", latitude: 19.5366676, longitude: -99.1841143, markerImage: "TalnepantlaMarker", markerTitleImage: "TalnepantlaMarkerTitle", titleSide: true),
        "San Rafael": StationMarker(name: "San Rafael", latitude: 19.565224, longitude: -99.1954601, markerImage: "SanRafaelMarker", markerTitleImage: "SanRafaelMarkerTitle", titleSide: false),
        "Lecheria": StationMarker(name: "Lecheria", latitude: 19.5996579, longitude: -99.1860026, markerImage: "LecheriaMarker", markerTitleImage: "LecheriaMarkerTitle", titleSide: true),
        "Tultitlan": StationMarker(name: "Tultitlan", latitude: 19.6355092, longitude: -99.1803351, markerImage: "TultitlanMarker", markerTitleImage: "TultitlanMarkerTitle", titleSide: false),
        "Cuautitlan": StationMarker(name: "Cuautitlan", latitude: 19.6669502, longitude: -99.1762689, markerImage: "CuautitlanMarker", markerTitleImage: "CuautitlanMarkerTitle", titleSide: true)
    ]
    
    func getStations() -> [StationMarker] {
        return Array(stations.values)
    }
    
    func getStation(withName: String) -> StationMarker? {
        return stations[withName]
    }
    
    func getCards() -> [Card] {
        return getCardUseCase?.get() ?? []
    }
}
