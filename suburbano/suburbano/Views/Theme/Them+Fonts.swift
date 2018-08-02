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
    
    static func getScaledFont(forFont name: String, textStyle: UIFontTextStyle) -> UIFont {
        
        /// Uncomment the code below to check all the available fonts and have them printed in the console to double check the font name with existing fonts 😉
        
        /*for family: String in UIFont.familyNames
         {
         print("\(family)")
         for names: String in UIFont.fontNames(forFamilyName: family)
         {
         print("== \(names)")
         }
         }*/
        
        
        let userFont =  UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let pointSize = userFont.pointSize
        guard let customFont = UIFont(name: name, size: 12) else {
            fatalError("""
                Failed to load the "\(name)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        return UIFontMetrics.default.scaledFont(for: customFont, maximumPointSize: 16)
    }
}
