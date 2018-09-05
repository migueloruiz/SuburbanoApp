//
//  UIColor.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc class func fromRgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    @nonobjc class func from(hex value: Int, alpha: CGFloat = 1.0) -> UIColor {
        let redContext = (value >> 16) & 0xFF
        let greenContext = (value >> 8) & 0xFF
        let blueContext = value & 0xFF
        
        return UIColor(
            red: CGFloat(redContext) / 255.0,
            green: CGFloat(greenContext) / 255.0,
            blue: CGFloat(blueContext) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
