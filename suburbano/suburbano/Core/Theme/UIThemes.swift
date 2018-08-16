//
//  UIThemes.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol LabelStyle {
    var numberOfLines: Int { get }
    var textAlignment: NSTextAlignment { get }
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var font: FontStyle { get }
}

struct LabelTheme: LabelStyle {
    let numberOfLines: Int
    let textAlignment: NSTextAlignment
    let textColor: UIColor
    let backgroundColor: UIColor
    let font: FontStyle
}

protocol ButtonStyle {
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var font: FontStyle { get }
}

struct ButtonTheme: ButtonStyle {
    let textColor: UIColor
    let backgroundColor: UIColor
    let font: FontStyle
}

struct UIThemes {
    
    // MARK: - Label Themes
    struct Label {
        // MARK: - General Label Themes
        static let NavTitle = LabelTheme(numberOfLines: 1,
                                         textAlignment: .center,
                                         textColor: .white,
                                         backgroundColor: Theme.Pallete.softRed,
                                         font: FontStyle(size: .h1, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        
        // MARK: - ActivityCard Label Themes
        static let ActivityCardTitle = LabelTheme(numberOfLines: 0,
                                                  textAlignment: .left,
                                                  textColor: Theme.Pallete.darkGray,
                                                  backgroundColor: .white,
                                                  font: FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        static let ActivityCardDetails = LabelTheme(numberOfLines: 0,
                                                    textAlignment: .left,
                                                    textColor: Theme.Pallete.darkGray,
                                                    backgroundColor: .white,
                                                    font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .openSansCondensed, style: .bold))
        static let ActivityCardBody = LabelTheme(numberOfLines: 0,
                                                 textAlignment: .left,
                                                 textColor: Theme.Pallete.softGray,
                                                 backgroundColor: .white,
                                                 font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
    }
    
    // MARK: - Button Themes
    struct Button {
        // MARK: - ActivityCard Button Themes
        static let ActivityCard = ButtonTheme(textColor: Theme.Pallete.darkGray,
                                              backgroundColor: .white,
                                              font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        
    }
}
