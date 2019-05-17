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
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners()
        view.addDropShadow()
        return view
    }

    static func createContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners(withRadius: Theme.Rounded.controller)
        view.addDropShadow()
        return view
    }

    static func createSeparatorView() -> UIView {
        let separator = UIView()
        separator.backgroundColor = Theme.Pallete.ligthGray
        separator.anchorSize(height: Theme.Size.separator)
        separator.roundCorners(withDiameter: Theme.Size.separator)
        return separator
    }

    static func createSquare(image: UIImage?, size: CGFloat, color: UIColor = Theme.Pallete.darkGray) -> UIImageView {
        let view = UIImageView(image: image)
        view.tintColor = color
        view.anchorSquare(size: size)
        return view
    }

    static func createImageView(image: UIImage?, color: UIColor) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        return imageView
    }
}
