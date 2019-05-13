//
//  UIDevice.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension UIDevice {

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var isSmallPhone: Bool {
        return 568.0 >= UIScreen.main.bounds.height
    }

    static var hasNotch: Bool {
        var hasNotch = false
        guard let window = AppDelegate.shared?.window else { return false }
        if #available(iOS 12.0, *) {
            hasNotch = window.safeAreaInsets.top != AppConstants.Device.normalStatusbarHeigth
        } else if #available(iOS 11.0, *) {
            hasNotch = window.safeAreaInsets != UIEdgeInsets.zero
        }
        return hasNotch
    }
}