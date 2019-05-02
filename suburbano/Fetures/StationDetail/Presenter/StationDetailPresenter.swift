//
//  StationDetailPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum DetailSection: Int {
    case location
    case schedule
    case conactions
    case waitTime

    var title: String {
        switch self {
        case .location: return "UBICACION" // Localize
        case .schedule: return "HORARIO" // Localize
        case .conactions: return "CONECCIONES" // Localize
        case .waitTime: return "TIEMPO ENTRE TRENES" // Localize
        }
    }
}

typealias WeekChartModel = [WeekDays: [ChartTimeBarModel]]

enum DetailItem {
    case location(address: String)
    case schedule(dias: TripDay)
    case conactions(images: [String])
    case waitTime(waitTimes: WeekChartModel, maxValue: Int)

    var cellIdentifier: String {
        switch self {
        case .location: return DetailAddressCell.reuseIdentifier
        case .schedule: return DetailScheduleCell.reuseIdentifier
        case .conactions: return DeatilConectionsCell.reuseIdentifier
        case .waitTime: return ChartDetailCell.reuseIdentifier
        }
    }
}

enum TripDay: String, CaseIterable { // TODO
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

protocol StationDetailPresenter: class, Presenter {
    var station: Station { get }
    var titleImageName: String { get }
    func numberOfSections() -> Int
    func numberOfItems(atSection: Int) -> Int
    func section(atIndex index: Int) -> DetailSection
    func item(atIndex: IndexPath) -> DetailItem
    func load()
}

final class StationDetailPresenterImpl: StationDetailPresenter, AnalyticsPresenter {

    private struct Constants {
        static let waitTimeMaxValue = 20
    }

    private let routeUseCase: RouteUseCase?
    internal let analyticsUseCase: AnalyticsUseCase?

    let station: Station
    fileprivate var stationDetails: [[DetailItem]] = []

    weak var viewDelegate: StationDetailViewController?

    init(station: Station, routeUseCase: RouteUseCase?, analyticsUseCase: AnalyticsUseCase?) {
        self.station = station
        self.routeUseCase = routeUseCase
        self.analyticsUseCase = analyticsUseCase
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

    private func getWaitTime(for station: StationEntity) {
        routeUseCase?.getWaitTime(inStation: station.name) { [weak self] waitTimes in
            guard let strongSelf = self else { return }
            var waitDaysDetals = WeekChartModel()
            for item in waitTimes {
                let display = item.displayTime.split(separator: ":").first ?? "•"
                let model = ChartTimeBarModel(value: item.waitTime,
                                              maxValue: 20,
                                              displayTime: String(display))
                guard let day = WeekDays.init(rawValue: item.day) else { continue }
                if waitDaysDetals[day] == nil {
                    waitDaysDetals[day] = [model]
                } else {
                    waitDaysDetals[day]?.append(model)
                }
            }
            strongSelf.stationDetails[DetailSection.waitTime.rawValue] = [.waitTime(waitTimes: waitDaysDetals, maxValue: Constants.waitTimeMaxValue)]
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
        details.append([.waitTime(waitTimes: [:], maxValue: Constants.waitTimeMaxValue)])

        return details
    }
}
