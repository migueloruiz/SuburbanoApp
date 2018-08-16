//
//  ReusableIdentifier.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol ReusableIdentifier { }

extension ReusableIdentifier where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
