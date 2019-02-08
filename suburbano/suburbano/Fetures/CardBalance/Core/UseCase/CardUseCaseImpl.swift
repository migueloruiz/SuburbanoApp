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
    let cardRepository: CardRepository // Decouple Repository

    init(cardBalanceWebService: CardBalanceWebService,
         cardRepository: CardRepository) {
        self.cardBalanceWebService = cardBalanceWebService
        self.cardRepository = cardRepository
    }

    func get() -> [Card] {
        return cardRepository.get() ?? []
    }

    func updateCards() {
        guard let cards = cardRepository.get() else { return }
        let dispatchGroup = DispatchGroup()
        var updatedCards: [Card] = []

        for _ in cards { dispatchGroup.enter() }

        for card in cards {
            guard shouldUpdate(card: card) else {
                dispatchGroup.leave()
                continue
            }

            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cardBalanceWebService.getBalace(for: card, success: { card in
                    updatedCards.append(card)
                    dispatchGroup.leave()
                }, failure: {_ in })
            }
        }

        dispatchGroup.notify(queue: .global(qos: .background), execute: { [weak self] in
            guard let strongSelf = self, !updatedCards.isEmpty else { return }
            strongSelf.cardRepository.add(objects: updatedCards)
            strongSelf.notifiCardsUpdate()
        })
    }

    func isAlreadyRegister(card: Card) -> Bool {
        return cardRepository.get(forKey: card.id) == nil ? false : true
    }

    func delate(withId id: String) {
        cardRepository.delate(withId: id)
        notifiCardsUpdate()
    }

    func add(card: Card, success: @escaping SuccessResponse<Card>, failure: @escaping ErrorResponse) {
        cardBalanceWebService.getBalace(for: card, success: { [weak self] card in
            guard let strongSelf = self else { return }
                strongSelf.cardRepository.add(object: card)
                strongSelf.notifiCardsUpdate()
                success(card)
        }, failure: failure)
    }
}

extension CardUseCaseImpl {
    fileprivate func notifiCardsUpdate() {
        NotificationCenter.default.post(name: .UpdateCards, object: nil)
    }

    fileprivate func shouldUpdate(card: Card) -> Bool {
        let now = Date().timeIntervalSince1970
        return (now - card.date) > 900
    }
}
