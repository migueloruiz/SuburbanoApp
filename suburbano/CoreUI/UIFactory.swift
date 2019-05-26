//
//  UIFactory.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class UIFactory {
    static func createLable(withTheme theme: LabelStyle, text: String = "") -> UILabel {
        let lable = UILabel()
        lable.textColor = theme.textColor
        lable.numberOfLines = theme.numberOfLines
        lable.textAlignment = theme.textAlignment
        lable.backgroundColor = theme.backgroundColor
        lable.font = theme.font.getScaledFont()
        lable.adjustsFontSizeToFitWidth = true
        lable.adjustsFontForContentSizeCategory = true
        lable.minimumScaleFactor = 0.6
        if !text.isEmpty { lable.text = text }
        return lable
    }
}
