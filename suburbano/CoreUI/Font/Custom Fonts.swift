//
//  Custom Fonts.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/27/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

enum Montserrat: String, Font {
    case regular = "Montserrat"
    case medium = "Montserrat-Medium"
    case bold = "Montserrat-Bold"
}

enum OpenSansCondensed: String, Font {
    case bold = "OpenSansCondensed-Bold"
}

enum IconsCataloge: String, Font {
    case regular = "IconsCataloge"
}

enum FontStyle {
    case largeTitle
    case title
    case primary
    case secondary
    case detail
    case chart

    var font: UIFont {
        switch self {
        case .largeTitle: return Montserrat.medium.font(textStyle: .title1)
        case .title: return Montserrat.medium.font(textStyle: .title3)
        case .primary: return Montserrat.medium.font(textStyle: .body)
        case .secondary: return Montserrat.medium.font(textStyle: .callout)
        case .detail: return Montserrat.medium.font(textStyle: .caption1)
        case .chart: return OpenSansCondensed.bold.font(textStyle: .body)
        }
    }
}
