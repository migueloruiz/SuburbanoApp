//
//  NSLayoutAnchor.swift
//  suburbano
//
//  Created by Miguel Ruiz on 14/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum ConstraintIdentifire: String {
    case top
    case left
    case bottom
    case right
    case width
    case height
}

extension NSLayoutConstraint {
    func hasIdentifier(_ constraintIdentifire: ConstraintIdentifire) -> Bool {
        guard let constraintId = ConstraintIdentifire(rawValue: self.identifier ?? ""),
            constraintId.rawValue == constraintIdentifire.rawValue else { return false }
        return true
    }
}

extension NSLayoutDimension {
    func constraint(equalToConstant constant: CGFloat, identifier: ConstraintIdentifire) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: constant)
        constraint.identifier = identifier.rawValue
        return constraint
    }
    
    func constraint(equalTo dimesion: NSLayoutDimension, multiplier: CGFloat = 1, identifier: ConstraintIdentifire) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: dimesion, multiplier: multiplier)
        constraint.identifier = identifier.rawValue
        return constraint
    }
}

extension NSLayoutXAxisAnchor {
    func constraint(equalTo anchor: NSLayoutXAxisAnchor, constant c: CGFloat, identifier: ConstraintIdentifire) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: c)
        constraint.identifier = identifier.rawValue
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    func constraint(equalTo anchor: NSLayoutYAxisAnchor, constant c: CGFloat, identifier: ConstraintIdentifire) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: c)
        constraint.identifier = identifier.rawValue
        return constraint
    }
}
