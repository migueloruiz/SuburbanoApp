//
//  RealmActivity.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmActivity: Object, ActivityEntity {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descripcion: String = ""
    @objc dynamic var startDate: String = ""
    @objc dynamic var endDate: String?
    @objc dynamic var schedule: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var loaction: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["category"]
    }
}


