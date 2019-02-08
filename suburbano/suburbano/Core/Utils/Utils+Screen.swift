//
//  Utils+Screen.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension Utils {

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var isSmallPhone: Bool {
        return 568.0 >= UIScreen.main.bounds.height
    }

    static var isIphoneX: Bool {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return false }
        switch UIScreen.main.nativeBounds.height {
        case 2436: return true
        default: return false
        }
    }
}
