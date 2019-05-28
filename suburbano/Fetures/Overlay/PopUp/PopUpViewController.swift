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

    private let alertContext: AlertContext
    private var imageView = UIImageView()
    private lazy var closeButton = UIButton(style: .primary)
    private lazy var actionButton = UIButton(style: .secondary)
    private lazy var titleLabel = UILabel(fontStyle: .primary, alignment: .center, line: .oneLinne, color: .secondary)
    private lazy var descripcionLabel = UILabel(fontStyle: .primary, alignment: .center, line: .multiline, color: .primary)
    private lazy var buttonsContainer: UIStackView = UIStackView.with(distribution: .fillEqually, spacing: Theme.Offset.small)
    private(set) lazy var messageContiner = UIView(style: .card)

    var didTapClose: (() -> Void)?
    var didTapAction: (() -> Void)?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(context: AlertContext) {
        self.alertContext = context
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopUpViewController.close)))

        titleLabel.text = alertContext.title
        descripcionLabel.text = alertContext.disclaimer
        imageView.image = alertContext.image
        imageView.contentMode = .scaleAspectFit

        closeButton.set(title: alertContext.primaryActionText)
        closeButton.addTarget(self, action: #selector(PopUpViewController.close), for: .touchUpInside)

        guard let secondaryTitle = alertContext.secondaryActionText else { return }
        actionButton.set(title: secondaryTitle)
        actionButton.tag = Constants.secondaryTag
        buttonsContainer.addArrangedSubview(actionButton)
        actionButton.addTarget(self, action: #selector(PopUpViewController.didTapAction(_:)), for: .touchUpInside)
    }

    private func configureLayout() {
        view.addSubview(messageContiner)

        messageContiner.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        messageContiner.addSubViews([imageView, titleLabel, descripcionLabel, buttonsContainer])

        imageView.anchor(top: messageContiner.topAnchor, topConstant: Theme.Offset.extralarge)
        imageView.fillHorizontal()
        imageView.anchorSize(height: Constants.imageSize)
        imageView.center(x: messageContiner.centerXAnchor, y: nil)
        titleLabel.anchor(top: imageView.bottomAnchor, left: messageContiner.leftAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.extralarge, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        descripcionLabel.anchor(top: titleLabel.bottomAnchor, left: messageContiner.leftAnchor, bottom: buttonsContainer.topAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)

        buttonsContainer.anchor(left: titleLabel.leftAnchor, bottom: messageContiner.bottomAnchor, right: titleLabel.rightAnchor, bottomConstant: Theme.Offset.large)
        buttonsContainer.addArrangedSubview(closeButton)
    }

    @objc func didTapAction(_ sender: UIView) {
        didTapAction?()
        dismiss(animated: true, completion: nil)
    }

    @objc func close() {
        didTapClose?()
        dismiss(animated: true, completion: nil)
    }
}
