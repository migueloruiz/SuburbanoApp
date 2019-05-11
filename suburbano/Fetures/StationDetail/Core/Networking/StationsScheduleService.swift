//
//  StationsScheduleService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/10/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationsScheduleService {
    func getSchedule(success: @escaping SuccessResponse<[StatiosSchedule]>, failure: @escaping ErrorResponse)
}

class StationsScheduleServiceImpl: BaseService<[StatiosSchedule]>, StationsScheduleService {
    func getSchedule(success: @escaping SuccessResponse<[StatiosSchedule]>, failure: @escaping ErrorResponse) {
        do {
            let request = try RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Schedule))
            make(request: request, success: success, failure: failure)
        } catch let error {
            failure(error)
        }
    }
}
