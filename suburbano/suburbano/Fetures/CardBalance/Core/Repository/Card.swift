//
//  Card.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import UIKit

protocol CardEntity {
    var id: String { get }
    var balance: String { get }
    var icon: String { get }
    var color: Data { get }
    var date: Double { get }
}

struct Card: CardEntity, Codable {
    let id: String
    var balance: String
    var icon: String
    var color: Data
    var date: Double
    
    var displayColor: UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: color) as? UIColor ?? Theme.Pallete.darkGray
    }
}
