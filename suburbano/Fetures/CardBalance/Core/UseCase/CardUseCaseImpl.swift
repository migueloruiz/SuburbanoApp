//
//  CardUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum AddCardError: LocalizedError {
    case invalidIcon
    case invalidCardId
    case cardAlreadyRegistered
    case cardNotFound

    var failureReason: String? {
        switch self {
        case .invalidIcon: return nil
        case .invalidCardId: return nil
        case .cardAlreadyRegistered: return "Esta tarjeta ya esta registrada" // Localize
        case .cardNotFound: return "Número de tarjeta no valido. Puedes encontrar el numero al frente en la parte inferior de tu tarjeta" // Localize
        }
    }
}

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

        let now = Date().timeIntervalSince1970
        for card in cards {
            guard didCardExpire(now: now, card: card) else {
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

    func delate(withId id: String) {
        cardRepository.delateCard(withId: id)
        notifiCardsUpdate()
    }

    func validate(card: Card) throws {
        try isCardNumberValid(number: card.id)
        try isAlreadyRegister(card: card)
    }

    func add(card: Card, success: @escaping SuccessResponse<Card>, failure: @escaping AddCardErrorClosure) {
        cardBalanceWebService.getBalace(for: card, success: { [weak self] card in
            guard let strongSelf = self else { return }
            strongSelf.cardRepository.add(card: card)
            strongSelf.notifiCardsUpdate()
            success(card)
        }, failure: { _ in failure(.cardNotFound) })
    }
}

// MARK: Validations

extension CardUseCaseImpl {

    func didCardExpire(now: Double, card: Card) -> Bool {
        return (now - card.date) > Constants.fifteenMin
    }

    func isAlreadyRegister(card: Card) throws {
        if cardRepository.getCard(withId: card.id) != nil {
            throw AddCardError.invalidCardId
        }
    }

//    func isIconValid(icon: String) -> Bool {
//        switch icon {
//        case .initial: return false
//        case .custome: return true
//        }
//    }

    func isCardNumberValid(number: String) throws {
        if !number.matchesPattern(pattern: "^[0-9]+$") {
            throw AddCardError.invalidCardId
        }
    }
}

extension CardUseCaseImpl {
    fileprivate func notifiCardsUpdate() {
        NotificationCenter.default.post(name: .UpdateCards, object: nil)
    }
}
