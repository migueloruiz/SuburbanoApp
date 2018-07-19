//
//  ActivitiesBoardPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class ActivitiesBoardPresenter {
    let activitiesUseCase: GetActivitiesUseCase?
    private var activities = [Activity]()
    
    var activitiesCount: Int {
        return activities.count
    }
    
    init() {
        activitiesUseCase = UseCaseLocator.getUseCase(ofType: GetActivitiesUseCase.self)
        activities = activitiesUseCase?.get() ?? []
    }
    
    func activity(at index: IndexPath) -> Activity {
        return activities[index.row]
    }
    
    func remove(index: Int) {
        activities.remove(at: index)
    }
}
