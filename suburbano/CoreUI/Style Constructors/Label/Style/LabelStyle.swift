//
//  LabelStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol ColorLabelStyle {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
}

enum ColorLabelStyles {
    case primary
    case secondary
    case detail
    case clear
    case darkClear
    case redClear

    var style: ColorLabelStyle {
        switch self {
        case .primary: return PrimaryLabelStyle()
        case .secondary: return SecondaryLabelStyle()
        case .detail: return DetailLabelStyle()
        case .clear: return ClearLabelStyle()
        case .darkClear: return DarkClearLabelStyle()
        case .redClear: return RedClearLabelStyle()
        }
    }
}

private struct PrimaryLabelStyle: ColorLabelStyle {
    let backgroundColor = Theme.Pallete.white
    let textColor = Theme.Pallete.darkGray
}

private struct SecondaryLabelStyle: ColorLabelStyle {
    let backgroundColor = Theme.Pallete.white
    let textColor = Theme.Pallete.softRed
}

private struct DetailLabelStyle: ColorLabelStyle {
    let backgroundColor = Theme.Pallete.white
    let textColor = Theme.Pallete.softGray
}

private struct ClearLabelStyle: ColorLabelStyle {
    let backgroundColor = UIColor.clear
    let textColor = Theme.Pallete.white
}

private struct DarkClearLabelStyle: ColorLabelStyle {
    let backgroundColor = UIColor.clear
    let textColor = Theme.Pallete.darkGray
}

private struct RedClearLabelStyle: ColorLabelStyle {
    let backgroundColor = UIColor.clear
    let textColor = Theme.Pallete.softRed
}
