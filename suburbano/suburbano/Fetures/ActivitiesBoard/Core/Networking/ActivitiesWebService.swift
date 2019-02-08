//
//  ActivitiesWebService.swoft
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol ActivitiesWebService {
     func getActivities(success: @escaping SuccessResponse<[Activity]>, failure: @escaping ErrorResponse)
}

class ActivitiesWebServiceImpl: BaseService<[Activity]>, ActivitiesWebService {
    func getActivities(success: @escaping SuccessResponse<[Activity]>, failure: @escaping ErrorResponse) {
        do {
            let request = try RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Events))
            make(request: request, success: success, failure: failure)
        } catch let error {
            failure(error)
        }
    }
}
