//
//  CardParser.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class CardParser {
    
    static let shared = CardParser()
    
    private let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    func parse(response: Data, card: Card) throws -> Card {
        let balance = String(data: response, encoding: String.Encoding.utf8) ?? ""
        let matches = balance.matches(forPattern: "\\$[0-9]{1,5}\\.[0-9]{2}")
        guard let match = matches.first else {
            throw DecodingError.valueNotFound(Card.self, DecodingError.Context(codingPath: [], debugDescription: "Value balance not found"))
        }
        let date = getDate()
        return Card(id: card.id,
                    balance: match,
                    icon: card.icon,
                    color: card.color,
                    displayDate: date.display,
                    date: date.timestamp)
    }
    
    func getDate() -> (timestamp: Double, display: String) {
        let now = Date()
        return (timestamp: now.timeIntervalSince1970, display: dateFormatter.string(from: now))
    }
}
