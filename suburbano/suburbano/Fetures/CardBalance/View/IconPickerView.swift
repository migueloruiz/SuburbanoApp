//
//  CardBalanceIconView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum CardBalanceIcon {
    case initial
    case custome(iconCode: String, color: UIColor)
}

class IconPickerView: UIView {
    
    struct Constants {
        static let iconDiameter: CGFloat = Theme.IconSize.large
    }
    
    private let field = UIFactory.createTextField(withTheme: UIThemes.Field.IconPickerField)
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(IconPickerView.didTapElement))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        contentMode = .center
        clipsToBounds = true
        roundCorners(withRadius: Constants.iconDiameter / 2)
        tintColor = .white
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
            field.text = "\u{e91b}"
        case .custome(let iconCode, let color):
            field.text = iconCode
            backgroundColor = color
        }
    }
    
    @objc private func didTapElement() {
        becomeFirstResponder()
    }
}


extension IconPickerView: IconInputViewDelegate {
    func update(icon: CardBalanceIcon) {
        set(icon: icon)
    }
}
