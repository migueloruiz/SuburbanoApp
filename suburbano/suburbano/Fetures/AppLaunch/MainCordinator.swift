//
//  MainCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 25/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class MainCordinator: NSObject, Coordinator {
    let window: UIWindow
    let rootViewController = MainNavigationViewController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let stationsMapPresenter = StationsMapPresenter(getCardUseCase: UseCaseLocator.getUseCase(ofType: GetCardUseCase.self)!)
        let stationsMapViewController = StationsViewController(presenter: stationsMapPresenter, mapConfiguration: StationsMap(), delegate: self)
        stationsMapPresenter.viewDelegate = stationsMapViewController
        let activitiesBoardViewController = ActivitiesBoardViewController(activitiesBoardPresenter: ActivitiesBoardPresenter())
        let moreBoardViewController = MoreBoardViewController()
        
        rootViewController.setNavigation(viewControllers: [activitiesBoardViewController, stationsMapViewController, moreBoardViewController], startIndex: 1)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension MainCordinator: StationsMapViewControllerDelegate {

    func stationSelected(station: StationMarker) {
        print(station)
    }
    
    func openAddCard() { openCardBalance(card: nil) }
    
    func open(card: Card) { openCardBalance(card: card) }
    
    private func openCardBalance(card: Card?) {
        guard let stationsViewController = rootViewController.selectedViewController() as? StationsViewController else { return }
        let cardBalanceCordinator = CardBalanceCordinator(rootViewController: stationsViewController, card: card)
        cardBalanceCordinator.start()
    }
}
