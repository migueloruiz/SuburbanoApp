//
//  CardUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class CardUseCaseImpl: CardUseCase {

    private struct Constants {
        static let fifteenMin: Double = 900
    }

    let cardBalanceWebService: CardBalanceWebService
    let cardRepository: CardRepository

    init(cardBalanceWebService: CardBalanceWebService,
         cardRepository: CardRepository) {
        self.cardBalanceWebService = cardBalanceWebService
        self.cardRepository = cardRepository
    }

    func get() -> [Card] {
        return cardRepository.getCards() ?? []
    }

    func updateCards() {
        guard let cards = cardRepository.getCards() else { return }
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
            strongSelf.cardRepository.add(cards: updatedCards)
            strongSelf.notifiCardsUpdate()
        })
    }

    func isAlreadyRegister(card: Card) -> Bool {
        return !(cardRepository.getCard(withId: card.id) == nil)
    }

    func delate(withId id: String) {
        cardRepository.delateCard(withId: id)
        notifiCardsUpdate()
    }

    func add(card: Card, success: @escaping SuccessResponse<Card>, failure: @escaping ErrorResponse) {
        cardBalanceWebService.getBalace(for: card, success: { [weak self] card in
            guard let strongSelf = self else { return }
                strongSelf.cardRepository.add(card: card)
                strongSelf.notifiCardsUpdate()
                success(card)
        }, failure: failure)
    }
}

extension CardUseCaseImpl {
    fileprivate func notifiCardsUpdate() {
        NotificationCenter.default.post(name: .UpdateCards, object: nil)
    }

    fileprivate func shouldUpdate(card: Card) -> Bool { // TODO: better name and inject Date
        return (Date().timeIntervalSince1970 - card.date) > Constants.fifteenMin
    }
}
