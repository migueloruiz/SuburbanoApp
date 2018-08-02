//
//  UIEdgeInsets.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    static func with(vertical: CGFloat, horizoltal: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: vertical, left: horizoltal, bottom: vertical, right: horizoltal)
    }
}
