//
//  StationWaitTimeRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationWaitTimeRepository: Repository {
    func get(inStation station: String) -> [StationWaitTimeEntity]
    func add(objects: [StationWaitTimeEntity])
    func deleteAll()
}

class StationWaitTimeRepositoryImpl: StationWaitTimeRepository, DataBaseRepository {

    func get(inStation station: String) -> [StationWaitTimeEntity] {
        let predicate = NSPredicate(format: "station == %@", argumentArray: [station])
        guard let realmActivities = get(type: RealmStationWaitTime.self, predicateFormat: predicate, sortingKey: "timestamp", ascending: true) else { return [] }
        return realmActivities.map { StationWaitTime(entity: $0) }
    }

    func add(objects: [StationWaitTimeEntity]) {
        let realmTrain = objects.map { RealmStationWaitTime(entity: $0) }
        add(objects: realmTrain)
    }

    func deleteAll() {
        deleteAll(forType: RealmStationWaitTime.self)
    }
}
