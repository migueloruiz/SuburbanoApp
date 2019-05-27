//
//  UILabel.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(style styleType: LabelStyles, text: String = "") {
        self.init()
        let style = styleType.style
        textColor = style.textColor
        numberOfLines = style.numberOfLines
        textAlignment = style.textAlignment
        backgroundColor = style.backgroundColor
        font = style.font.getScaledFont()
        adjustsFontSizeToFitWidth = true
        adjustsFontForContentSizeCategory = true
        minimumScaleFactor = 0.6
        if !text.isEmpty { self.text = text }
    }
}
