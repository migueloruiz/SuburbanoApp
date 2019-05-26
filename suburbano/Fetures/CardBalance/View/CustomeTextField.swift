//
//  CustomeInputView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class CustomeTextField: UIView, Shakable {

    struct Contants {
        static let lineHeigth: CGFloat = Theme.Size.separator
        static let lineDesableColor = Theme.Pallete.softGray
    }

    private let textInput = TextField(style: .text)
    private let titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let disclaimerLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
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

    var autocorrectionType: UITextAutocorrectionType = .no {
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

        set(value) {
             textInput.text = value
        }
    }

    var disclaimer: String {
        get {
            return disclaimerLabel.text ?? ""
        }

        set(value) {
            disclaimerLabel.text = value
            disclaimerLabel.textColor = Theme.Pallete.softGray
        }
    }

    var error: String? {
        get {
            return disclaimerLabel.text ?? ""
        }

        set(value) {
            disclaimerLabel.text = value
            disclaimerLabel.textColor = Theme.Pallete.softRed // Pick Error red
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        addSubViews([titleLabel, textInput, bottomLine, disclaimerLabel])
        textInput.textColor = Theme.Pallete.darkGray
        bottomLine.backgroundColor = Contants.lineDesableColor

        textInput.addTarget(self, action: #selector(CustomeTextField.editingDidBegin), for: .editingDidBegin)
        textInput.addTarget(self, action: #selector(CustomeTextField.endEditingChanged), for: .editingDidEnd)
    }

    private func configureLayout() {
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        textInput.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, topConstant: Theme.Offset.small)
        bottomLine.anchor(top: textInput.bottomAnchor, left: textInput.leftAnchor, right: textInput.rightAnchor, topConstant: Contants.lineHeigth)
        bottomLine.anchorSize(height: Contants.lineHeigth)
        disclaimerLabel.anchor(top: bottomLine.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Theme.Offset.normal)

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
