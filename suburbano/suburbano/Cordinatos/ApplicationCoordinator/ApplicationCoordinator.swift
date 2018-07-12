//
//  ApplicationCoordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
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
        
        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .cyan
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "TrainIcon"), selectedImage: #imageLiteral(resourceName: "SelectedTrainIcon"))
        
        rootViewController.viewControllers = [stationsMapViewController, secondViewController]
        rootViewController.tabBar.removeTitles()
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

extension ApplicationCoordinator: StationsMapViewControllerDelegate {
    func didStationSelected(station: StationMarker) {
        print(station)
    }
}

