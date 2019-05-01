//
//  CardBalancePresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol CardBalancePresenter: class, Presenter {
    func addCard(withIcon: CardBalanceIcon, number: String)
    func deleteCard(withId id: String)
}

protocol CardBalanceViewDelegate: class {
    func setInvalid(form: CardBalanceForm)
    func addCardSuccess(card: Card)
    func addCardFailure(error: InlineError)
    func showAnimation()
}

enum CardBalanceForm {
    case number
    case icon
}

class CardBalancePresenterImpl: CardBalancePresenter, AnalyticsPresenter {

    private let cardUseCase: CardUseCase?
    internal let analyticsUseCase: AnalyticsUseCase?
    weak var viewDelegate: CardBalanceViewDelegate?

    init(cardUseCase: CardUseCase?, analyticsUseCase: AnalyticsUseCase?) {
        self.cardUseCase = cardUseCase
        self.analyticsUseCase = analyticsUseCase
    }

    func addCard(withIcon icon: CardBalanceIcon, number: String) {
        guard isIconValid(icon: icon) else {
            viewDelegate?.setInvalid(form: .icon)
            return
        }

        guard isCardNumberValid(number: number) else {
            viewDelegate?.setInvalid(form: .number)
            return
        }

        let iconValues = icon.values
        let tempCard = Card(id: number,
                            balance: "",
                            icon: iconValues.icon,
                            color: iconValues.color,
                            displayDate: "",
                            date: 0)

        guard let isRegistered = cardUseCase?.isAlreadyRegister(card: tempCard), !isRegistered else {
            viewDelegate?.addCardFailure(error: "Esta tarjeta ya esta registrada") // Localized
            return
        }

        viewDelegate?.showAnimation()
        cardUseCase?.add(card: tempCard, success: { [weak self] card in
            guard let strongSelf = self else { return }
            strongSelf.viewDelegate?.addCardSuccess(card: card)
        }, failure: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewDelegate?.addCardFailure(error: "Número de tarjeta no valido. Puedes encontrar el numero al frente en la parte inferior de tu tarjeta") // Localized
        })
    }

    func deleteCard(withId id: String) {
        cardUseCase?.delate(withId: id)
    }
}

extension CardBalancePresenterImpl {
    private func isIconValid(icon: CardBalanceIcon) -> Bool {
        switch icon {
        case .initial: return false
        case .custome: return true
        }
    }

    private func isCardNumberValid(number: String) -> Bool {
        return number.matchesPattern(pattern: "^[0-9]+$")
    }
}
