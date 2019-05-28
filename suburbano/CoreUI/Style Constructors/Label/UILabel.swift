//
//  UILabel.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UILabel {

    enum LineStyle: Int {
        case multiline = 0
        case oneLinne = 1
    }

    convenience init(fontStyle: FontStyle, alignment: NSTextAlignment, line: LineStyle, color: ColorLabelStyles) {
        self.init()
        font = fontStyle.font
        adjustsFontSizeToFitWidth = true
        adjustsFontForContentSizeCategory = true
        minimumScaleFactor = 0.6

        let colorStyle = color.style
        textColor = colorStyle.textColor
        backgroundColor = colorStyle.backgroundColor

        textAlignment = alignment
        numberOfLines = line.rawValue
    }

    convenience init(iconSize: CGFloat) {
        self.init()
        font = IconsCataloge.regular.font(forSize: iconSize)
        adjustsFontSizeToFitWidth = true
        adjustsFontForContentSizeCategory = true
        minimumScaleFactor = 0.6
        textColor = Theme.Pallete.softGray
        textAlignment = .center
        numberOfLines = LineStyle.oneLinne.rawValue
    }
}
