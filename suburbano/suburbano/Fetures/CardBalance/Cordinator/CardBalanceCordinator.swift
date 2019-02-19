//
//  CardBalanceCordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class CardBalanceCordinator: NSObject, Coordinator {
    fileprivate let rootViewController: MainViewController
    fileprivate let controller: CardBalanceViewController

    init(rootViewController: MainViewController, card: Card? = nil) {
        self.rootViewController = rootViewController
        let cardBalancePresenter = CardBalancePresenterImpl(cardUseCase: UseCaseLocator.getUseCase(ofType: CardUseCase.self)!)
        self.controller = CardBalanceViewController(presenter: cardBalancePresenter, card: card)
        cardBalancePresenter.viewDelegate = controller
    }

    func start() {
        controller.transitioningDelegate = rootViewController
        rootViewController.present(controller, animated: true, completion: nil)
    }
}
