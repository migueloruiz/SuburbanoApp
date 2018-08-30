//
//  RealmStation.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStation: Object, StationEntity {
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var conections: String = ""
    @objc dynamic var markerImage: String = ""
    @objc dynamic var markerTitleImage: String = ""
    @objc dynamic var titleSide: Bool = false
    @objc dynamic var r_railLocation: RealmLocation?
    @objc dynamic var r_accessLocation: RealmLocation?
    
    override class func primaryKey() -> String? { return "name" }
    
    var railLocation: Location {
        get {
            return Location(latitude: r_railLocation?.latitude ?? 0, longitude: r_railLocation?.longitude ?? 0)
        }
        
        set(value) {
            let objectLocation = RealmLocation()
            objectLocation.latitude = value.latitude
            objectLocation.longitude = value.longitude
            r_railLocation = objectLocation
        }
    }
    
    var accessLocation: Location {
        get {
            return Location(latitude: r_accessLocation?.latitude ?? 0, longitude: r_accessLocation?.longitude ?? 0)
        }
        
        set(value) {
            let objectLocation = RealmLocation()
            objectLocation.latitude = value.latitude
            objectLocation.longitude = value.longitude
            r_accessLocation = objectLocation
        }
    }
}
