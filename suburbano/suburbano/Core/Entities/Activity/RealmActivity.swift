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
    @objc dynamic var category: String = ""
    @objc dynamic var loaction: String = ""
    @objc dynamic var displayDate: String = ""
    @objc dynamic var startHour: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var starDate: Int = 0
    @objc dynamic var endDate: Int = 0
    @objc dynamic var repeatEvent: String?

    override class func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["category", "endDate"]
    }
}
