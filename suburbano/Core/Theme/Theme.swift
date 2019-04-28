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
        static let white: UIColor = .white
        static let darkGray: UIColor = UIColor(named: "darkGray") ?? .red
        static let softGray: UIColor = UIColor(named: "softGray") ?? .red
        static let ligthGray: UIColor = UIColor(named: "ligthGray") ?? .red
        static let softRed: UIColor = UIColor(named: "softRed") ?? .blue
        static let darkRed: UIColor = UIColor(named: "darkRed") ?? .blue
        static let detailGray: UIColor = UIColor(named: "detailGray") ?? .blue
        static let darkBackground: UIColor = UIColor.black.withAlphaComponent(0.8)
        static let primaryAction: UIColor = UIColor(named: "concertColor") ?? .purple
        static let blue: UIColor = UIColor(named: "blue") ?? .purple

        static let concert: UIColor = UIColor(named: "concertColor") ?? .purple
        static let workshop: UIColor = UIColor(named: "workshopColor") ?? .purple
        static let fair: UIColor = UIColor(named: "fairColor") ?? .purple
        static let exhibition: UIColor = UIColor(named: "exhibitionColor") ?? .purple
        static let special: UIColor = UIColor(named: "specialColor") ?? .purple

        static let waitLow: UIColor = UIColor(named: "wait-low") ?? .gray
        static let waitMid: UIColor = UIColor(named: "wait-mid") ?? .gray
        static let waitHigh: UIColor = UIColor(named: "wait-high") ?? .gray
        static let waitMax: UIColor = UIColor(named: "wait-veryhigh") ?? .gray
    }

    struct Animation {
        static let defaultInterval: TimeInterval = 0.5
        static let smallInterval: TimeInterval = 0.3

        static let springWithDamping: CGFloat = 0.7
        static let initialSpringVelocity: CGFloat = 0.3
    }

    struct ContainerPropotion {
        static let porcent70: CGFloat = 0.7
    }

    struct IconSize {
        static let extraSmall: CGFloat = 15
        static let button: CGFloat = 25
        static let small: CGFloat = 30
        static let normal: CGFloat = 40
        static let large: CGFloat = 50
        static let extraLarge: CGFloat = 130
    }

    struct Rounded {
        static let controller: CGFloat = 10
        static let button: CGFloat = 20
    }

    struct Offset {
        static let extralarge: CGFloat = 40
        static let large: CGFloat = 20
        static let normal: CGFloat = 10
        static let small: CGFloat = 5
        static let selector: CGFloat = 2
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
