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
}

protocol CardBalanceViewDelegate: class {
    func setInvalid(form: CardBalanceForm)
}

enum CardBalanceForm {
    case number
    case icon
}

class CardBalancePresenterImpl: CardBalancePresenter {
    private let cardUseCase: CardBalanceUseCase?
    weak var viewDelegate: CardBalanceViewDelegate?
    
    init(cardUseCase: CardBalanceUseCase?) {
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
        cardUseCase?.get(card: tempCard, complition: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .succes(let card):
                print(card)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func isIconValid(icon: CardBalanceIcon) -> Bool {
        switch icon {
        case .initial: return false
        case .custome: return true
        }
    }
    
    func isCardNumberValid(number: String) -> Bool {
        return number.matchesPattern(pattern: "^[0-9]+$")
    }
}
