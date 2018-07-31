//
//  UseCaseLocator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class UseCaseLocator {
    
    static func getUseCase<UseCase>(ofType type: UseCase.Type) -> UseCase? {
        switch String(describing: type) {
        case String(describing: LoadActivitiesUseCase.self),
             String(describing: GetActivitiesUseCase.self),
             String(describing: ActivitiesUseCase.self):
            return ActivitiesUseCaseImpl(
                activitiesWebService: ActivitiesWebServiceImpl(),
                activitiesRepository: ActivitiesRepository()
            ) as? UseCase
        default:
            return nil
        }

    }
}