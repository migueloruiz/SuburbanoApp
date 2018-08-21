//
//  CustomeInputView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class CustomeInputView: UIView {
    
    struct Contants {
        static let lineHeigth: CGFloat = Theme.Offset.separator
        static let lineDesableColor = Theme.Pallete.softGray
    }
    
    private let textInput = UIFactory.createTextField(withTheme: UIThemes.Field.CardNumberField)
    private let titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let bottomLine = UIView()
    
    var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set(value) {
            titleLabel.text = value
        }
    }
    
    var placeholder: String = "" {
        didSet {
            textInput.placeholder = placeholder
        }
    }
    
    var autocorrectionType: UITextAutocorrectionType = .no  {
        didSet {
            textInput.autocorrectionType = autocorrectionType
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textInput.keyboardType = keyboardType
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            textInput.tintColor = tintColor
        }
    }
    
    var text: String {
        get {
            return textInput.text ?? ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        addSubViews([titleLabel, textInput, bottomLine])
        textInput.textColor = Theme.Pallete.darkGray
        bottomLine.backgroundColor = Contants.lineDesableColor
        
        textInput.addTarget(self, action: #selector(CustomeInputView.editingDidBegin), for: .editingDidBegin)
        textInput.addTarget(self, action: #selector(CustomeInputView.endEditingChanged), for: .editingDidEnd)
    }
    
    private func configureLayout() {
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        textInput.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Theme.Offset.small)
        bottomLine.anchor(top: textInput.bottomAnchor, left: textInput.leftAnchor, right: textInput.rightAnchor, topConstant: Contants.lineHeigth)
        bottomLine.anchorSize(height: Contants.lineHeigth)
    }
    
    override func becomeFirstResponder() -> Bool {
        return textInput.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textInput.resignFirstResponder()
    }
    
    @objc func editingDidBegin() {
        bottomLine.backgroundColor = textInput.tintColor
    }
    
    @objc func endEditingChanged() {
        bottomLine.backgroundColor = Contants.lineDesableColor
    }
}
