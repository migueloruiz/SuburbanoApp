//
//  CardBalancePresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol CardBalancePresenter: Presenter {
    func addCard(withId id: String, icon: String, color: Data)
    func deleteCard(withId id: String)
    func endInteraction(inDetailMode: Bool)
}

class CardBalancePresenterImpl: CardBalancePresenter {

    private let cardUseCase: CardUseCase?
    internal let analyticsUseCase: AnalyticsUseCase?
    weak var viewDelegate: CardBalanceViewDelegate?

    init(cardUseCase: CardUseCase?, analyticsUseCase: AnalyticsUseCase?) {
        self.cardUseCase = cardUseCase
        self.analyticsUseCase = analyticsUseCase
    }

    func addCard(withId id: String, icon: String, color: Data) {
        let tempCard = Card(id: id, icon: icon, color: color)

        do {
            try cardUseCase?.validate(card: tempCard)
        } catch let error {
            let addCardError = (error as? AddCardError) ?? AddCardError.cardNotFound
            DispatchQueue.main.async { [weak self] in self?.viewDelegate?.display(error: addCardError) }
            trackForm(error: addCardError)
            return
        }

        DispatchQueue.main.async { [weak self] in self?.viewDelegate?.showAnimation() }

        cardUseCase?.add(card: tempCard, success: { _ in
            DispatchQueue.main.async { [weak self] in
                self?.viewDelegate?.cardAdded()
                self?.trackAddedSuccess()
            }
        }, failure: { error in
            DispatchQueue.main.async { [weak self] in
                self?.viewDelegate?.display(error: error)
                self?.trackForm(error: error)
            }
        })
    }

    func deleteCard(withId id: String) {
        cardUseCase?.delate(withId: id)
    }

    func endInteraction(inDetailMode: Bool) {
        guard !inDetailMode else { return }
        trackDesist()
    }
}
