//
//  RouteCalculatorCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 13/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class RouteCalculatorCordinator: NSObject, Coordinator {
    fileprivate let rootViewController: MapStationsViewController
    fileprivate let departure: Station
    fileprivate var controller: RouteCalculatorViewController
    
    init(rootViewController: MapStationsViewController, departure: Station) {
        self.rootViewController = rootViewController
        self.departure = departure
        self.controller = RouteCalculatorViewController()
    }
    
    func start() {
        controller.transitioningDelegate = rootViewController
        rootViewController.present(controller, animated: true, completion: nil)
    }
}
