//
//  FieldStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/21/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol FieldStyle {
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var font: FontStyle { get }
    var autocorrectionType: UITextAutocorrectionType { get }
    var keyboardType: UIKeyboardType { get }
}

enum FieldStyles {
    case text
    case icon

    var style: FieldStyle {
        switch self {
        case .text: return TextFieldStyle()
        case .icon: return IconFieldStyle()
        }
    }
}

private struct TextFieldStyle: FieldStyle {
    let textColor = Theme.Pallete.darkGray
    let tintColor = Theme.Pallete.softRed
    let backgroundColor = Theme.Pallete.white
    let font = FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium)
    let autocorrectionType: UITextAutocorrectionType = .no
    let keyboardType: UIKeyboardType = .numberPad
}

private struct IconFieldStyle: FieldStyle {
    let textColor = Theme.Pallete.white
    let tintColor: UIColor = .clear
    let backgroundColor: UIColor = .clear
    let font = FontStyle(size: .smallIcon, largeFactor: Theme.FontFactor.large, name: .icons, style: .none)
    let autocorrectionType: UITextAutocorrectionType = .no
    let keyboardType: UIKeyboardType = .numberPad
}
