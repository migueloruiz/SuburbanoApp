//
//  CardBalanceViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 19/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class CardBalanceViewController: UIViewController, PresentableView {

    struct Constants {
        static let excamationIconHeigth: CGFloat = Theme.IconSize.small
    }

    private let presenter: CardBalancePresenter
    private var card: Card?

    private let loadingView = LoadingView()
    private let primaryButton = UIFactory.createButton(withTheme: UIThemes.Button.PrimaryButton)
    private let secondaryButton = UIFactory.createButton(withTheme: UIThemes.Button.SecondayButton)

    private(set) lazy var containerView = UIFactory.createContainerView()
    private lazy var formContinerView = UIView()
    private lazy var titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.CardBalanceNavTitle)
    private lazy var cardBalanceIconView = IconPickerView()
    private lazy var useDisclaimerView = PromptView()
    private lazy var cardNumberInput = CustomeTextField()
    private lazy var balanceLabel = UIFactory.createLable(withTheme: UIThemes.Label.CardPickerTitle)
    private lazy var dateLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private var bottomButtonsConstraint: NSLayoutConstraint?

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    var inTransition: UIViewControllerAnimatedTransitioning? { return CardBalanceTransitionIn() }
    var outTransition: UIViewControllerAnimatedTransitioning? { return CardBalanceTransitionOut() }

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
        focusFirstFieldIfNeeded()
    }

    private func focusFirstFieldIfNeeded() {
        guard card == nil else { return }
         _ = cardBalanceIconView.becomeFirstResponder()
    }

    // MARK: configureUI

    private func configureUI() {
        view.backgroundColor = Theme.Pallete.darkBackground

        cardNumberInput.title = "No. de trajeta"
        cardNumberInput.placeholder = "XXXXXXXXX"
        cardNumberInput.disclaimer = "Pudes encontrar el numero al frente de tu tarjeta en la parte inferior"
        useDisclaimerView.configure(disclaimer: "Los cambios en tu saldo, podrá verse reflejado en 15 min aprox.")

        setUIwithCard()
        loadingView.configure()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CardBalanceViewController.closeKeyboard))
        formContinerView.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(CardBalanceViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CardBalanceViewController.keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CardBalanceViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setUIwithCard() {
        configureButtons()

        if let card = card {
            titleLabel.text = "Detalle Tarjeta"
            cardNumberInput.text = card.id
            balanceLabel.text = card.balance
            dateLabel.text = card.displayDate
            cardBalanceIconView.set(icon: .custome(iconCode: card.icon, color: card.displayColor))
            cardNumberInput.isUserInteractionEnabled = false
            cardBalanceIconView.isUserInteractionEnabled = false
        } else {
            titleLabel.text = "Agrega tu tarjeta"
            cardNumberInput.isUserInteractionEnabled = true
            cardBalanceIconView.isUserInteractionEnabled = true
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
        let constraints = formContinerView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: Theme.Offset.small)
        bottomButtonsConstraint = constraints.first

        formContinerView.addSubViews([cardBalanceIconView, cardNumberInput, useDisclaimerView, buttonsContainer])

        if card == nil {
            cardBalanceIconView.anchor(top: formContinerView.topAnchor)
            cardBalanceIconView.anchorCenterXToSuperview()
        } else {
            cardBalanceIconView.anchor(top: formContinerView.topAnchor, left: formContinerView.leftAnchor)
            formContinerView.addSubViews([balanceLabel, dateLabel])
            balanceLabel.anchor(top: cardBalanceIconView.topAnchor, right: formContinerView.rightAnchor, topConstant: Theme.Offset.small)
            dateLabel.anchor(top: balanceLabel.bottomAnchor, right: formContinerView.rightAnchor, topConstant: Theme.Offset.normal)
        }

        cardNumberInput.anchor(top: cardBalanceIconView.bottomAnchor, left: formContinerView.leftAnchor, right: formContinerView.rightAnchor, topConstant: Theme.Offset.large)

        let topConstraint = useDisclaimerView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: cardNumberInput.bottomAnchor, multiplier: 1)
        topConstraint.isActive = true
        topConstraint.constant = Theme.Offset.normal
        useDisclaimerView.anchor(left: formContinerView.leftAnchor, right: formContinerView.rightAnchor)

        buttonsContainer.anchor(top: useDisclaimerView.bottomAnchor, left: formContinerView.leftAnchor, bottom: formContinerView.bottomAnchor, right: formContinerView.rightAnchor, topConstant: disclaimerOffset)

        buttonsContainer.addArranged(subViews: [primaryButton, secondaryButton])
    }
}

// MARK: Actions

extension CardBalanceViewController {

    @objc func closeKeyboard() {
        view.endEditing(true)
    }

    @objc func close() {
        closeKeyboard()
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
        guard let keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        bottomButtonsConstraint?.constant = -(keyboard.cgRectValue.height + Theme.Offset.small)
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

    func addCardFailure(error: InlineError) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadingView.dismiss(hiddingView: strongSelf.formContinerView) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cardNumberInput.shake()
                strongSelf.cardNumberInput.error = error
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
        guard presented is PopUpViewController else { return nil }
        return PopUpTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
