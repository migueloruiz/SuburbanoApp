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
    func add(waitTimes: [StationWaitTimeEntity])
    func deleteAll()
}

class StationWaitTimeRepositoryImpl: StationWaitTimeRepository, DataBaseRepository {

    func get(inStation station: String) -> [StationWaitTimeEntity] {
        let predicate = NSPredicate(format: "station == %@", argumentArray: [station])
        guard let realmActivities = get(type: RealmStationWaitTime.self, predicateFormat: predicate, sortingKey: "timestamp", ascending: true) else { return [] }
        return realmActivities.map { StationWaitTime(entity: $0) }
    }

    func add(waitTimes: [StationWaitTimeEntity]) {
        let realmWaitTimes = waitTimes.map { RealmStationWaitTime(entity: $0) }
        add(objects: realmWaitTimes)
    }

    func deleteAll() {
        deleteAll(forType: RealmStationWaitTime.self)
    }
}
