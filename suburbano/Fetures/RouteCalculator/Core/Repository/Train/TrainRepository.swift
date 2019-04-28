//
//  TrainRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol TrainRepository: Repository {
    func get(withDirection direction: String, day: String) -> [TrainEntity]
    func add(objects: [TrainEntity], update: Bool)
    func deleteAll()
}

class TrainRepositoryImpl: TrainRepository, DataBaseRepository {
    func get(withDirection direction: String, day: String) -> [TrainEntity] {
        let predicate = NSPredicate(format: "direction == %@ && day == %@", argumentArray: [direction, day])
        guard let realmActivities = get(type: RealmTrain.self, predicateFormat: predicate) else { return [] }
        return realmActivities.map { Train(entity: $0) }
    }

    func add(objects: [TrainEntity], update: Bool) {
        let realmTrain = objects.map { RealmTrain(entity: $0) }
        add(objects: realmTrain)
    }

    func deleteAll() {
        deleteAll(forType: RealmTrain.self)
    }
}
