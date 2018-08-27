//
//  CardBalanceUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class CardBalanceUseCaseImpl: CardBalanceUseCase {
    
    let cardBalanceWebService: CardBalanceWebService
//    let activitiesRepository: ActivitiesRepository
    
    init(cardBalanceWebService: CardBalanceWebService) {
        self.cardBalanceWebService = cardBalanceWebService
    }
    
    func update(cards: [Card]) -> [Card] {
        return []
    }
    
    func get(card: Card, complition: @escaping (GetCardResult) -> Void) {
        cardBalanceWebService.getBalace(for: card) { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let card, _):
    //            strongSelf.activitiesRepository.deleteAll()
    //            strongSelf.activitiesRepository.add(objects: activities)
                complition(.succes(card: card))
            case .failure(let error):
                complition(.failure(error: error))
            }
        }
    }
}
