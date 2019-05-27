//
//  Font.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

public protocol Font: RawRepresentable where Self.RawValue == String {
    func of(size: CGFloat) -> UIFont
}

public extension Font {
    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: rawValue, size: size) else {
            assertionFailure("Font not found: \(rawValue)")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    func of(textStyle: UIFont.TextStyle, largeFactor: CGFloat = 0) -> UIFont {
        let font = of(size: textStyle.size)
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: font, maximumPointSize: textStyle.size + largeFactor)
    }
}
