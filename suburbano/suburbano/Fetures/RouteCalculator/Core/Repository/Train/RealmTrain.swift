//
//  RealmTrain.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/22/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTrain: Object, TrainEntity {
    @objc dynamic var id: String = ""
    @objc dynamic var day: String = ""
    @objc dynamic var direction: String = ""
    @objc dynamic var startTimestamp: Int = 0
    @objc dynamic var rawBuenavista: RealmTrainStop? = RealmTrainStop()
    @objc dynamic var rawFortuna: RealmTrainStop? = RealmTrainStop()
    @objc dynamic var rawTalnepantla: RealmTrainStop? = RealmTrainStop()
    @objc dynamic var rawSanRafale: RealmTrainStop? = RealmTrainStop()
    @objc dynamic var rawLecheria: RealmTrainStop? = RealmTrainStop()
    @objc dynamic var rawTultitlan: RealmTrainStop? = RealmTrainStop()
    @objc dynamic var rawCuautitlan: RealmTrainStop? = RealmTrainStop()

    override class func primaryKey() -> String? { return "id" }

    required convenience init(entity: TrainEntity) {
        self.init()
        self.id = entity.id
        self.day = entity.day
        self.direction = entity.direction
        self.startTimestamp = entity.startTimestamp
        self.buenavista = entity.buenavista
        self.fortuna = entity.fortuna
        self.talnepantla = entity.talnepantla
        self.sanRafale = entity.sanRafale
        self.lecheria = entity.lecheria
        self.tultitlan = entity.tultitlan
        self.cuautitlan = entity.cuautitlan
    }

    var buenavista: TrainStop {
        get {
            guard let safeEntity = rawBuenavista else { return TrainStop(id: "") }
            return TrainStop(entity: safeEntity)
        }
        set(newValue) {
            rawBuenavista = RealmTrainStop(entity: newValue)
        }
    }

    var fortuna: TrainStop {
        get {
            guard let safeEntity = rawFortuna else { return TrainStop(id: "") }
            return TrainStop(entity: safeEntity)
        }
        set(newValue) {
            rawFortuna = RealmTrainStop(entity: newValue)
        }
    }

    var talnepantla: TrainStop {
        get {
            guard let safeEntity = rawTalnepantla else { return TrainStop(id: "") }
            return TrainStop(entity: safeEntity)
        }
        set(newValue) {
            rawTalnepantla = RealmTrainStop(entity: newValue)
        }
    }

    var sanRafale: TrainStop {
        get {
            guard let safeEntity = rawSanRafale else { return TrainStop(id: "") }
            return TrainStop(entity: safeEntity)
        }
        set(newValue) {
            rawSanRafale = RealmTrainStop(entity: newValue)
        }
    }

    var lecheria: TrainStop {
        get {
            guard let safeEntity = rawLecheria else { return TrainStop(id: "") }
            return TrainStop(entity: safeEntity)
        }
        set(newValue) {
            rawLecheria = RealmTrainStop(entity: newValue)
        }
    }

    var tultitlan: TrainStop {
        get {
            guard let safeEntity = rawTultitlan else { return TrainStop(id: "") }
            return TrainStop(entity: safeEntity)
        }
        set(newValue) {
            rawTultitlan = RealmTrainStop(entity: newValue)
        }
    }

    var cuautitlan: TrainStop {
        get {
            guard let safeEntity = rawCuautitlan else { return TrainStop(id: "") }
            return TrainStop(entity: safeEntity)
        }
        set(newValue) {
            rawCuautitlan = RealmTrainStop(entity: newValue)
        }
    }
}
