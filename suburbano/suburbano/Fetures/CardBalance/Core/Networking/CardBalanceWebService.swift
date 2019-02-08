//
//  CardBalanceWebService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol CardBalanceWebService {
    func getBalace(for: Card, success: @escaping SuccessResponse<Card>, failure: @escaping ErrorResponse)
}

class CardBalanceWebServiceImpl: BaseService<Card>, CardBalanceWebService {

    private let cardParser = CardParser()
    
    func getBalace(for card: Card, success: @escaping SuccessResponse<Card>, failure: @escaping ErrorResponse) {
        do {
            let request = try RequestFactory.make(.get, endoint: Endpoints.CardBalance(cardId: card.id))
            make(request: request, success: success, failure: failure, parser: cardParser.getParserMethod(card: card))
        } catch let error {
            failure(error)
        }
    }
}
