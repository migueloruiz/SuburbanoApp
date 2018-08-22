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
        static let softRed: UIColor = UIColor(named: "softRed") ?? .blue
        static let detailGray: UIColor = UIColor(named: "detailGray") ?? .blue
        static let darkBackground: UIColor = UIColor.black.withAlphaComponent(0.6)
        static let primaryAction: UIColor = UIColor(named: "concertColor") ?? .purple
        
        static let concert: UIColor = UIColor(named: "concertColor") ?? .purple
        static let workshop: UIColor = UIColor(named: "workshopColor") ?? .purple
        static let fair: UIColor = UIColor(named: "fairColor") ?? .purple
        static let exhibition: UIColor = UIColor(named: "exhibitionColor") ?? .purple
        static let special: UIColor = UIColor(named: "specialColor") ?? .purple
    }
    
    struct Animation {
        static let defaultInterval: TimeInterval = 0.5
        
        static let springWithDamping: CGFloat = 0.7
        static let initialSpringVelocity: CGFloat = 0.3
    }
    
    struct IconSize {
        static let extraSmall: CGFloat = 15
        static let small: CGFloat = 30
        static let normal: CGFloat = 40
        static let large: CGFloat = 50
        static let extraLarge: CGFloat = 100
    }
    
    struct Rounded {
        static let controller: CGFloat = 20
        static let button: CGFloat = 18
    }
    
    struct Offset {
        static let extralarge: CGFloat = 40
        static let large: CGFloat = 20
        static let normal: CGFloat = 10
        static let small: CGFloat = 5
        static let separator: CGFloat = 1
    }
    
    enum FontName: String {
        case montserrat = "Montserrat"
        case openSansCondensed = "OpenSansCondensed"
        case icons = "IconsCataloge"
    }
    
    enum FontStyle: String {
        case none = ""
        case medium = "Medium"
        case bold = "Bold"
    }
    
    enum FontSize: CGFloat {
        case icon = 40
        case smallIcon = 30
        case h1 = 20
        case h2 = 18
        case h3 = 16
        case general = 14
        case p = 12
    }
    
    struct FontFactor {
        static let large: CGFloat = 2
    }
}
