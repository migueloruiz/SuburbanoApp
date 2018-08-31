//
//  StationDetailCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class StationDetailCordinator: NSObject, Coordinator {
    fileprivate let rootViewController: MapStationsViewController
    fileprivate let controller: StationDetailViewController
    
    init(rootViewController: MapStationsViewController, station: Station) {
        self.rootViewController = rootViewController
        self.controller = StationDetailViewController(station: station)
    }
    
    func start() {
        controller.transitioningDelegate = rootViewController
        rootViewController.present(controller, animated: true, completion: nil)
    }
}

