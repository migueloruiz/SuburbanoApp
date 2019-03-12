//
//  PopUpViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 15/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    struct Constants {
        static let imageSize: CGFloat = Theme.IconSize.extraLarge
        static let secondaryTag = 2
    }

    private let context: AlertContext
    private var imageView = UIImageView()
    private lazy var primaryButton: UIButton = UIFactory.createButton(withTheme: UIThemes.Button.PrimaryButton)
    private lazy var secondaryButton: UIButton = UIFactory.createButton(withTheme: UIThemes.Button.SecondayButton)
    private lazy var titleLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.PopupTitle)
    private lazy var descripcionLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.PopupBody)
    private lazy var buttonsContainer: UIStackView = UIStackView.with(distribution: .fillEqually, spacing: Theme.Offset.small)
    private(set) lazy var messageContiner: UIView = UIFactory.createCardView()

    var didTapClose: (() -> Void)?
    var didTapSecondary: (() -> Void)?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(context: AlertContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func configureUI() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopUpViewController.didTapAction(_:))))

        titleLabel.text = context.title
        descripcionLabel.text = context.disclaimer
        imageView.image = context.image
        imageView.contentMode = .scaleAspectFit

        primaryButton.set(title: context.primaryButton)
        primaryButton.addTarget(self, action: #selector(PopUpViewController.didTapAction(_:)), for: .touchUpInside)

        guard let secondaryTitle = context.secondaryButton else { return }
        secondaryButton.set(title: secondaryTitle)
        secondaryButton.tag = Constants.secondaryTag
        buttonsContainer.addArrangedSubview(secondaryButton)
        secondaryButton.addTarget(self, action: #selector(PopUpViewController.didTapAction(_:)), for: .touchUpInside)
    }

    private func configureLayout() {
        view.addSubview(messageContiner)

        messageContiner.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        messageContiner.addSubViews([imageView, titleLabel, descripcionLabel, buttonsContainer])

        imageView.anchor(top: messageContiner.topAnchor, topConstant: Theme.Offset.extralarge)
        imageView.fillHorizontalSuperview()
        imageView.anchorSize(height: Constants.imageSize)
        imageView.center(x: messageContiner.centerXAnchor, y: nil)
        titleLabel.anchor(top: imageView.bottomAnchor, left: messageContiner.leftAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.extralarge, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        descripcionLabel.anchor(top: titleLabel.bottomAnchor, left: messageContiner.leftAnchor, bottom: buttonsContainer.topAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)

        buttonsContainer.anchor(left: titleLabel.leftAnchor, bottom: messageContiner.bottomAnchor, right: titleLabel.rightAnchor, bottomConstant: Theme.Offset.large)
        buttonsContainer.addArrangedSubview(primaryButton)
    }

    @objc func didTapAction(_ sender: UIView) {
        sender.tag == Constants.secondaryTag ? didTapSecondary?() : didTapClose?()
        dismiss(animated: true, completion: nil)
    }
}
