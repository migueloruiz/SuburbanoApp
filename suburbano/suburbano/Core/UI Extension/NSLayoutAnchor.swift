//
//  NSLayoutAnchor.swift
//  suburbano
//
//  Created by Miguel Ruiz on 14/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum ConstraintIdentifire: String {
    case top = "top"
    case left = "left"
    case bottom = "bottom"
    case right = "right"
    case width = "width"
    case height = "height"
}

extension NSLayoutConstraint {
    func hasIdentifier(_ constraintIdentifire: ConstraintIdentifire) -> Bool {
        guard let id = ConstraintIdentifire(rawValue: self.identifier ?? ""),
            id.rawValue == constraintIdentifire.rawValue else { return false }
        return true
    }
}

extension NSLayoutDimension {
    func constraint(equalToConstant constant: CGFloat, identifier: ConstraintIdentifire) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: constant)
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
