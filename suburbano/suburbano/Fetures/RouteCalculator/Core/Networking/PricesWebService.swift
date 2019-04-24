//
//  PricesWebService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol PricesWebService {
    func getPrices(success: @escaping SuccessResponse<[Price]>, failure: @escaping ErrorResponse)
}

class PricesWebServiceImpl: BaseService<[Price]>, PricesWebService {
    func getPrices(success: @escaping SuccessResponse<[Price]>, failure: @escaping ErrorResponse) {
        do {
            let request = try RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Prices))
            make(request: request, success: success, failure: failure)
        } catch let error {
            failure(error)
        }
    }
}
