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
        let imageInset = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        items?.forEach({ item in
            item.imageInsets = imageInset
        })
    }
}
