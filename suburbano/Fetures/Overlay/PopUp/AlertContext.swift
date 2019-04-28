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

    var title: String {
        switch self {
        case .confirmDelete: return "¿Estas seguro?" // Localize
        }
    }

    var disclaimer: String {
        switch self {
        case .confirmDelete: return "Seguro seguro segurisomo que quieres eliminar esta tarjeta" // Localize
        }
    }

    var primaryButton: String {
        switch self {
        case .confirmDelete: return "Volver" // Localize
        }
    }

    var secondaryButton: String? {
        switch self {
        case .confirmDelete: return "Eliminar" // Localize
        }
    }

    var image: UIImage {
        return #imageLiteral(resourceName: "sad")
    }
}
