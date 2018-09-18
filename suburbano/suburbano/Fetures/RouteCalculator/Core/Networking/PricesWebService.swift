//
//  PricesWebService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol PricesWebService {
    func getPrices(completion: @escaping (ServiceResponse<[TripPrice]>) -> Void)
}

class PricesWebServiceImpl: BaseService<[TripPrice]>, PricesWebService {
    func getPrices(completion: @escaping (ServiceResponse<[TripPrice]>) -> Void) {
        guard let request = try? RequestFactory.make(.get, endoint: Endpoints.GeneralResource(resource: WebResources.Prices)) else {
            completion(.failure(error: ErrorResponse.general()))
            return
        }
        make(request: request, completion: completion)
    }
}
