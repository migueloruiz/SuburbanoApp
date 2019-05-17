//
//  ActionButtonStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/16/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol ActionButtonStyle {
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var font: FontStyle { get }
    var radius: CGFloat? { get }
}

enum ActionButtonStyles {
    case primary
    case secondary

    var style: ActionButtonStyle {
        switch self {
        case .primary: return  PrimaryButtonStyle()
        case .secondary: return  SecondaryButtonStyle()
        }
    }
}

private struct PrimaryButtonStyle: ActionButtonStyle {
    let textColor = Theme.Pallete.white
    let backgroundColor = Theme.Pallete.primaryAction
    let font = FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium)
    let radius: CGFloat? = Theme.Rounded.button
}

private struct SecondaryButtonStyle: ActionButtonStyle {
    let textColor = Theme.Pallete.white
    let backgroundColor = Theme.Pallete.softRed
    let font = FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium)
    let radius: CGFloat? = Theme.Rounded.button
}
