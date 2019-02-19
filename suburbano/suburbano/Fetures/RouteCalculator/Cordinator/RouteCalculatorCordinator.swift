//
//  RouteCalculatorCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 13/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class RouteCalculatorCordinator: NSObject, Coordinator {
    fileprivate let rootViewController: MainViewController
    fileprivate var controller: RouteCalculatorViewController

    init(rootViewController: MainViewController, stations: [Station], departure: Station, arraival: Station) {
        self.rootViewController = rootViewController
        let presenter = RouteCalculatorPresenterImpl(routeUseCase: UseCaseLocator.getUseCase(ofType: RouteUseCase.self),
                                                     stations: stations,
                                                     departure: departure,
                                                     arraival: arraival)
        self.controller = RouteCalculatorViewController(presenter: presenter)
        presenter.viewDelegate = self.controller
        self.controller.routeCameraDelegate = rootViewController
    }

    func start() {
        controller.transitioningDelegate = rootViewController
        rootViewController.present(controller, animated: true, completion: nil)
    }
}
