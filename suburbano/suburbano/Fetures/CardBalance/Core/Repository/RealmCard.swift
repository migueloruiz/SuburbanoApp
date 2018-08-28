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
    @objc dynamic var color: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
