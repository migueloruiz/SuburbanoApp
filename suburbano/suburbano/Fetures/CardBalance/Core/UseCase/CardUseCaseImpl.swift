//
//  CardUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class CardUseCaseImpl: CardUseCase {
    
    let cardBalanceWebService: CardBalanceWebService
    let cardRepository: CardRepository
    
    init(cardBalanceWebService: CardBalanceWebService,
         cardRepository: CardRepository) {
        self.cardBalanceWebService = cardBalanceWebService
        self.cardRepository = cardRepository
    }
    
    func get() -> [Card] {
        return cardRepository.get() ?? []
    }
    
    func update(cards: [Card]) -> [Card] {
        return []
    }
    
    func get(card: Card, complition: @escaping (GetCardResult) -> Void) {
        cardBalanceWebService.getBalace(for: card) { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let card, _):
                strongSelf.cardRepository.add(object: card)
                complition(.succes(card: card))
            case .failure(let error):
                complition(.failure(error: error))
            }
        }
    }
}
