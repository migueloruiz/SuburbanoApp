//
//  MainCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 25/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class MainCordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UITabBarController()
    }
    
    func start() {
        let stationsMapViewController = StationsMapViewController(presenter: StationsMapPresenter(), mapConfiguration: StationsMap())
        stationsMapViewController.delegate = self
        stationsMapViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "TrainIcon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "SelectedTrainIcon").withRenderingMode(.alwaysOriginal))
        
        let activitiesBoardViewController = ActivitiesBoardViewController(activitiesBoardPresenter: ActivitiesBoardPresenter())
        activitiesBoardViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "NewspaperIcon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "SlectedNewspaperIcon").withRenderingMode(.alwaysOriginal))
        
        rootViewController.viewControllers = [stationsMapViewController, activitiesBoardViewController]
        rootViewController.tabBar.removeTitles()
        rootViewController.selectedIndex = 1
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension MainCordinator: StationsMapViewControllerDelegate {
    func didStationSelected(station: StationMarker) {
        print(station)
    }
}
