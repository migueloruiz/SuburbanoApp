//
//  RealmLocation.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLocation: Object, LocationEntity {

    @objc dynamic var key: String = ""
    @objc dynamic var latitude: Double = 0 {
        didSet { setKey() }
    }

    @objc dynamic var longitude: Double = 0 {
        didSet { setKey() }
    }

    override class func primaryKey() -> String? { return "key" }

    private func setKey() {
        key = "\(latitude)-\(longitude)"
    }
}
