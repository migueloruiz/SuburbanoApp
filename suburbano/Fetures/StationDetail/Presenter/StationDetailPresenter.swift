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
    case trainWaitTimeChart
    case concurrenciChart

    var title: String {
        switch self {
        case .location: return "UBICACION" // Localize
        case .schedule: return "HORARIO" // Localize
        case .conactions: return "CONECCIONES" // Localize
        case .trainWaitTimeChart: return "TIEMPO ENTRE TRENES" // Localize
        case .concurrenciChart: return "CONCIRRENCIA" // Localize
        }
    }
}

enum DetailItem {
    case location(address: String)
    case schedule(dias: TripDay)
    case conactions(images: [String])
    case chart(status: ChartStatus)

    var cellIdentifier: String {
        switch self {
        case .location: return DetailAddressCell.reuseIdentifier
        case .schedule: return DetailScheduleCell.reuseIdentifier
        case .conactions: return DeatilConectionsCell.reuseIdentifier
        case .chart: return DetailChartCell.reuseIdentifier
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
        case .normal: return "Dia Laboral" // Localize
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
        static let trainWaitTimeChartMaxValue = 20
        static let concurrenciChartMaxValue = 10
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
        routeUseCase?.getChartData(forStation: station.name) { [weak self] chartData in

            var trainWaitTimeChartStatus: ChartStatus = .empty
            if let trainWaitTime = chartData.trainWaitTime {
                trainWaitTimeChartStatus = .content(chartData: trainWaitTime)
            }
            self?.stationDetails[DetailSection.trainWaitTimeChart.rawValue] = [.chart(status: trainWaitTimeChartStatus)]

            var concurrenceChartStatus: ChartStatus = .empty
            if let concurrence = chartData.concurrence {
                concurrenceChartStatus = .content(chartData: concurrence)
            }
            self?.stationDetails[DetailSection.concurrenciChart.rawValue] = [.chart(status: concurrenceChartStatus)]

            self?.viewDelegate?.update()
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
        details.append([.chart(status: .loading)])
        details.append([.chart(status: .loading)])

        return details
    }
}
