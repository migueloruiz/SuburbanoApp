//
//  UIColor.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct RgbComponents {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

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

    @nonobjc class func from(data: Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor ?? Theme.Pallete.darkGray
    }

    @nonobjc class func getGradientColor(from: UIColor, to: UIColor, percentage: CGFloat) -> UIColor {
        guard percentage >= 0 && percentage <= 1,
            let fromComponets = from.rgb,
            let toComponets = to.rgb else { return from }

        let red = fromComponets.red + (CGFloat(toComponets.red - fromComponets.red)  * percentage)
        let green = fromComponets.green + (CGFloat(toComponets.green - fromComponets.green)  * percentage)
        let blue = fromComponets.blue + (CGFloat(toComponets.blue - fromComponets.blue)  * percentage)
        let alpha = fromComponets.alpha + (CGFloat(toComponets.alpha - fromComponets.alpha)  * percentage)

        return UIColor.init(red: red,
                            green: green,
                            blue: blue,
                            alpha: alpha)
    }

    var rgb: RgbComponents? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        guard getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) else { return nil }
        return RgbComponents(red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
    }
}
