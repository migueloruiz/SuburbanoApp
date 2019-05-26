//
//  UIView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UIView {

    // MARK: Helpers
    func addDropShadow(color: UIColor = Theme.Pallete.darkGray,
                       opacity: Float = 0.7,
                       offSet: CGSize = CGSize(width: 0, height: 1),
                       radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }

    func roundCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
    }

    func roundCorners(withDiameter diameter: CGFloat) {
        layer.cornerRadius = diameter / 2
    }

    // MARK: Styles

    convenience init(style styleType: ViewStyles) {
        self.init()
        let style = styleType.style
        backgroundColor = style.backgroundColor
        roundCorners(withRadius: style.radius)
        if style.hasShadow { addDropShadow() }
    }

    static func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = Theme.Pallete.ligthGray
        separator.anchorSize(height: Theme.Size.separator)
        separator.roundCorners(withDiameter: Theme.Size.separator)
        return separator
    }
}
