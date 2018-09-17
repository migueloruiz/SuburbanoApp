//
//  RouteCalculatorPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/16/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol RouteCalculatorPresenter: class {
    func selectedElements() -> (departureItem: Int, arraivalItem: Int)
    func elementsFor(pickerId: Int) -> Int
    func getImage(row: Int, pickerId: Int) -> String
    func did(selcteItem: Int, atPicker pickerId: Int)
}

protocol RouteCalculatorViewDelegate: class {
    func updateRouteStation(departure: Station, arraival: Station)
}

class RouteCalculatorPresenterImpl: RouteCalculatorPresenter {

    private var stations: [Station]
    private var filterStations: [Station]
    private var departure: Station
    private var arraival: Station
    
    weak var viewDelegate: RouteCalculatorViewDelegate?
    
    init(stations: [Station], departure: Station, arraival: Station) {
        self.stations = stations
        self.departure = departure
        self.arraival = arraival
        self.filterStations = stations.filter { $0.name != departure.name }
    }
    
    func elementsFor(pickerId: Int) -> Int {
        switch pickerId {
        case 0: return stations.count
        default: return filterStations.count
        }
    }
    
    func getImage(row: Int, pickerId: Int) -> String {
        switch pickerId {
        case 0: return stations[row].markerTitleImage
        default: return filterStations[row].markerTitleImage
        }
    }
    
    func selectedElements() -> (departureItem: Int, arraivalItem: Int) {
        let departureItem = stations.index { $0.name == departure.name } ?? 0
        let arrailvalItem = filterStations.index { $0.name == arraival.name } ?? 0
        return (departureItem: departureItem, arraivalItem: arrailvalItem)
    }
    
    func did(selcteItem: Int, atPicker pickerId: Int) {
        switch pickerId {
        case 0:
            guard stations[selcteItem] != departure else { return }
            departure = stations[selcteItem]
            filterStations = stations.filter { $0.name != departure.name }
            if departure == arraival, let fisrt = filterStations.first {
                arraival = fisrt
            }
            viewDelegate?.updateRouteStation(departure: departure, arraival: arraival)
        default:
            guard filterStations[selcteItem] != arraival else { return }
            arraival = filterStations[selcteItem]
            viewDelegate?.updateRouteStation(departure: departure, arraival: arraival)
        }
    }
}
