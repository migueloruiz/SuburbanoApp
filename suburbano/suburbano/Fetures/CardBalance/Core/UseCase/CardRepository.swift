//
//  CardBalanceRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 27/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class CardRepository: RepositoryRealm {
    typealias RealElement = RealmCard
    typealias Element = Card
    
    var realmHandler: RealmHandler = RealmHandler()

    func get(forKey key: String) -> Card? {
        guard let realmCard = realmHandler.get(ofType: RealmCard.self, forKey: key) else { return nil }
        return map(object: realmCard)
    }
    
    func get(predicateFormat: NSPredicate? = nil) -> [Card]? {
        guard let realmCards = realmHandler.get(type: RealmCard.self, predicateFormat: predicateFormat) else { return nil }
        return realmCards.map { map(object: $0) }
    }
    
    func add(object: Card, update: Bool = true) {
        realmHandler.add(object: map(object: object))
    }
    
    func add(objects: [Card], update: Bool = true) {
        let realmCards = objects.map { map(object: $0) }
        realmHandler.add(objects: realmCards)
    }
    
    func delete(object: Card) {
        realmHandler.delete(object: map(object: object))
    }
    
    func delate(withId id: String) {
        guard let realmCard = realmHandler.get(ofType: RealmCard.self, forKey: id) else { return }
        realmHandler.delete(object: realmCard)
    }
    
    func delete(objects: [Card]) {
        let realmCards = objects.map { map(object: $0) }
        realmHandler.delete(objects: realmCards)
    }
    
    func deleteAll() {
        realmHandler.deleteAll(forType: RealmCard.self)
    }
    
    func map(object: RealmCard) -> Card {
        return Card(id: object.id,
                    balance: object.balance,
                    icon: object.icon,
                    color: object.color,
                    date: object.date)
    }
    
    func map(object: Card) -> RealmCard {
        let realmCard = RealmCard()
        realmCard.id = object.id
        realmCard.balance = object.balance
        realmCard.icon = object.icon
        realmCard.color = object.color
        realmCard.date = object.date
        return realmCard
    }
}
