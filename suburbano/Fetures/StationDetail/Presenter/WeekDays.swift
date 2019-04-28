//
//  WeekDays.swift
//  suburbano
//
//  Created by Miguel Ruiz on 12/5/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

enum WeekDays: Int, CaseIterable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6

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
