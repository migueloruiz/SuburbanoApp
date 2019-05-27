//
//  UIImageView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?, color: UIColor) {
        self.init()
        self.image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
}
