//
//  Train.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Entity
protocol TrainEntity {
    var id: String { get }
    var day: String { get }
    var direction: String { get }
    var startTimestamp: Int { get }
    var buenavista: TrainStop { get }
    var fortuna: TrainStop { get }
    var talnepantla: TrainStop { get }
    var sanRafale: TrainStop { get }
    var lecheria: TrainStop { get }
    var tultitlan: TrainStop { get }
    var cuautitlan: TrainStop { get }
}

// MARK: Struct
enum TrainDirection: String {
    case north = "North"
    case south = "South"
    
    // Refactor
    static func get(from departure: StationEntity, to arraival: StationEntity) -> TrainDirection {
        return (departure.distance - arraival.distance) > 0 ? .south : .north
    }
}

enum TripDay: String, CaseIterable {
    case normal = "Normal"
    case saturday = "Saturday"
    case sundayAndHolidays = "SundayAndHolidays"
    
    var selectionText: String {
        switch self {
        case .sundayAndHolidays: return "Domingos y Festivos" // Localize
        case .normal: return "Lunes a Viernes" // Localize
        case .saturday: return "Sabados" // Localize
        }
    }
    
    var openTime: String {
        switch self {
        case .sundayAndHolidays: return "7:00" // Localize
        case .normal: return "5:00" // Localize
        case .saturday: return "6:00" // Localize
        }
    }
    
    var closeTime: String {
        switch self {
        case .sundayAndHolidays, .normal, .saturday:
            return "00:30" // Localize
        }
    }
}

struct Train: TrainEntity, Codable {
    let id: String
    let day: String
    let direction: String
    let startTimestamp: Int
    let buenavista: TrainStop
    let fortuna: TrainStop
    let talnepantla: TrainStop
    let sanRafale: TrainStop
    let lecheria: TrainStop
    let tultitlan: TrainStop
    let cuautitlan: TrainStop
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case day = "day"
        case direction = "direction"
        case startTimestamp = "start_timestamp"
        case buenavista = "Buenavista"
        case fortuna = "Fortuna"
        case talnepantla = "Talnepantla"
        case sanRafale = "San Rafale"
        case lecheria = "Lecheria"
        case tultitlan = "Tultitlan"
        case cuautitlan = "Cuautitlan"
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            day = try values.decode(String.self, forKey: .day)
            direction = try values.decode(String.self, forKey: .direction)
            startTimestamp = try values.decode(Int.self, forKey: .startTimestamp)
            buenavista = try values.decode(TrainStop.self, forKey: .buenavista)
            fortuna = try values.decode(TrainStop.self, forKey: .fortuna)
            talnepantla = try values.decode(TrainStop.self, forKey: .talnepantla)
            sanRafale = try values.decode(TrainStop.self, forKey: .sanRafale)
            lecheria = try values.decode(TrainStop.self, forKey: .lecheria)
            tultitlan = try values.decode(TrainStop.self, forKey: .tultitlan)
            cuautitlan = try values.decode(TrainStop.self, forKey: .cuautitlan)
        } catch let jsonError {
            throw jsonError
        }
    }
    
    init(entity: TrainEntity) {
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
}

// MARK: Realm
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
    
    convenience init(entity: TrainEntity) {
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
