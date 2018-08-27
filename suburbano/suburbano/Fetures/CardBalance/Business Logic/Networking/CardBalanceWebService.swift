//
//  CardBalanceWebService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol CardBalanceWebService {
    func getBalace(for: Card, completion: @escaping (ServiceResponse<Card>) -> Void)
}

class CardBalanceWebServiceImpl: BaseService<Card>, CardBalanceWebService {
    
    func getBalace(for card: Card, completion: @escaping (ServiceResponse<Card>) -> Void) {
        guard let request = try? RequestFactory.make(.get, endoint: Endpoints.CardBalance(cardId: card.id)) else {
            completion(.failure(error: ErrorResponse.general()))
            return
        }
        make(request: request, parsingData: card, completion: completion)
    }
    
    override func parse(json: Data, parsingData: Any?) throws -> Card {
        guard let card = parsingData as? Card else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "TODO ERROR", underlyingError: nil))
        }
        return try CardParser.parse(response: json, card: card)
    }
}

class CardParser {
    static func parse(response: Data, card: Card) throws -> Card {
        let balance = String(data: response, encoding: String.Encoding.utf8) ?? ""
        let matches = balance.matches(forPattern: "\\$[0-9]{1,5}\\.[0-9]{2}")
        guard let match = matches.first else {
        throw DecodingError.valueNotFound(Card.self, DecodingError.Context(codingPath: [], debugDescription: "Value balance not found"))
        }
        return Card(id: card.id, balance: match, icon: card.icon, color: card.color)
    }
}
