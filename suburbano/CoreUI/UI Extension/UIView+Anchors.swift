//
//  UIView+Anchors.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension UIView {

    func addSubViews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }

    func fill(verticalOffset: CGFloat = 0, horizontalOffset: CGFloat = 0) {
        fillHorizontal(offset: horizontalOffset)
        fillVertically(offset: verticalOffset)
    }

    func fillVertically(offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard  let superview = superview else { return }
        topAnchor.constraint(equalTo: superview.topAnchor, constant: offset).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -offset).isActive = true
    }

    func fillHorizontal(offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard  let superview = superview else { return }
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: offset).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -offset).isActive = true
    }

    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()
        if let top = top { anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant, identifier: .top))}
        if let left = left { anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant, identifier: .left)) }
        if let bottom = bottom { anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant, identifier: .bottom)) }
        if let right = right { anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant, identifier: .right)) }
        anchors.forEach { $0.isActive = true }
        return anchors
    }

    @discardableResult
    func anchorSize(width: CGFloat = 0, height: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()
        if width > 0 { anchors.append(widthAnchor.constraint(equalToConstant: width, identifier: .width)) }
        if height > 0 { anchors.append(heightAnchor.constraint(equalToConstant: height, identifier: .height)) }
        anchors.forEach { $0.isActive = true }
        return anchors
    }

    @discardableResult
    func anchorSize(width: NSLayoutDimension?, widthMultiplier: CGFloat = 1, height: NSLayoutDimension?, heightMultiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        if let width = width { anchors.append(widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier, identifier: .width)) }
        if let height = height { anchors.append(heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier, identifier: .height))}
        anchors.forEach { $0.isActive = true }
        return anchors
    }

    @discardableResult
    func anchorSquare(size: CGFloat) -> [NSLayoutConstraint] {
        return anchorSize(width: size, height: size)
    }

    func center(x: NSLayoutXAxisAnchor? = nil, y: NSLayoutYAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let xAnchor = x { centerXAnchor.constraint(equalTo: xAnchor, constant: 0).isActive = true }
        if let yAnchor = y { centerYAnchor.constraint(equalTo: yAnchor, constant: 0).isActive = true }
    }

    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let anchor = superview?.centerXAnchor else { return }
        centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let anchor = superview?.centerYAnchor else { return }
        centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
}
