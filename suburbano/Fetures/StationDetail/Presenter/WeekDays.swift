//
//  WeekDays.swift
//  suburbano
//
//  Created by Miguel Ruiz on 12/5/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

enum WeekDays: Int, CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var title: String {
        switch self {
        case .sunday: return "Domingo" // Localize
        case .monday: return "Lunes" // Localize
        case .tuesday: return "Martes" // Localize
        case .wednesday: return "Miercoles" // Localize
        case .thursday: return "Jueves" // Localize
        case .friday: return "Viernes" // Localize
        case .saturday: return "Sabado" // Localize
        }
    }
}
