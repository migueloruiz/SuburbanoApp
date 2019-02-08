//
//  CardParser.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum CardBalanceParser: Error {
    case valueNorFound
}

class CardParser {
    
    private let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }

    func getParserMethod(card: Card) -> ParserMethod<Card> {
        return { [weak self] body in
            guard let strongSelf = self,
                let data = body,
                let balance = String(data: data, encoding: .utf8) else { throw ParsingError.noExistingBody }

            let matches = balance.matches(forPattern: "\\$[0-9]{1,5}\\.[0-9]{2}")
            guard let match = matches.first else { throw CardBalanceParser.valueNorFound }

            let date = strongSelf.getDate()
            return Card(id: card.id,
                        balance: match,
                        icon: card.icon,
                        color: card.color,
                        displayDate: date.display,
                        date: date.timestamp)
        }

    }
    
    func getDate() -> (timestamp: Double, display: String) {
        let now = Date()
        return (timestamp: now.timeIntervalSince1970, display: dateFormatter.string(from: now))
    }
}
