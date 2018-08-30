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
    private let presenter: CardBalancePresenter
    private var card: Card?
    
    private let loadingView = LoadingView()
    private let cardNumberDisclaimerLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let useDisclaimerLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let primaryButton = UIFactory.createButton(withTheme: UIThemes.Button.PrimaryButton)
    private let secondaryButton = UIFactory.createButton(withTheme: UIThemes.Button.SecondayButton)
    
    private(set) lazy var containerView = UIView()
    private lazy var formContinerView = UIView()
    private lazy var titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.CardBalanceNavTitle)
    private lazy var cardBalanceIconView = IconPickerView()
    private lazy var excamationIcon = UIFactory.createImageView(image: #imageLiteral(resourceName: "exclamation"), color: Theme.Pallete.softGray)
    private lazy var cardNumberInput = CustomeTextField()
    private var bottomButtonsConstraint: NSLayoutConstraint?
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(presenter: CardBalancePresenter, card: Card? = nil) {
        self.presenter = presenter
        self.card = card
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
        if card == nil {
            _ = cardBalanceIconView.becomeFirstResponder()
        }
    }
    
    // MARK: configureUI
    
    private func configureUI() {
        view.backgroundColor = Theme.Pallete.darkBackground
        containerView.backgroundColor = .white
        containerView.roundCorners(withRadius: Theme.Rounded.controller)
        
        titleLabel.text = "Agrega tu tarjeta"
        cardNumberInput.title = "No. de trajeta"
        cardNumberInput.placeholder = "XXXXXXXXX"
        cardNumberDisclaimerLabel.text = "Pudes encontrar el numero al frente de tu tarjeta en la parte inferior"
        useDisclaimerLabel.text = "El saldo de recargas a tu tarjeta, podrá verse reflejado en 15 min aproximadamente."
        
        setUIwithCard()
        loadingView.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CardBalanceViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CardBalanceViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func setUIwithCard() {
        configureButtons()
        
        if card == nil {
            cardNumberInput.isUserInteractionEnabled = true
            cardBalanceIconView.isUserInteractionEnabled = true
        } else {
            cardNumberInput.isUserInteractionEnabled = false
            cardBalanceIconView.isUserInteractionEnabled = false
        }
    }
    
    private func configureButtons() {
        primaryButton.removeTarget(nil, action: nil, for: .allEvents)
        secondaryButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if card == nil {
            primaryButton.set(title: "Agregar")
            primaryButton.addTarget(self, action: #selector(CardBalanceViewController.validateInformation), for: .touchUpInside)
            secondaryButton.set(title: "Cancelar")
            secondaryButton.addTarget(self, action: #selector(CardBalanceViewController.close), for: .touchUpInside)
        } else {
            primaryButton.set(title: "Volver")
            primaryButton.addTarget(self, action: #selector(CardBalanceViewController.close), for: .touchUpInside)
            secondaryButton.set(title: "Eliminar")
            secondaryButton.addTarget(self, action: #selector(CardBalanceViewController.delateCard), for: .touchUpInside)
        }
    }
    
    // MARK: ConfigureLayout
    
    private func configureLayout() {
        let verticalOffset = Utils.isSmallPhone ? Theme.Offset.normal : Theme.Offset.extralarge
        let disclaimerOffset = Utils.isSmallPhone ? Theme.Offset.normal : Theme.Offset.extralarge
        
        view.addSubViews([loadingView, containerView])
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)
        loadingView.fillSuperview()
        
        let buttonsContainer = UIStackView.with(distribution: .fillEqually, spacing: Theme.Offset.small)

        containerView.addSubViews([titleLabel, formContinerView])
        
        titleLabel.anchor(top: containerView.topAnchor, topConstant: Theme.Offset.normal)
        titleLabel.anchorSize(height: 30)
        titleLabel.anchorCenterXToSuperview()
        
        formContinerView.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, topConstant: verticalOffset, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        let constraints = formContinerView.anchor(bottom: view.bottomAnchor, bottomConstant: Theme.Offset.normal)
        bottomButtonsConstraint = constraints.first
        
        formContinerView.addSubViews([cardBalanceIconView, cardNumberInput, cardNumberDisclaimerLabel, excamationIcon, useDisclaimerLabel, buttonsContainer])
 
        cardBalanceIconView.anchor(top: formContinerView.topAnchor)
        cardBalanceIconView.anchorCenterXToSuperview()
        
        cardNumberInput.anchor(top: cardBalanceIconView.bottomAnchor, left: formContinerView.leftAnchor, right: formContinerView.rightAnchor, topConstant: Theme.Offset.large)
        
        cardNumberDisclaimerLabel.anchor(top: cardNumberInput.bottomAnchor, left: formContinerView.leftAnchor, right: formContinerView.rightAnchor, topConstant: Theme.Offset.normal)
        
        excamationIcon.anchor(left: formContinerView.leftAnchor)
        excamationIcon.center(x: nil, y: useDisclaimerLabel.centerYAnchor)
        excamationIcon.anchorSquare(size: Constants.excamationIconHeigth)
        
        let topConstraint = useDisclaimerLabel.topAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(cardNumberDisclaimerLabel.bottomAnchor, multiplier: 1)
        topConstraint.isActive = true
        topConstraint.constant = Theme.Offset.normal
        useDisclaimerLabel.anchor(left: excamationIcon.rightAnchor, right: formContinerView.rightAnchor, leftConstant: Theme.Offset.normal)
        
        buttonsContainer.anchor(top: useDisclaimerLabel.bottomAnchor, left: formContinerView.leftAnchor, bottom: formContinerView.bottomAnchor ,right: formContinerView.rightAnchor, topConstant: disclaimerOffset)
        
        buttonsContainer.addArranged(subViews: [primaryButton, secondaryButton])
    }
}

// MARK: Actions

extension CardBalanceViewController {
    @objc func close() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func validateInformation() {
        presenter.addCard(withIcon: cardBalanceIconView.icon, number: cardNumberInput.text)
    }
    
    @objc func delateCard() {
        let controller = PopUpViewController(context: .confirmDelete)
        controller.transitioningDelegate = self
        controller.didTapSecondary = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self, let card = strongSelf.card else { return }
                strongSelf.presenter.deleteCard(withId: card.id)
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboard = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        bottomButtonsConstraint?.constant = -(keyboard.cgRectValue.height + Theme.Offset.normal)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomButtonsConstraint?.constant = -Theme.Offset.small
        view.layoutIfNeeded()
    }
}

// MARK: CardBalanceViewDelegate

extension CardBalanceViewController: CardBalanceViewDelegate {
    func showAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadingView.show(hiddingView: strongSelf.formContinerView)
        }
    }
    
    func addCardSuccess(card: Card) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadingView.dismiss(hiddingView: strongSelf.formContinerView) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.close()
            }
        }
    }
    
    func addCardFailure(error: ErrorResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadingView.dismiss(hiddingView: strongSelf.formContinerView) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cardNumberInput.shake()
                strongSelf.cardNumberDisclaimerLabel.text = error.body
                strongSelf.cardNumberDisclaimerLabel.textColor = .red // TODO pick red error
                _ = strongSelf.cardNumberInput.becomeFirstResponder()
            }
        }
    }
    
    func setInvalid(form: CardBalanceForm) {
        switch form {
        case .icon:
            _ = cardBalanceIconView.becomeFirstResponder()
            cardBalanceIconView.shake()
        case .number:
            _ = cardNumberInput.becomeFirstResponder()
            cardNumberInput.shake()
        }
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension CardBalanceViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = presented as? PopUpViewController else { return nil }
        return PopUpTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
