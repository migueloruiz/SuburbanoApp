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
        lable.minimumScaleFactor = 10
        
        if !text.isEmpty {
            lable.text = text
        }
        
        return lable
    }
    
    static func createButton(withTheme theme: ButtonStyle, title: String = "") -> UIButton {
        let button = UIButton()
        button.set(title: title)
        button.backgroundColor = theme.backgroundColor
        button.titleLabel?.backgroundColor = theme.backgroundColor
        button.setTitleColor(theme.textColor, for: .normal)
        button.titleLabel?.textColor = theme.textColor
        button.titleLabel?.font = theme.font.getScaledFont()
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        if let roundedTheme = theme.rounded {
            button.roundCorners(withRadius: roundedTheme.radius)
            button.anchorSize(height: roundedTheme.radius * 2)
            button.clipsToBounds = true
        }
        
        return button
    }
    
    static func createCardView() -> UIView {
        let vw = UIView()
        vw.backgroundColor = .white
        vw.roundCorners()
        vw.addDropShadow()
        return vw
    }
}
