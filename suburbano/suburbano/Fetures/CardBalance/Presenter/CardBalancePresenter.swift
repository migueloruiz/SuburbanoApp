//
//  CardBalancePresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol CardBalancePresenter: class  {
    func addCard(withIcon: CardBalanceIcon, number: String)
    func deleteCard(withId id: String)
}

protocol CardBalanceViewDelegate: class {
    func setInvalid(form: CardBalanceForm)
    func addCardSuccess(card: Card)
    func addCardFailure(error: ErrorResponse)
    func showAnimation()
}

enum CardBalanceForm {
    case number
    case icon
}

class CardBalancePresenterImpl: CardBalancePresenter {
    
    private let cardUseCase: CardUseCase?
    weak var viewDelegate: CardBalanceViewDelegate?
    
    init(cardUseCase: CardUseCase?) {
        self.cardUseCase = cardUseCase
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
        let tempCard = Card(id: number, balance: "", icon: iconValues.icon, color: iconValues.color)

        guard let isRegistered = cardUseCase?.isAlreadyRegister(card: tempCard), !isRegistered else {
            let error = ErrorResponse(code: .unknownCode, header: "", body: "Esta tarjeta ya esta registrada", tecnicalDescription: "")
            viewDelegate?.addCardFailure(error: error)
            return
        }
        
        viewDelegate?.showAnimation()
        
        cardUseCase?.get(card: tempCard, complition: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .succes(let card):
                strongSelf.viewDelegate?.addCardSuccess(card: card)
            case .failure(let error):
                strongSelf.viewDelegate?.addCardFailure(error: error)
            }
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
