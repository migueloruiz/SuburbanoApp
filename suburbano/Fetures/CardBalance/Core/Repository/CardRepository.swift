//
//  CardBalanceRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 27/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol CardRepository: Repository {
    func getCard(withId id: String) -> Card?
    func getCards() -> [Card]?
    func add(card: Card)
    func add(cards: [Card])
    func delateCard(withId id: String)
}

class CardRepositoryImpl: CardRepository, DataBaseRepository {

    func getCard(withId id: String) -> Card? {
        guard let realmCard = get(ofType: RealmCard.self, forKey: id) else { return nil }
        return Card(entity: realmCard)
    }

    func getCards() -> [Card]? {
        guard let realmCards = get(type: RealmCard.self) else { return nil }
        return realmCards.map { Card(entity: $0) }
    }

    func add(card: Card) {
        add(object: RealmCard(entity: card))
    }

    func add(cards: [Card]) {
        let realmCards = cards.map { RealmCard(entity: $0) }
        add(objects: realmCards)
    }

    func delateCard(withId id: String) {
        guard let realmCard = get(ofType: RealmCard.self, forKey: id) else { return }
        delete(object: realmCard)
    }
}
