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
    let activitiesRepository: ActivitiesRepository
    
    init(activitiesWebService: ActivitiesWebService,
         activitiesRepository: ActivitiesRepository) {
        self.activitiesWebService = activitiesWebService
        self.activitiesRepository = activitiesRepository
    }
    
    func load() {
        activitiesWebService.getActivities { [weak self] response in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let activities, _):
                strongSelf.activitiesRepository.deleteAll()
                strongSelf.activitiesRepository.add(objects: activities)
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func get() -> [Activity] {
        return activitiesRepository.get() ?? []
    }
}
