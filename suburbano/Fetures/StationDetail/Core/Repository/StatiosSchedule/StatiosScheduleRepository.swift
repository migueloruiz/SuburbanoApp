//
//  StatiosScheduleRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/10/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

protocol StatiosScheduleRepository: Repository {
    func getSchedule() -> [StatiosScheduleEntity]
    func add(schedule: [StatiosScheduleEntity])
    func deleteAll()
}

class StatiosScheduleRepositoryImpl: StatiosScheduleRepository, DataBaseRepository {
    func getSchedule() -> [StatiosScheduleEntity] {
        guard let realmActivities = get(type: RealmStatiosSchedule.self, predicateFormat: nil) else { return [] }
        return realmActivities.map { StatiosSchedule(entity: $0) }
    }

    func add(schedule: [StatiosScheduleEntity]) {
        let realmSchedules = schedule.map { RealmStatiosSchedule(entity: $0) }
        add(objects: realmSchedules)
    }

    func deleteAll() {
        deleteAll(forType: RealmStatiosSchedule.self)
    }
}
