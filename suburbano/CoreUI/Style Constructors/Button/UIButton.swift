//
//  UIButton.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/16/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

// MARK: Helpers

extension UIButton {
    func set(title: String) {
        setTitle(title, for: .normal)
        setTitle(title, for: .focused)
    }

    func set(image: UIImage?, color: UIColor) {
        setImage(image, for: .normal)
        setImage(image, for: .focused)
        imageView?.tintColor = color
        imageView?.contentMode = .scaleAspectFit
    }
}

// MARK: Style Constructors

extension UIButton {
    convenience init(style styleType: ActionButtonStyles,
                     title: String = "") {
        self.init()
        let style = styleType.style
        set(title: title)
        backgroundColor = style.backgroundColor
        titleLabel?.backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
        titleLabel?.textColor = style.textColor
        titleLabel?.font = style.font.getScaledFont()
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.adjustsFontForContentSizeCategory = true

        guard let radius = style.radius else { return }
        roundCorners(withRadius: radius)
        anchorSize(height: radius * 2)
        clipsToBounds = true
    }

    convenience init(circularStyle styleType: CircularButtonStyles,
                     image: UIImage?,
                     size: CGFloat = Theme.IconSize.normal) {
        self.init()
        let style = styleType.style
        set(image: image, color: style.tintColor)
        backgroundColor = style.backgroundColor
        anchorSquare(size: size)
        roundCorners(withRadius: size / 2)
        addDropShadow()
    }

    convenience init(navigationStyle styleType: NavigationButtonStyles) {
        self.init()
        let style = styleType.style
        set(image: style.icon, color: style.iconColor)
        anchorSquare(size: Theme.Size.button)
    }
}
