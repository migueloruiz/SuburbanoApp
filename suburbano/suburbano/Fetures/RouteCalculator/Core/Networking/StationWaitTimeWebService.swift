//
//  StationWaitTimeWebService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationWaitTimeWebService {
    func getWaitTimes(completion: @escaping (ServiceResponse<[StationWaitTime]>) -> Void)
}

class StationWaitTimeWebServiceImpl: BaseService<[StationWaitTime]>, StationWaitTimeWebService {
    func getWaitTimes(completion: @escaping (ServiceResponse<[StationWaitTime]>) -> Void) {
        guard let request = try? RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.WaitTime)) else {
            completion(.failure(error: ErrorResponse.general()))
            return
        }
        make(request: request, completion: completion)
    }
}
