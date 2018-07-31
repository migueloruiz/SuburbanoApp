//
//  AccessibilityFontSizes.swift
//  suburbano
//
//  Created by Miguel Ruiz on 19/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct Font {
    private let size: Theme.FontSize
    private let smallFactor: CGFloat
    private let largeFactor: CGFloat
    private let extraLargeFactor: CGFloat
    private let name: Theme.FontName
    private let style: Theme.FontStyle
    
    init(size: Theme.FontSize = .general,
         smallFactor: CGFloat = Theme.FontFactor.small,
         largeFactor: CGFloat = Theme.FontFactor.large,
         extraLargeFactor: CGFloat = Theme.FontFactor.extraLarge,
         name: Theme.FontName = .montserrat,
         style: Theme.FontStyle = .medium) {
        self.size = size
        self.smallFactor = smallFactor
        self.largeFactor = largeFactor
        self.extraLargeFactor = extraLargeFactor
        self.name = name
        self.style = style
    }
    
    var defaultFont: UIFont {
        let fontName = "\(name.rawValue)-\(style.rawValue)"
        return UIFont(name: fontName, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    
    func fontSize(forCategory contentSizeCategory: UIContentSizeCategory) -> CGFloat {
        switch contentSizeCategory {
        case .extraSmall, .small: return size.rawValue + smallFactor
        case .medium: return size.rawValue
        case .large: return size.rawValue + largeFactor
        default: return size.rawValue + extraLargeFactor
        }
    }
}
