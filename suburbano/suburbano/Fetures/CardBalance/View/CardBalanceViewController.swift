//
//  CardBalanceViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 19/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class CardBalanceViewController: UIViewController {
    
    struct Constants {
        static let excamationIconHeigth: CGFloat = Theme.IconSize.small
    }
    
    private(set) lazy var containerView = UIView()
    private lazy var titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.CardBalanceNavTitle)
    private lazy var cardBalanceIconView = IconPickerView()
    private let cardNumberDisclaimerLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let excamationIcon = UIImageView()
    private let useDisclaimerLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let addButton = UIFactory.createButton(withTheme: UIThemes.Button.PrimaryButton)
    private let backButton = UIFactory.createButton(withTheme: UIThemes.Button.SecondayButton)
    private var bottomConstraint: NSLayoutConstraint?
    
    
    private lazy var cardNumberInput: CustomeTextField = {
        let input = CustomeTextField()
        input.title = "No. de trajeta"
        input.placeholder = "XXXXXXXXX"
        return input
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = cardNumberInput.becomeFirstResponder()
    }
    
    private func configureUI() {
        view.backgroundColor = Theme.Pallete.darkBackground
        
        containerView.backgroundColor = .white
        containerView.roundCorners(withRadius: Theme.Rounded.controller)
        
        let keyboardDisssmissGesture = UITapGestureRecognizer(target: self, action: #selector(CardBalanceViewController.dismmisKeyboard))
        containerView.addGestureRecognizer(keyboardDisssmissGesture)
        
        titleLabel.text = "Agrega tu tarjeta"
        cardNumberDisclaimerLabel.text = "Pudes encontrar el numero al frente de tu tarjeta en la parte inferior"
        cardNumberDisclaimerLabel.backgroundColor = .clear
        cardNumberDisclaimerLabel.textAlignment = .left
        excamationIcon.image = #imageLiteral(resourceName: "exclamation")
        excamationIcon.tintColor = Theme.Pallete.softGray
        useDisclaimerLabel.text = "El saldo de recargas a tu tarjeta, podrá verse reflejado en 15 min aproximadamente."
        useDisclaimerLabel.backgroundColor = .clear
        useDisclaimerLabel.textAlignment = .left
        
        backButton.set(title: "Cancelar")
        backButton.addTarget(self, action: #selector(CardBalanceViewController.close), for: .touchUpInside)
        addButton.set(title: "Agregar")
        addButton.addTarget(self, action: #selector(CardBalanceViewController.close), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CardBalanceViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CardBalanceViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func configureLayout() {
        view.addSubViews([containerView])
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)

        let buttonsContainer = UIStackView.with(distribution: .fillEqually, spacing: Theme.Offset.small)
        
        containerView.addSubViews([titleLabel, cardBalanceIconView, cardNumberInput, cardNumberDisclaimerLabel, excamationIcon, useDisclaimerLabel, buttonsContainer])
        
        titleLabel.anchor(top: containerView.topAnchor, topConstant: Theme.Offset.normal)
        titleLabel.anchorCenterXToSuperview()
        
        cardBalanceIconView.anchor(top: titleLabel.bottomAnchor, topConstant: Theme.Offset.large)
        cardBalanceIconView.anchor( left: containerView.leftAnchor, leftConstant: Theme.Offset.large)
        
        cardNumberInput.anchor(left: cardBalanceIconView.rightAnchor, right: containerView.rightAnchor, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        cardNumberInput.center(x: nil, y: cardBalanceIconView.centerYAnchor)
        
        cardNumberDisclaimerLabel.anchor(top: cardBalanceIconView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        
        excamationIcon.anchor(left: containerView.leftAnchor, leftConstant: Theme.Offset.large)
        excamationIcon.center(x: nil, y: useDisclaimerLabel.centerYAnchor)
        excamationIcon.anchorSquare(size: Constants.excamationIconHeigth)
    useDisclaimerLabel.topAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(cardNumberDisclaimerLabel.bottomAnchor, multiplier: Theme.Offset.small).isActive = true
        useDisclaimerLabel.anchor(left: excamationIcon.rightAnchor, right: containerView.rightAnchor, leftConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
        
        buttonsContainer.anchor(top: useDisclaimerLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        let constraints = buttonsContainer.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: Theme.Offset.small)
        bottomConstraint = constraints.first
        
        buttonsContainer.addArranged(subViews: [addButton, backButton])
    }
    
    @objc func close() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboard = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        bottomConstraint?.constant = -(keyboard.cgRectValue.height + Theme.Offset.small)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = -Theme.Offset.small
        view.layoutIfNeeded()
    }
    
    @objc func dismmisKeyboard() {
        view.endEditing(true)
    }
}
