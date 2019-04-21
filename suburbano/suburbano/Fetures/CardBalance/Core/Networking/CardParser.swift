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

typealias Timestamp = (unixTimestamp: Double, displayTimestamp: String)

class CardParser {

    private struct Constants {
        static let balanceRegex = "\\$[0-9]{1,5}\\.[0-9]{2}"
    }

    private let dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }

    func getParserMethod(card: Card) -> ParserMethod<Card> {
        return { [weak self] body in
            guard let strongSelf = self,
                let data = body,
                let rawBalance = String(data: data, encoding: .utf8),
                let balance = rawBalance.firstMatch(forRegex: Constants.balanceRegex) else { throw CardBalanceParser.valueNorFound }

            let timestamp = strongSelf.getTimestamp()
            return Card(id: card.id,
                        balance: balance,
                        icon: card.icon,
                        color: card.color,
                        displayDate: timestamp.displayTimestamp,
                        date: timestamp.unixTimestamp)
        }
    }

    func getTimestamp() -> Timestamp {
        let now = Date()
        return (unixTimestamp: now.timeIntervalSince1970,
                displayTimestamp: dateFormatter.string(from: now))
    }
}
