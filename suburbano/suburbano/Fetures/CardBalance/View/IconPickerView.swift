//
//  CardBalanceIconView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum CardBalanceIcon {
    struct Constants {
        static let defaultIcon = "\u{e91b}"
    }
    
    case initial
    case custome(iconCode: String, color: UIColor)
    
    var values: (icon: String, color: Data) {
        switch self {
        case .initial: return (Constants.defaultIcon, NSKeyedArchiver.archivedData(withRootObject: Theme.Pallete.softGray))
        case .custome(let icon, let color): return (icon, NSKeyedArchiver.archivedData(withRootObject: color))
        }
    }
}

class IconPickerView: UIView {
    
    struct Constants {
        static let iconDiameter: CGFloat = Theme.IconSize.large
        static let defaultIcon = "\u{e91b}"
    }
    
    private let field = UIFactory.createTextField(withTheme: UIThemes.Field.IconPickerField)
    
    var icon: CardBalanceIcon {
        guard backgroundColor != Theme.Pallete.softGray && field.text != Constants.defaultIcon else { return .initial }
        return .custome(iconCode: field.text ?? "", color: backgroundColor ?? Theme.Pallete.softRed)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        let inputView = IconInputView()
        inputView.delegate = self
        field.inputView = inputView
        field.textAlignment = .center
        field.addTarget(self, action: #selector(IconPickerView.editingDidBegin), for: .editingDidBegin)
        field.addTarget(self, action: #selector(IconPickerView.endEditingChanged), for: .editingDidEnd)
        clipsToBounds = true
        roundCorners(withRadius: Constants.iconDiameter / 2)
        layer.borderColor = Theme.Pallete.softRed.cgColor
        set(icon: .initial)
    }
    
    private func configureLayout() {
        anchorSquare(size: Constants.iconDiameter)
        addSubview(field)
        field.fillSuperview()
    }
    
    func set(icon: CardBalanceIcon) {
        switch icon {
        case .initial:
            backgroundColor = Theme.Pallete.softGray
            field.text = Constants.defaultIcon
        case .custome(let iconCode, let color):
            field.text = iconCode
            backgroundColor = color
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return field.becomeFirstResponder()
    }
    
    @objc func editingDidBegin() {
        layer.borderWidth = 3
    }
    
    @objc func endEditingChanged() {
        layer.borderWidth = 0
    }
}

extension IconPickerView: IconInputViewDelegate {
    func update(icon: CardBalanceIcon) {
        set(icon: icon)
    }
}
