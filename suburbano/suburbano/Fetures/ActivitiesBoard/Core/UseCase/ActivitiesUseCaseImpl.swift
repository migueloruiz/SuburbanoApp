//
//  ActivitiesUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class ActivitiesUseCaseImpl: ActivitiesUseCase {

    let activitiesWebService: ActivitiesWebService
    let activitiesRepository: ActivitiesRepository // Decouple
    
    init(activitiesWebService: ActivitiesWebService,
         activitiesRepository: ActivitiesRepository) {
        self.activitiesWebService = activitiesWebService
        self.activitiesRepository = activitiesRepository
    }
    
    func updateActivities() {
        activitiesWebService.getActivities(success: { [weak self] activities in
            guard let strongSelf = self else { return }
            strongSelf.activitiesRepository.deleteAll()
            strongSelf.activitiesRepository.add(objects: activities)
        }, failure: {_ in })
    }
    
    func get(byDate date: Int) -> [Activity] {
        let predicate = NSPredicate(format: "endDate > %d", argumentArray: [date])
        return activitiesRepository.get(predicateFormat: predicate) ?? []
    }
}
