//
//  AlertContext.swift
//  suburbano
//
//  Created by Miguel Ruiz on 29/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum AlertContext {
    case confirmDelete
    case errorAccessCalendar
    
    var title: String {
        switch self {
        case .confirmDelete: return "¿Estas seguro?" // Localize
        case .errorAccessCalendar: return "Oups!" // Localize
        }
    }
    
    var disclaimer: String {
        switch self {
        case .confirmDelete: return "Seguro seguro segurisomo que quieres eliminar esta tarjeta" // Localize
        case .errorAccessCalendar: return "No tenemos permiso para accesar a tu calendario. Puedes darnos acceso en los ajustes de tu telefono" // Localize
        }
    }
    
    var primaryButton: String {
        switch self {
        case .confirmDelete, .errorAccessCalendar: return "Volver" // Localize
        }
    }
    
    var secondaryButton: String? {
        switch self {
        case .confirmDelete: return "Eliminar" // Localize
        case .errorAccessCalendar: return "Ajustes" // Localize
        }
    }
    
    var image: UIImage {
        return #imageLiteral(resourceName: "sad")
    }
}
