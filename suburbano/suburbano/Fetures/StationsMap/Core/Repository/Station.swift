//
//  Station.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol StationEntity {
    var id: Int { get }
    var name: String { get }
    var address: String { get }
    var conections: String { get }
    var markerImage: String { get }
    var markerTitleImage: String { get }
    var titleSide: Bool { get }
    var railLocation: Location { get }
    var accessLocation: Location { get }
}

struct Station: StationEntity, Codable {
    
    let id: Int
    let name: String
    let address: String
    let conections: String
    let markerImage: String
    let markerTitleImage: String
    let titleSide: Bool
    let railLocation: Location
    let accessLocation: Location
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case address = "address"
        case conections = "conections"
        case markerImage = "marker_image"
        case markerTitleImage = "marker_title_image"
        case titleSide = "title_side"
        case railLocation = "rail_location"
        case accessLocation = "access_location"
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(Int.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            address = try values.decode(String.self, forKey: .address)
            conections = try values.decode(String.self, forKey: .conections)
            markerImage = try values.decode(String.self, forKey: .markerImage)
            markerTitleImage = try values.decode(String.self, forKey: .markerTitleImage)
            titleSide = try values.decode(Bool.self, forKey: .titleSide)
            railLocation = try values.decode(Location.self, forKey: .railLocation)
            accessLocation = try values.decode(Location.self, forKey: .accessLocation)
        } catch let jsonError {
            throw jsonError
        }
    }
}

extension Station: Equatable {
    static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.name == rhs.name
    }
}
