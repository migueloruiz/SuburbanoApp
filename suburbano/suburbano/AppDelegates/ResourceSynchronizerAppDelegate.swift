//
//  ResourceSynchronizerAppDelegate.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

final class ResourceSynchronizerAppDelegate: NSObject, UIApplicationDelegate {

    static let shared = ResourceSynchronizerAppDelegate()
    let cardsUseCase = UseCaseLocator.getUseCase(ofType: UpdateCardsBalanceUseCase.self)

    func applicationDidBecomeActive(_ application: UIApplication) {
        syncResourse()
    }
}

extension ResourceSynchronizerAppDelegate {
    func syncResourse() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cardsUseCase?.updateCards()
        }
    }
}
