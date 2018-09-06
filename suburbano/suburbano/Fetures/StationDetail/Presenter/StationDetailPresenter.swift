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
    
    var title: String {
        switch self {
        case .location: return "UBICACION"
        case .schedule: return "HORARIO"
        case .conactions: return "CONECCIONES"
        }
    }
}

enum DetailItem {
    case location(address: String)
    case schedule(dias: String, open: String, close: String)
    case conactions(images: [String])
    
    var cellIdentifier: String {
        switch self {
        case .location: return DetailAddressCell.reuseIdentifier
        case .schedule: return DetailScheduleCell.reuseIdentifier
        case .conactions: return DeatilConectionsCell.reuseIdentifier
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
}

class StationDetailPresenterImpl: StationDetailPresenter {
    
    let station: Station
    fileprivate var stationDetails: [[DetailItem]] = []
    
    init(station: Station) {
        self.station = station
        self.stationDetails = configureStationDetails(station: station)
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
}

extension StationDetailPresenterImpl {
    private func configureStationDetails(station: Station) -> [[DetailItem]] {
        var details: [[DetailItem]] = []
        
        details.append([.location(address: station.address)])
        details.append([
            .schedule(dias: "Lunes a Viernes", open: "5:00", close: "00:30"),
            .schedule(dias: "Sabados", open: "6:00", close: "00:30"),
            .schedule(dias: "Domingos y Festivos", open: "7:00", close: "00:30")
        ])
        details.append([.conactions(images: station.conections.components(separatedBy: ","))])

        return details
    }
}
