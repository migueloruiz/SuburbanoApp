//
//  ActivitiesBoardPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum Calendar {
    case apple
}

class ActivitiesBoardPresenter {
    let activitiesUseCase: GetActivitiesUseCase?
    private var activities = [Activity]()
    private var activitiesModels = [AcvtivityCellViewModel]()
    
    var activitiesCount: Int {
        return activitiesModels.count
    }
    
    init() {
        activitiesUseCase = UseCaseLocator.getUseCase(ofType: GetActivitiesUseCase.self)
        activities = activitiesUseCase?.get() ?? []
        activitiesModels = activities.map { convert($0) }
    }
    
    func activity(at index: IndexPath) -> AcvtivityCellViewModel {
        return activitiesModels[index.row]
    }
    
    func remove(index: Int) {
        activitiesModels.remove(at: index)
    }
    
    func getActivity(withId id: String) -> Activity? {
        return activities.first(where: { $0.id == id })
    }
    
//    func shedule(activityId: String, at: Calendar) {
//        guard let activity = activities.first(where: { $0.id == activityId }) else { return }
//        print(activity)
//
//        let eventStore = EKEventStore()
//        switch EKEventStore.authorizationStatus(for: .event) {
//        case .notDetermined:
//            eventStore.requestAccess(to: .event) { (success, error) in
//                guard success else {
//                    print("denied")
//                    return
//                }
//            }
//        case .restricted, .denied:
//            print("denied")
//        case .authorized:
//            print("authorized")
//        }
//    }
}

extension ActivitiesBoardPresenter {
    func convert(_ activity: Activity) -> AcvtivityCellViewModel {
        return AcvtivityCellViewModel(id: activity.id,
                                      title: activity.title.uppercased(),
                                      descripcion: activity.descripcion.firstUppercased,
                                      date: activity.displayDate,
                                      schedule: activity.startHour,
                                      category: activity.categoryType)
    }
}
