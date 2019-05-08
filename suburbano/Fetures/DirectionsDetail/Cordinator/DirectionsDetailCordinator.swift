//
//  DirectionsDetailCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class DirectionsDetailCordinator: NSObject, Coordinator {
    fileprivate let rootViewController: StationDetailViewController
    fileprivate let station: Station

    init(rootViewController: StationDetailViewController, station: Station) {
        self.rootViewController = rootViewController
        self.station = station
    }

    func start() {
        let presenter = DirectionsDetailPresenterImpl(station: station,
                                                      analyticsUseCase: UseCaseLocator.getUseCase(ofType: AnalyticsUseCase.self))
        let controller = DirectionsDetailViewController(presenter: presenter)
        controller.transitioningDelegate = rootViewController
        rootViewController.present(controller, animated: true, completion: nil)
    }
}
