//
//  TrainsWebSercive.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol TrainsWebSercive {
    func getTrains(completion: @escaping (ServiceResponse<[Train]>) -> Void)
}

class TrainsWebSerciveImpl: BaseService<[Train]>, TrainsWebSercive {
    func getTrains(completion: @escaping (ServiceResponse<[Train]>) -> Void) {
        guard let request = try? RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Trains)) else {
            completion(.failure(error: ErrorResponse.general()))
            return
        }
        make(request: request, completion: completion)
    }
}
