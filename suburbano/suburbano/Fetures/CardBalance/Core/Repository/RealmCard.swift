//
//  RealmCard.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCard: Object, CardEntity {
    @objc dynamic var id: String = ""
    @objc dynamic var balance: String = ""
    @objc dynamic var icon: String = ""
    @objc dynamic var color: Data = Data()
    @objc dynamic var displayDate: String = ""
    @objc dynamic var date: Double = 0

    override class func primaryKey() -> String? {
        return "id"
    }
}
