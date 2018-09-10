//
//  DirectionsDetailPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 05/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol DirectionsDetailPresenter: class {
    var stationName: String { get }
    var disclaimer: String? { get }
    var availableApps: [DirectionsApp] { get }
    func openDirections(app: DirectionsApp)
}

class DirectionsDetailPresenterImpl: DirectionsDetailPresenter {
    
    var availableApps: [DirectionsApp]
    var disclaimer: String?
    
    private let station: Station
    
    init(station: Station) {
        self.station = station
        let availableApps = DirectionsAppsFactory.getAvailableApps()
        self.availableApps = availableApps.apps
        disclaimer = availableApps.disclaimer
    }
    
    var stationName: String {
        return station.name
    }
    
    func openDirections(app: DirectionsApp) {
        guard let url = app.getLink(withStation: station) else { return }
        UIApplication.shared.open(url, options: [:]) { succes in
            print(succes)
        }
    }
}
