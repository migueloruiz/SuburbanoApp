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
    
    func isAlreadyRegister(card: Card) -> Bool {
        return cardRepository.get(forKey: card.id) == nil ? false : true
    }
    
    func delate(withId id: String) {
        guard let card = cardRepository.get(forKey: id) else { return }
        cardRepository.delete(object: card)
    }
    
    func get(card: Card, complition: @escaping (GetCardResult) -> Void) {
        guard cardRepository.get(forKey: card.id) == nil else {
            let error = ErrorResponse(code: .unknownCode, header: "", body: "Esta tarjeta ya esta registrada", tecnicalDescription: "")
            complition(.failure(error: error))
            return
        }
        
        cardBalanceWebService.getBalace(for: card) { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let card, _):
                strongSelf.cardRepository.add(object: card)
                complition(.succes(card: card))
            case .failure:
                let error = ErrorResponse(code: .unknownCode, header: "", body: "Numero de tarjeta no valido. Pudes encontrar el numero al frente de tu tarjeta en la parte inferior", tecnicalDescription: "")
                complition(.failure(error: error))
            }
        }
    }
}
