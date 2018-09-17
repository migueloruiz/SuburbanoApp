//
//  UIStackView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArranged(subViews: [UIView]) {
        for view in subViews { addArrangedSubview(view) }
    }
    
    func removeAllArrangedViews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    static func with(axis: NSLayoutConstraint.Axis = .horizontal,
                     distribution: UIStackView.Distribution = .fillProportionally,
                     alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacing
        return stack
    }
}
