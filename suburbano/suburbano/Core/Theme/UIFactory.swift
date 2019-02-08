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
        if !text.isEmpty { lable.text = text }
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

        guard let roundedTheme = theme.rounded else { return button }
        button.roundCorners(withRadius: roundedTheme.radius)
        button.anchorSize(height: roundedTheme.radius * 2)
        button.clipsToBounds = true
        return button
    }

    static func createCircularButton(image: UIImage?, tintColor: UIColor, backgroundColor: UIColor, addShadow: Bool = true) -> UIButton {
        let button = UIButton()
        button.set(image: image, color: tintColor)
        button.backgroundColor = backgroundColor
        button.anchorSquare(size: Theme.IconSize.normal)
        button.roundCorners(withRadius: Theme.IconSize.normal / 2)
        if addShadow { button.addDropShadow()}
        return button
    }

    static func createTextField(withTheme theme: FieldStyle) -> UITextField {
        let field = UITextField()
        field.textColor = theme.textColor
        field.tintColor = theme.tintColor
        field.backgroundColor = theme.backgroundColor
        field.font = theme.font.getScaledFont()
        field.keyboardType = theme.keyboardType
        field.autocorrectionType = theme.autocorrectionType
        return field
    }

    static func createCardView() -> UIView {
        let vw = UIView()
        vw.backgroundColor = .white
        vw.roundCorners()
        vw.addDropShadow()
        return vw
    }

    static func createContainerView() -> UIView {
        let vw = UIView()
        vw.backgroundColor = .white
        vw.roundCorners(withRadius: Theme.Rounded.controller)
        vw.addDropShadow()
        return vw
    }

    static func createSquare(image: UIImage?, size: CGFloat, color: UIColor = Theme.Pallete.darkGray) -> UIImageView {
        let view = UIImageView(image: image)
        view.tintColor = color
        view.anchorSquare(size: size)
        return view
    }

    static func createImageView(image: UIImage?, color: UIColor) -> UIImageView {
        let view = UIImageView(image: image)
        view.tintColor = color
        return view
    }
}
