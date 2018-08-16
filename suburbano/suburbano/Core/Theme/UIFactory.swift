//
//  UIFactory.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class UIFactory {
    static func createLable(withTheme theme: LabelStyle, title: String = "") -> UILabel {
        let lable = UILabel()
        lable.textColor = theme.textColor
        lable.numberOfLines = theme.numberOfLines
        lable.textAlignment = theme.textAlignment
        lable.backgroundColor = theme.backgroundColor
        lable.font = theme.font.getScaledFont()
        lable.adjustsFontSizeToFitWidth = true
        lable.adjustsFontForContentSizeCategory = true
        lable.minimumScaleFactor = 10
        
        if !title.isEmpty {
            lable.text = title
        }
        
        return lable
    }
    
    static func createButton(withTitle title: String, theme: ButtonStyle) -> UIButton {
        let button = UIButton()
        button.set(title: title)
        button.backgroundColor = theme.backgroundColor
        button.titleLabel?.backgroundColor = theme.backgroundColor
        button.setTitleColor(theme.textColor, for: .normal)
        button.titleLabel?.textColor = theme.textColor
        button.titleLabel?.font = theme.font.getScaledFont()
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        if theme.rounded {
            button.roundCorners()
            button.clipsToBounds = true
        }
        
        return button
    }
}
