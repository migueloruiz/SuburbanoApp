//
//  Font.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

enum FontError: Error {
    case fontNotFound
}

public protocol Font: RawRepresentable where Self.RawValue == String {
    func font(forSize size: CGFloat) -> UIFont
}

extension Font {
    func font(forSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: rawValue, size: size) else {
            DebugLogger.record(error: FontError.fontNotFound, additionalInfo: ["font": rawValue])
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    func font(textStyle: UIFont.TextStyle, largeFactor: CGFloat = 0) -> UIFont {
        let fontFamily = font(forSize: textStyle.size)
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: fontFamily, maximumPointSize: textStyle.size + largeFactor)
    }
}
