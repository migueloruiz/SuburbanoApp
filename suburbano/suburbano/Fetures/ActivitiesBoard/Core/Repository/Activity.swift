//
//  Activity.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum Category: String {
    case concert = "concert"
    case workshop =  "workshop"
    case fair = "fair"
    case exhibition = "exhibition"
    case special = "special"
    case none = ""
    
    static func getCategory(fromCategory category: String) -> Category {
        return Category(rawValue: category) ?? .none
    }
}

protocol ActivityEntity {
    var id: String { get }
    var title: String { get }
    var descripcion: String { get }
    var category: String { get }
    var loaction: String { get }
    var displayDate: String { get }
    var startHour: String { get }
    var duration: Int { get }
    var starDate: Int { get }
    var endDate: Int { get }
    var repeatEvent: String? { get }
}

struct Activity: ActivityEntity, Codable {
    let id: String
    let title: String
    let descripcion: String
    let category: String
    let loaction: String
    let displayDate: String
    let startHour: String
    let duration: Int
    let starDate: Int
    let endDate: Int
    let repeatEvent: String?
    
    var categoryType: Category {
        return Category.getCategory(fromCategory: category)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descripcion
        case category
        case loaction
        case displayDate
        case startHour
        case duration
        case starDate
        case endDate
        case repeatEvent
    }
    
    init(id: String, title: String, descripcion: String, category: String, loaction: String, displayDate: String, startHour: String, duration: Int, starDate: Int, endDate: Int, repeatEvent: String?) {
        self.id = id
        self.title = title
        self.descripcion = descripcion
        self.category = category
        self.loaction = loaction
        self.displayDate = displayDate
        self.startHour = startHour
        self.duration = duration
        self.starDate = starDate
        self.endDate = endDate
        self.repeatEvent = repeatEvent
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            title = try values.decode(String.self, forKey: .title)
            descripcion = try values.decode(String.self, forKey: .descripcion)
            category = try values.decode(String.self, forKey: .category)
            loaction = try values.decode(String.self, forKey: .loaction)
            displayDate = try values.decode(String.self, forKey: .displayDate)
            startHour = try values.decode(String.self, forKey: .startHour)
            duration = try values.decode(Int.self, forKey: .duration)
            starDate = try values.decode(Int.self, forKey: .starDate)
            endDate = try values.decode(Int.self, forKey: .endDate)
            repeatEvent = try values.decodeIfPresent(String.self, forKey: .repeatEvent)
        } catch let jsonError {
            throw jsonError
        }
    }
}
