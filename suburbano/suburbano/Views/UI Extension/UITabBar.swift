//
//  UITabBar.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension UITabBar {
    func removeTitles() {
        let imageInset = UIEdgeInsetsMake(7, 0, -7, 0)
        items?.forEach({ item in
            item.imageInsets = imageInset
        })
    }
}
