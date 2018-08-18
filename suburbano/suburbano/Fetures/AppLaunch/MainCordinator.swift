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
        let stationsMapViewController = StationsViewController(presenter: StationsMapPresenter(), mapConfiguration: StationsMap())
        stationsMapViewController.delegate = self
        let activitiesBoardViewController = ActivitiesBoardViewController(activitiesBoardPresenter: ActivitiesBoardPresenter())
        let moreBoardViewController = MoreBoardViewController()
        
        rootViewController.setNavigation(viewControllers: [activitiesBoardViewController, stationsMapViewController, moreBoardViewController], startIndex: 1)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension MainCordinator: StationsMapViewControllerDelegate {
    func didStationSelected(station: StationMarker) {
        print(station)
    }
}
