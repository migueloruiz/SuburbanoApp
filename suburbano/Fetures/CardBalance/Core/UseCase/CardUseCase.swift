//
//  CardBalanceUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol UpdateCardsBalanceUseCase {
    func updateCards()
}

protocol GetCardBalanceUseCase {
    func isAlreadyRegister(card: Card) -> Bool
    func add(card: Card, success: @escaping SuccessResponse<Card>, failure: @escaping ErrorResponse)
}

protocol DeleteCardUseCase {
    func delate(withId: String)
}

protocol GetCardUseCase {
    func get() -> [Card]
}

protocol CardUseCase: UpdateCardsBalanceUseCase, GetCardBalanceUseCase, GetCardUseCase, DeleteCardUseCase {}
