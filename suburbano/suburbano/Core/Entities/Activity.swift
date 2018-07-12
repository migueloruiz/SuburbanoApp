//
//  Activity.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum Category: String {
    case concierto = "concierto"
    case tallere =  "tallere"
    case feria = "feria"
    case exposicione = "exposicione"
    case especial = "especial"
    case none = ""
    
    static func getCategory(fromCategory category: String) -> Category {
        return Category(rawValue: category) ?? .none
    }
}

protocol ActivityEntity {
    var title: String { get }
    var descripcion: String { get }
    var startDate: String { get }
    var endDate: String { get }
    var schedule: String { get }
    var category: String { get }
    var loaction: String { get }
}

struct Activity: ActivityEntity, Codable {
    let title: String
    let descripcion: String
    let startDate: String
    let endDate: String
    let schedule: String
    let category: String
    let loaction: String
    
    var categoryType: Category {
        return Category.getCategory(fromCategory: category)
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case descripcion = "descripcion"
        case startDate = "startDate"
        case endDate = "endDate"
        case schedule = "schedule"
        case category = "category"
        case loaction = "loaction"
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            title = try values.decode(String.self, forKey: .title)
            descripcion = try values.decode(String.self, forKey: .descripcion)
            startDate = try values.decode(String.self, forKey: .startDate)
            endDate = try values.decode(String.self, forKey: .endDate)
            schedule = try values.decode(String.self, forKey: .schedule)
            category = try values.decode(String.self, forKey: .category)
            loaction = try values.decode(String.self, forKey: .loaction)
        } catch let jsonError {
            throw jsonError
        }
    }
}
