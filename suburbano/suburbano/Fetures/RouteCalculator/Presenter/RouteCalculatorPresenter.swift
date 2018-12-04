//
//  RouteCalculatorPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/16/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol RouteCalculatorPresenter: class {
    func load()
    func selectedElements() -> (departureItem: Int, arraivalItem: Int)
    func elementsFor(pickerId: Int) -> Int
    func getImage(forPicker pickerId: Int, at row: Int) -> String
    func didChange(selcteItem: Int, atPicker pickerId: Int)
    func getWeekDays() -> [String]
    func didChange(daySelected: Int)
}

protocol RouteCalculatorViewDelegate: class {
    func update(route: Route)
    func update(waitTimes: [WaitTimeDetailModel])
}

struct Route {
    let departure: Station
    let arraival: Station
    let information: DisplayRouteInformation
}

enum WeekDays: Int, CaseIterable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    
    var title: String {
        switch self {
        case .sunday: return "Domingo" // Localize
        case .monday: return "Lunes" // Localize
        case .tuesday: return "Martes" // Localize
        case .wednesday: return "Miercoles" // Localize
        case .thursday: return "Jueves" // Localize
        case .friday: return "Viernes" // Localize
        case .saturday: return "Sabado" // Localize
        }
    }
}

class RouteCalculatorPresenterImpl: RouteCalculatorPresenter {

    private let routeUseCase: RouteUseCase?
    private var stations: [Station]
    private var filterStations: [Station]
    private var departure: Station
    private var arraival: Station
    private var selectedDay: TripDay = .normal
    private var selctedWaitDay: Int = 0
    private var waitDaysDetals: [Int: [WaitTimeDetailModel]] = [:]
    
    private lazy var distanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    weak var viewDelegate: RouteCalculatorViewDelegate?
    
    init(routeUseCase: RouteUseCase?, stations: [Station], departure: Station, arraival: Station) {
        self.routeUseCase = routeUseCase
        self.stations = stations
        self.departure = departure
        self.arraival = arraival
        self.filterStations = stations.filter { $0.name != departure.name }
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getInformation(from: strongSelf.departure, to: strongSelf.arraival)
            strongSelf.getWaitTime(for: strongSelf.departure)
        }
    }
    
    func elementsFor(pickerId: Int) -> Int {
        switch pickerId {
        case 0: return stations.count
        default: return filterStations.count
        }
    }
    
    func getImage(forPicker pickerId: Int, at row: Int) -> String {
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
    
    func didChange(selcteItem: Int, atPicker pickerId: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            switch pickerId {
            case 0:
                guard strongSelf.stations[selcteItem] != strongSelf.departure else { return }
                strongSelf.departure = strongSelf.stations[selcteItem]
                strongSelf.filterStations = strongSelf.stations.filter { $0.name != strongSelf.departure.name }
                if strongSelf.departure == strongSelf.arraival, let fisrt = strongSelf.filterStations.first {
                    strongSelf.arraival = fisrt
                }
            default:
                guard strongSelf.filterStations[selcteItem] != strongSelf.arraival else { return }
                strongSelf.arraival = strongSelf.filterStations[selcteItem]
            }
            
            strongSelf.getInformation(from: strongSelf.departure, to: strongSelf.arraival)
            strongSelf.getWaitTime(for: strongSelf.departure)
        }
    }
    
    func getWeekDays() -> [String] {
        return WeekDays.allCases.map { $0.title }
    }
    
    func didChange(daySelected: Int) {
        guard let displayItems = waitDaysDetals[daySelected] else { return }
        selctedWaitDay = daySelected
        viewDelegate?.update(waitTimes: displayItems)
    }
}

extension RouteCalculatorPresenterImpl {
    private func preperForDisplay(info: RouteInformation) -> DisplayRouteInformation {
        var distance = distanceFormatter.string(from: info.distance as NSNumber) ?? ""
        distance = distance.isEmpty ? "-" : distance + "Km"
        
        return DisplayRouteInformation(time: String(info.time) + "min",
                                       distance: distance,
                                       price: String(format: "$%.02f", info.price))
    }
    
    private func getInformation(from departure: StationEntity, to arraival: StationEntity) {
        routeUseCase?.getInformation(from: departure, to: arraival) { routeInfo in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let route = Route(departure: strongSelf.departure,
                arraival: strongSelf.arraival,
                information: strongSelf.preperForDisplay(info: routeInfo))
                strongSelf.viewDelegate?.update(route: route)
            }
        }
    }
    
    private func getWaitTime(for station: StationEntity) {
        routeUseCase?.getWaitTime(inStation: station.name) { [weak self] waitTimes in
            guard let strongSelf = self else { return }
            strongSelf.waitDaysDetals = [:]
            for item in waitTimes {
                let model = WaitTimeDetailModel(concurrence: item.concurrence, waitTime: item.waitTime, displayTime: item.displayTime)
                if strongSelf.waitDaysDetals[item.day] == nil {
                    strongSelf.waitDaysDetals[item.day] = [model]
                } else {
                    strongSelf.waitDaysDetals[item.day]?.append(model)
                }
            }
            guard let displayItems = strongSelf.waitDaysDetals[strongSelf.selctedWaitDay] else { return }
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.viewDelegate?.update(waitTimes: displayItems)
            }
        }
    }
    
    func getStop(from train: TrainEntity, at station: StationEntity) -> TrainStopEntity? {
        switch station.name {
        case "Buenavista": return train.buenavista
        case "Fortuna": return train.fortuna
        case "Talnepantla": return train.talnepantla
        case "San Rafael": return train.sanRafale
        case "Lecheria": return train.lecheria
        case "Tultitlan": return train.tultitlan
        case "Cuautitlan": return train.cuautitlan
        default: return nil
        }
    }
}
