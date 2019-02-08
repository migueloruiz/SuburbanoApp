//
//  TrainRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol TrainRepository {
    func get(withDirection direction: String, day: String) -> [TrainEntity]
    func add(objects: [TrainEntity], update: Bool)
    func deleteAll()
}

class TrainRepositoryRealmImpl: TrainRepository {

    let realmHandler: RealmHandler

    init(realmHandler: RealmHandler) {
        self.realmHandler = realmHandler
    }

    func get(withDirection direction: String, day: String) -> [TrainEntity] {
        let predicate = NSPredicate(format: "direction == %@ && day == %@", argumentArray: [direction, day])
        guard let realmActivities = realmHandler.get(type: RealmTrain.self, predicateFormat: predicate) else { return [] }
        return realmActivities.map { Train(entity: $0) }
    }

    func add(objects: [TrainEntity], update: Bool) {
        let realmTrain = objects.map { RealmTrain(entity: $0) }
        realmHandler.add(objects: realmTrain)
    }

    func deleteAll() {
        realmHandler.deleteAll(forType: RealmTrain.self)
    }
}
