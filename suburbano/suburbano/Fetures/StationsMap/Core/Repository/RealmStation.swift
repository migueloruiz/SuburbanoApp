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
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var conections: String = ""
    @objc dynamic var markerImage: String = ""
    @objc dynamic var markerTitleImage: String = ""
    @objc dynamic var titleSide: Bool = false
    @objc dynamic var safeRailLocation: RealmLocation?
    @objc dynamic var safeAccessLocation: RealmLocation?
    
    override class func primaryKey() -> String? { return "name" }
    
    var railLocation: Location {
        get {
            return Location(latitude: safeRailLocation?.latitude ?? 0, longitude: safeRailLocation?.longitude ?? 0)
        }
        
        set(value) {
            let objectLocation = RealmLocation()
            objectLocation.latitude = value.latitude
            objectLocation.longitude = value.longitude
            safeRailLocation = objectLocation
        }
    }
    
    var accessLocation: Location {
        get {
            return Location(latitude: safeAccessLocation?.latitude ?? 0, longitude: safeAccessLocation?.longitude ?? 0)
        }
        
        set(value) {
            let objectLocation = RealmLocation()
            objectLocation.latitude = value.latitude
            objectLocation.longitude = value.longitude
            safeAccessLocation = objectLocation
        }
    }
}
