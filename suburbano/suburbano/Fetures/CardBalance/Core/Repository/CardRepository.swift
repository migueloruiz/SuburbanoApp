//
//  CardBalanceRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 27/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol CardRepository {
    func getCard(withId id: String) -> Card?
    func getCards() -> [Card]?
    func add(card: Card)
    func add(cards: [Card])
    func delateCard(withId id: String)
}

class CardRepositoryImpl: CardRepository, RealmRepository {
    typealias DBModel = RealmCard
    typealias Model = Card

    let realmHandler: RealmHandler

    init(realmHandler: RealmHandler) {
        self.realmHandler = realmHandler
    }

    func getCard(withId id: String) -> Card? {
        guard let realmCard = realmHandler.get(ofType: RealmCard.self, forKey: id) else { return nil }
        return mapToModel(dbModel: realmCard)
    }

    func getCards() -> [Card]? {
        guard let realmCards = realmHandler.get(type: RealmCard.self) else { return nil }
        return realmCards.map { mapToModel(dbModel: $0) }
    }

    func add(card: Card) {
        realmHandler.add(object: mapToDB(model: card))
    }

    func add(cards: [Card]) {
        let realmCards = cards.map { mapToDB(model: $0) }
        realmHandler.add(objects: realmCards)
    }

    func delateCard(withId id: String) {
        guard let realmCard = realmHandler.get(ofType: RealmCard.self, forKey: id) else { return }
        realmHandler.delete(object: realmCard)
    }

    func mapToModel(dbModel: RealmCard) -> Card {
        return Card(id: dbModel.id,
                    balance: dbModel.balance,
                    icon: dbModel.icon,
                    color: dbModel.color,
                    displayDate: dbModel.displayDate,
                    date: dbModel.date)

    }

    func mapToDB(model: Card) -> RealmCard {
        let realmCard = RealmCard()
        realmCard.id = model.id
        realmCard.balance = model.balance
        realmCard.icon = model.icon
        realmCard.color = model.color
        realmCard.displayDate = model.displayDate
        realmCard.date = model.date
        return realmCard
    }
}
