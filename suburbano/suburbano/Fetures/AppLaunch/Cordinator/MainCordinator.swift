//
//  MainCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 25/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class MainCordinator: NSObject, Coordinator {
    private let window: UIWindow
    private var detailCordinator: Coordinator?
    private lazy var rootViewController: MapStationsViewController = {
        let stationsMapPresenter = StationsMapPresenter(
            getCardUseCase: UseCaseLocator.getUseCase(ofType: GetCardUseCase.self),
            getStationsUseCase: UseCaseLocator.getUseCase(ofType: GetStationsUseCase.self)
        )
        return MapStationsViewController(presenter: stationsMapPresenter, mapConfiguration: StationsMap(), delegate: self)
    }()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension MainCordinator: StationsMapFlowDelegate {

    func dismissedDetail() {
        detailCordinator = nil
    }

    func stationSelected(station: Station) {
        detailCordinator = StationDetailCordinator(rootViewController: rootViewController, station: station)
        detailCordinator?.start()
    }

    func openAddCard() { openCardBalance(card: nil) }

    func open(card: Card) { openCardBalance(card: card) }

    func openRouteCalculator(stations: [Station], departure: Station, arraival: Station) {
        let routeCalculatorCordinator = RouteCalculatorCordinator(rootViewController: rootViewController, stations: stations, departure: departure, arraival: arraival)
        routeCalculatorCordinator.start()
    }

    private func openCardBalance(card: Card?) {
        let cardBalanceCordinator = CardBalanceCordinator(rootViewController: rootViewController, card: card)
        cardBalanceCordinator.start()
    }
}
