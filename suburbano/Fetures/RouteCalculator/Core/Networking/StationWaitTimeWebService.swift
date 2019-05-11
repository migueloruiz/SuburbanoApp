//
//  StationWaitTimeWebService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationWaitTimeWebService {
    func getWaitTimes(success: @escaping SuccessResponse<[StationChartData]>, failure: @escaping ErrorResponse)
}

class StationWaitTimeWebServiceImpl: BaseService<[StationChartData]>, StationWaitTimeWebService {
    func getWaitTimes(success: @escaping SuccessResponse<[StationChartData]>, failure: @escaping ErrorResponse) {
        do {
            let request = try RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.WaitTime))
            make(request: request, success: success, failure: failure)
        } catch let error {
            failure(error)
        }
    }
}
