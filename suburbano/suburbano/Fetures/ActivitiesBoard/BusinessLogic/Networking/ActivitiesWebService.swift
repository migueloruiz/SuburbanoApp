//
//  ActivitiesWebService.swoft
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol ActivitiesWebService {
     func getActivities(completion: @escaping (ServiceResponse<[Activity]>) -> Void)
}

class ActivitiesWebServiceImpl: BaseService<[Activity]>, ActivitiesWebService {
    func getActivities(completion: @escaping (ServiceResponse<[Activity]>) -> Void) {
        guard let request = try? RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Events)) else {
            completion(.failure(error: ErrorResponse.general()))
            return
        }
        make(request: request, completion: completion)
    }
}
