//
//  FontStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 19/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct FontStyle {
    private let size: Theme.FontSize
    private let largeFactor: CGFloat
    private let name: Theme.FontName
    private let style: Theme.FontStyle

    init(size: Theme.FontSize, largeFactor: CGFloat, name: Theme.FontName, style: Theme.FontStyle) {
        self.size = size
        self.largeFactor = largeFactor
        self.name = name
        self.style = style
    }

    func getScaledFont() -> UIFont {
        let fontName = style != .none ? "\(name.rawValue)-\(style.rawValue)" : name.rawValue
        let font = UIFont(name: fontName, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
        return UIFontMetrics.default.scaledFont(for: font, maximumPointSize: size.rawValue + largeFactor)
    }
}
