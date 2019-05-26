//
//  UIView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: Drop Shadow

    func addDropShadow(color: UIColor = Theme.Pallete.darkGray,
                       opacity: Float = 0.7,
                       offSet: CGSize = CGSize(width: 0, height: 1),
                       radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }

    func roundCorners(withRadius radius: CGFloat = 8) {
        layer.cornerRadius = radius
    }

    func roundCorners(withDiameter diameter: CGFloat) {
        layer.cornerRadius = diameter / 2
    }
}
