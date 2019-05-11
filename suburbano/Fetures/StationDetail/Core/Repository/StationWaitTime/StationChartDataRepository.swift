//
//  StationWaitTimeRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationChartDataRepository: Repository {
    func get(inStation station: String) -> [StationChartDataEntity]
    func add(stationChartData: [StationChartDataEntity])
    func deleteAll()
}

class StationChartDataRepositoryImpl: StationChartDataRepository, DataBaseRepository {

    func get(inStation station: String) -> [StationChartDataEntity] {
        let predicate = NSPredicate(format: "station == %@", argumentArray: [station])
        guard let realmActivities = get(type: RealmStationChartData.self, predicateFormat: predicate, sortingKey: "timestamp", ascending: true) else { return [] }
        return realmActivities.map { StationChartData(entity: $0) }
    }

    func add(stationChartData: [StationChartDataEntity]) {
        let realmWaitTimes = stationChartData.map { RealmStationChartData(entity: $0) }
        add(objects: realmWaitTimes)
    }

    func deleteAll() {
        deleteAll(forType: RealmStationChartData.self)
    }
}
