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
        case .confirmDelete: return "¿Estas seguro?"
        case .errorAccessCalendar: return "Oups!"
        }
    }
    
    var disclaimer: String {
        switch self {
        case .confirmDelete: return "Seguro seguro segurisomo que quieres eliminar esta tarjeta"
        case .errorAccessCalendar: return "No tenemos permiso para accesar a tu calendario. Puedes darnos acceso en los ajustes de tu telefono"
        }
    }
    
    var primaryButton: String {
        switch self {
        case .confirmDelete, .errorAccessCalendar: return "Volver"
        }
    }
    
    var secondaryButton: String? {
        switch self {
        case .confirmDelete: return "Eliminar"
        case .errorAccessCalendar: return "Ajustes"
        }
    }
    
    var image: UIImage {
        return #imageLiteral(resourceName: "sad")
    }
}
