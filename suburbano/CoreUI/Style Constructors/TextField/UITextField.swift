//
//  UITextField.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/21/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

class TextField: UITextField {

    convenience init(style styleType: FieldStyles) {
        self.init()
        let style = styleType.style
        textColor = style.textColor
        tintColor = style.tintColor
        backgroundColor = style.backgroundColor
        font = style.font.getScaledFont()
        keyboardType = style.keyboardType
        autocorrectionType = style.autocorrectionType
        allowedActions = ResponderActions.defaultActions
    }

    var allowedActions: [ResponderActions] = []

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard !allowedActions.isEmpty else { return false }
        return allowedActions.map { $0.selector }.contains(action)
    }
}

enum ResponderActions {
    case cut, copy, paste, select, selectAll, delete
    case makeTextWritingDirectionLeftToRight, makeTextWritingDirectionRightToLeft
    case toggleBoldface, toggleItalics, toggleUnderline
    case increaseSize, decreaseSize

    var selector: Selector {
        switch self {
        case .cut:
            return #selector(UIResponderStandardEditActions.cut)
        case .copy:
            return #selector(UIResponderStandardEditActions.copy)
        case .paste:
            return #selector(UIResponderStandardEditActions.paste)
        case .select:
            return #selector(UIResponderStandardEditActions.select)
        case .selectAll:
            return #selector(UIResponderStandardEditActions.selectAll)
        case .delete:
            return #selector(UIResponderStandardEditActions.delete)
        case .makeTextWritingDirectionLeftToRight:
            return #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight)
        case .makeTextWritingDirectionRightToLeft:
            return #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft)
        case .toggleBoldface:
            return #selector(UIResponderStandardEditActions.toggleBoldface)
        case .toggleItalics:
            return #selector(UIResponderStandardEditActions.toggleItalics)
        case .toggleUnderline:
            return #selector(UIResponderStandardEditActions.toggleUnderline)
        case .increaseSize:
            return #selector(UIResponderStandardEditActions.increaseSize)
        case .decreaseSize:
            return #selector(UIResponderStandardEditActions.decreaseSize)
        }
    }

    static var defaultActions: [ResponderActions] { return [.cut, .copy, .paste, .select, .selectAll, .delete] }
}
