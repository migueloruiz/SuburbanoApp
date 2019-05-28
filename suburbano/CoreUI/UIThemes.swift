//
//  UIThemes.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

// TODO: Refactor

protocol LabelStyle {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
}

struct LabelTheme: LabelStyle {
    let numberOfLines: Int
    let textAlignment: NSTextAlignment
    let textColor: UIColor
    let backgroundColor: UIColor
    let font: UIFont
}

struct RoundedStyle {
    let radius: CGFloat
}

struct UIThemes {

    // MARK: - Label Themes
    struct Label {

        // MARK: - ActivityCard Label Themes

        static let ActivityCardBody = LabelTheme(numberOfLines: 0,
                                                 textAlignment: .left,
                                                 textColor: Theme.Pallete.softGray,
                                                 backgroundColor: .white,
                                                 font: Montserrat.medium.font(textStyle: .caption1))

        // MARK: - Directions discraimer Label Themes
        static let DirectionsDisclainer = LabelTheme(numberOfLines: 0,
                                                 textAlignment: .left,
                                                 textColor: .white,
                                                 backgroundColor: .clear,
                                                 font: Montserrat.medium.font(textStyle: .caption1))
    }
}
