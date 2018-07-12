//
//  ActivitysService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class SymbolsWebService: BaseService<Activity> {
    func getEvents(completion: @escaping (ServiceResponse<Activity>) -> Void) {
        let request = RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Events))
        make(request: request!, completion: completion)
    }
}
