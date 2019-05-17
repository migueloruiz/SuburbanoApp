//
//  CircularButtonStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/16/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol CircularButtonStyle {
    var tintColor: UIColor { get }
    var backgroundColor: UIColor { get }
}

enum CircularButtonStyles {
    case primary
    case secondary
    case gray

    var style: CircularButtonStyle {
        switch self {
        case .primary: return  PrimaryCircularButtonStyle()
        case .secondary: return  SecondaryCircularButtonStyle()
        case .gray: return  GrayCircularButtonStyle()
        }
    }
}

private struct PrimaryCircularButtonStyle: CircularButtonStyle {
    let tintColor = Theme.Pallete.white
    let backgroundColor = Theme.Pallete.softRed
}

private struct SecondaryCircularButtonStyle: CircularButtonStyle {
    let tintColor = Theme.Pallete.white
    let backgroundColor = Theme.Pallete.blue
}

private struct GrayCircularButtonStyle: CircularButtonStyle {
    let tintColor = Theme.Pallete.white
    let backgroundColor = Theme.Pallete.softGray
}
