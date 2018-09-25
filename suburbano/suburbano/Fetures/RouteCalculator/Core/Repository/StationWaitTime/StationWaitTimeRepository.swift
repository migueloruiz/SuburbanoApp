//
//  StationWaitTimeRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationWaitTimeRepository {
    func get(inStation station: String) -> [StationWaitTimeEntity]
    func add(objects: [StationWaitTimeEntity])
    func deleteAll()
}

class StationWaitTimeRepositoryImpl: StationWaitTimeRepository {
    
    let realmHandler: RealmHandler
    
    init(realmHandler: RealmHandler) {
        self.realmHandler = realmHandler
    }
    
    func get(inStation station: String) -> [StationWaitTimeEntity] {
        let predicate = NSPredicate(format: "station == %@", argumentArray: [station])
        guard let realmActivities = realmHandler.get(type: RealmStationWaitTime.self, predicateFormat: predicate) else { return [] }
        return realmActivities.map { StationWaitTime(entity: $0) }
    }
    
    func add(objects: [StationWaitTimeEntity]) {
        let realmTrain = objects.map { RealmStationWaitTime(entity: $0) }
        realmHandler.add(objects: realmTrain)
    }
    
    func deleteAll() {
        realmHandler.deleteAll(forType: RealmStationWaitTime.self)
    }
}
