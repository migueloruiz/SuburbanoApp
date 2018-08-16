//
//  UIButton.swift
//  suburbano
//
//  Created by Miguel Ruiz on 15/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension UIButton {
    
    func set(title: String) {
        setTitle(title, for: .normal)
        setTitle(title, for: .focused)
    }

}
