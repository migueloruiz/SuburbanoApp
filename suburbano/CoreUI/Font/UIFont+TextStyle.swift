//
//  UIFont+TextStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/27/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UIFont.TextStyle {
    var size: CGFloat {
        switch self {
        case .caption2: return 11
        case .caption1: return 12
        case .footnote: return 13
        case .subheadline: return 15
        case .callout: return 16
        case .body: return 17
        case .headline: return 17
        case .title3: return 20
        case .title2: return 22
        case .title1: return 28
        default: return 34 // .largeTitle
        }
    }
}
