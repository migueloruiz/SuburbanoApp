//
//  TrainsWebSercive.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol TrainsWebSercive {
    func getTrains(success: @escaping SuccessResponse<[Train]>, failure: @escaping ErrorResponse)
}

class TrainsWebSerciveImpl: BaseService<[Train]>, TrainsWebSercive {
    func getTrains(success: @escaping SuccessResponse<[Train]>, failure: @escaping ErrorResponse) {
        do {
            let request = try RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Trains))
            make(request: request, success: success, failure: failure)
        } catch let error {
            failure(error)
        }
    }
}
