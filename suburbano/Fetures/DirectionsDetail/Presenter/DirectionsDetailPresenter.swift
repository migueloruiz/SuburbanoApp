//
//  DirectionsDetailPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 05/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol DirectionsDetailPresenter: class, Presenter {
    var stationName: String { get }
    var disclaimer: String? { get }
    var availableApps: [DirectionsApp] { get }
    func openDirections(app: DirectionsApp)
}

class DirectionsDetailPresenterImpl: DirectionsDetailPresenter {

    var analyticsUseCase: AnalyticsUseCase?
    var availableApps: [DirectionsApp]
    var disclaimer: String?

    private let station: Station

    init(station: Station, analyticsUseCase: AnalyticsUseCase?) {
        self.station = station
        self.analyticsUseCase = analyticsUseCase
        let availableApps = DirectionsAppsFactory.getAvailableApps() // TODO UseCase
        self.availableApps = availableApps.apps
        disclaimer = availableApps.disclaimer
    }

    var stationName: String {
        return station.name
    }

    func openDirections(app: DirectionsApp) {
        trackSelected(app: app)
        guard let url = app.getLink(withStation: station) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
