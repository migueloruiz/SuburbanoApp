//
//  StationDetailCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationDetailViewFlowDelegate: class {
    func showDirectionsDetails(for station: Station)
}

class StationDetailCordinator: NSObject, Coordinator {
    fileprivate let rootViewController: MapStationsViewController
    fileprivate let station: Station
    fileprivate var controller: StationDetailViewController
    
    init(rootViewController: MapStationsViewController, station: Station) {
        self.rootViewController = rootViewController
        self.station = station
        let presenter = StationDetailPresenterImpl(station: station)
        self.controller = StationDetailViewController(presenter: presenter)
    }
    
    func start() {
        controller.flowDelegate = self
        controller.transitioningDelegate = rootViewController
        rootViewController.present(controller, animated: true, completion: nil)
    }
}

extension StationDetailCordinator: StationDetailViewFlowDelegate {
    func showDirectionsDetails(for station: Station) {
        let cordinator = DirectionsDetailCordinator(rootViewController: controller, station: station)
        cordinator.start()
    }
}
