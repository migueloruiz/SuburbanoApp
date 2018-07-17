//
//  ActivitiesRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class ActivitiesRepository: RepositoryRealm {
    typealias RealElement = RealmActivity
    typealias Element = Activity
    
    var realmHandler: RealmHandler = RealmHandler()
    
    func get(forKey key: String) -> Activity? {
        guard let realmActivity = realmHandler.get(ofType: RealmActivity.self, forKey: key) else { return nil }
        return map(object: realmActivity)
    }
    
    func get() -> [Activity]? {
        guard let realmActivities = realmHandler.get(type: RealmActivity.self, predicateFormat: "", "") else { return nil }
        return realmActivities.map { map(object: $0)}
    }
    
    func add(object: Activity, update: Bool = true) {
        realmHandler.add(object: map(object: object))
    }
    
    func add(objects: [Activity], update: Bool = true) {
        let realmActivities = objects.map { map(object: $0) }
        realmHandler.add(objects: realmActivities)
    }
    
    func delete(object: Activity) {
        realmHandler.delete(object: map(object: object))
    }
    
    func delete(objects: [Activity]) {
        let realmActivities = objects.map { map(object: $0) }
        realmHandler.delete(objects: realmActivities)
    }
    
    func deleteAll() {
        realmHandler.deleteAll(forType: RealmActivity.self)
    }
    
    func map(object: RealmActivity) -> Activity {
        return Activity(id: object.id,
                 title: object.title,
                 descripcion: object.descripcion,
                 startDate: object.startDate,
                 endDate: object.endDate,
                 schedule: object.schedule,
                 category: object.category,
                 loaction: object.loaction)
    }
    
    func map(object: Activity) -> RealmActivity {
        let realmActivity = RealmActivity()
        realmActivity.id = object.id
        realmActivity.title = object.title
        realmActivity.descripcion = object.descripcion
        realmActivity.startDate = object.startDate
        realmActivity.endDate = object.endDate
        realmActivity.schedule = object.schedule
        realmActivity.category = object.category
        realmActivity.loaction = object.loaction
        return realmActivity
    }
}

