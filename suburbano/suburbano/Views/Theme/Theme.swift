//
//  Theme.swift
//  suburbano
//
//  Created by Miguel Ruiz on 19/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct Theme {
    struct Pallete {
        static let darkGray: UIColor = UIColor(named: "darkGray") ?? .red
        static let softGray: UIColor = UIColor(named: "softGray") ?? .red
        
        static let concert: UIColor = UIColor(named: "concertColor") ?? .purple
        static let workshop: UIColor = UIColor(named: "workshopColor") ?? .purple
        static let fair: UIColor = UIColor(named: "fairColor") ?? .purple
        static let exhibition: UIColor = UIColor(named: "exhibitionColor") ?? .purple
        static let special: UIColor = UIColor(named: "specialColor") ?? .purple
    }
    
    enum FontName: String {
        case montserrat = "Montserrat"
        case openSansCondensed = "OpenSansCondensed"
    }
    
    enum FontStyle: String {
        case medium = "Medium"
        case bold = "Bold"
    }
    
    enum FontSize: CGFloat {
        case general = 14
        case p = 12
    }
    
    struct FontFactor {
        static let small: CGFloat = -2
        static let large: CGFloat = 2
        static let extraLarge: CGFloat = 4
    }
}
