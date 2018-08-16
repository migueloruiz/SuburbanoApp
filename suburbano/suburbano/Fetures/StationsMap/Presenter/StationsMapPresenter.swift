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
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

protocol StationsMapPresenterProtocol {
    func getStations() -> [StationMarker]
    func getStation(withName: String) -> StationMarker?
}

class StationsMapPresenter: StationsMapPresenterProtocol {
    
    private var stations: [String: StationMarker] = [
        "Buenavista": StationMarker(name: "Buenavista", latitude: 19.4485249, longitude: -99.1519117, markerImage: "BuenavistaMarker"),
        "Fortuna": StationMarker(name: "Fortuna", latitude: 19.4919398, longitude: -99.1710413, markerImage: "FortunaMarker"),
        "Talnepantla": StationMarker(name: "Talnepantla", latitude: 19.5366676, longitude: -99.1841143, markerImage: "TalnepantlaMarker"),
        "San Rafael": StationMarker(name: "San Rafael", latitude: 19.565224, longitude: -99.1954601, markerImage: "SanRafaelMarker"),
        "Lecheria": StationMarker(name: "Lecheria", latitude: 19.5996579, longitude: -99.1860026, markerImage: "LecheriaMarker"),
        "Tultitlan": StationMarker(name: "Tultitlan", latitude: 19.6355092, longitude: -99.1803351, markerImage: "TultitlanMarker"),
        "Cuautitlan": StationMarker(name: "Cuautitlan", latitude: 19.6669502, longitude: -99.1762689, markerImage: "CuautitlanMarker"),
    ]
    
    func getStations() -> [StationMarker] {
        return Array(stations.values)
    }
    
    func getStation(withName: String) -> StationMarker? {
        return stations[withName]
    }
}
