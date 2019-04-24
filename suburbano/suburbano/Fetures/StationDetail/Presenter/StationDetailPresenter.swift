//
//  StationDetailPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum DetailSection: Int {
    case location = 0
    case schedule = 1
    case conactions = 2
    case waitTime = 3

    var title: String {
        switch self {
        case .location: return "UBICACION" // Localize
        case .schedule: return "HORARIO" // Localize
        case .conactions: return "CONECCIONES" // Localize
        case .waitTime: return "TIEMPO DE ESPERA" // Localize
        }
    }
}

enum DetailItem {
    case location(address: String)
    case schedule(dias: TripDay)
    case conactions(images: [String])
    case waitTime(days: [String], waitTimes: [Int: [WaitTimeDetailModel]])

    var cellIdentifier: String {
        switch self {
        case .location: return DetailAddressCell.reuseIdentifier
        case .schedule: return DetailScheduleCell.reuseIdentifier
        case .conactions: return DeatilConectionsCell.reuseIdentifier
        case .waitTime: return DetailWaitTimeCell.reuseIdentifier
        }
    }
}

enum TripDay: String, CaseIterable {
    case normal = "Normal"
    case saturday = "Saturday"
    case sundayAndHolidays = "SundayAndHolidays"

    var selectionText: String {
        switch self {
        case .sundayAndHolidays: return "Domingos y Festivos" // Localize
        case .normal: return "Lunes a Viernes" // Localize
        case .saturday: return "Sabados" // Localize
        }
    }

    var openTime: String {
        switch self {
        case .sundayAndHolidays: return "7:00" // Localize
        case .normal: return "5:00" // Localize
        case .saturday: return "6:00" // Localize
        }
    }

    var closeTime: String {
        switch self {
        case .sundayAndHolidays, .normal, .saturday:
            return "00:30" // Localize
        }
    }
}

protocol StationDetailPresenter: class {
    var station: Station { get }
    var titleImageName: String { get }
    func numberOfSections() -> Int
    func numberOfItems(atSection: Int) -> Int
    func section(atIndex index: Int) -> DetailSection
    func item(atIndex: IndexPath) -> DetailItem
    func getWeekDays() -> [String]
    func load()
}

class StationDetailPresenterImpl: StationDetailPresenter {

    let station: Station
    private let routeUseCase: RouteUseCase?
    fileprivate var stationDetails: [[DetailItem]] = []

    weak var viewDelegate: StationDetailViewController?

    init(station: Station, routeUseCase: RouteUseCase?) {
        self.station = station
        self.routeUseCase = routeUseCase
    }

    func load() {
        stationDetails = configureStationDetails(station: station)
        viewDelegate?.update()
        getWaitTime(for: station)
    }

    var titleImageName: String {
        return station.markerTitleImage
    }

    func numberOfSections() -> Int {
        return stationDetails.count
    }

    func numberOfItems(atSection section: Int) -> Int {
        return stationDetails[section].count
    }

    func section(atIndex index: Int) -> DetailSection {
        return DetailSection.init(rawValue: index) ?? .location
    }

    func item(atIndex index: IndexPath) -> DetailItem {
        return stationDetails[index.section][index.row]
    }

    func getWeekDays() -> [String] {
        return WeekDays.allCases.map { $0.title }
    }

    private func getWaitTime(for station: StationEntity) {
        routeUseCase?.getWaitTime(inStation: station.name) { [weak self] waitTimes in
            guard let strongSelf = self else { return }
            var waitDaysDetals = [Int: [WaitTimeDetailModel]]()
            for item in waitTimes {
                let model = WaitTimeDetailModel(concurrence: item.concurrence, waitTime: item.waitTime, displayTime: item.displayTime)
                if waitDaysDetals[item.day] == nil {
                    waitDaysDetals[item.day] = [model]
                } else {
                    waitDaysDetals[item.day]?.append(model)
                }
            }
            strongSelf.stationDetails[DetailSection.waitTime.rawValue] = [.waitTime(days: strongSelf.getWeekDays(), waitTimes: waitDaysDetals)]
            strongSelf.viewDelegate?.update()
        }
    }
}

extension StationDetailPresenterImpl {
    private func configureStationDetails(station: Station) -> [[DetailItem]] {
        var details: [[DetailItem]] = []

        details.append([.location(address: station.address)])
        details.append([
            .schedule(dias: .normal),
            .schedule(dias: .saturday),
            .schedule(dias: .sundayAndHolidays)
        ])
        details.append([.conactions(images: station.conections.components(separatedBy: ","))])
        details.append([.waitTime(days: [], waitTimes: [:])])

        return details
    }
}
