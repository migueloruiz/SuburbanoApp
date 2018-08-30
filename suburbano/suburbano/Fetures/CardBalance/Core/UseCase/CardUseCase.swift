//
//  CardBalanceUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum GetCardResult {
    case succes(card: Card)
    case failure(error: ErrorResponse)
}

protocol UpdateCardsBalanceUseCase {
    func update(cards: [Card]) -> [Card]
}

protocol GetCardBalanceUseCase {
    func isAlreadyRegister(card: Card) -> Bool
    func get(card: Card, complition: @escaping (GetCardResult) -> Void)
}

protocol DeleteCardUseCase {
    func delate(withId: String)
}

protocol GetCardUseCase {
    func get() -> [Card]
}

protocol CardUseCase: UpdateCardsBalanceUseCase, GetCardBalanceUseCase, GetCardUseCase, DeleteCardUseCase {}
