//
//  Train.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

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

    init(entity: TrainEntity)
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
