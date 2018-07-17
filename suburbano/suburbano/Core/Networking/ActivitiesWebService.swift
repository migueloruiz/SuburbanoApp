//
//  ActivitiesWebService.swoft
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol ActivitiesWebService {
     func getActivities(completion: @escaping (ServiceResponse<Activity>) -> Void)
}

class ActivitiesWebServiceImpl: BaseService<Activity>, ActivitiesWebService {
    func getActivities(completion: @escaping (ServiceResponse<Activity>) -> Void) {
        let request = RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Events))
        make(request: request!, completion: completion)
    }
}
