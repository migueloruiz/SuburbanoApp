//
//  DirectionsDetailViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DirectionsDetailViewController: UIViewController, PresentableView {

    private let presenter: DirectionsDetailPresenter

    let titleLabel = UILabel(fontStyle: .largeTitle, alignment: .center, line: .multiline, color: .clear)
    let containerView = UIView()

    private let backButton = UIButton(style: .secondary)
    private let disclaimerView = PromptView(labelTheme: UIThemes.Label.DirectionsDisclainer)
    private let bottonsContainer = UIStackView.with(axis: .vertical,
                                                    distribution: .fill,
                                                    spacing: Theme.Offset.normal)

    var inTransition: UIViewControllerAnimatedTransitioning? { return DirectionDetailsTransitionIn() }
    var outTransition: UIViewControllerAnimatedTransitioning? { return DirectionDetailsTransitionOut() }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(presenter: DirectionsDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        configureLayout()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = Theme.Pallete.darkBackground
        view.isUserInteractionEnabled = true
        containerView.isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: self, action: #selector(DirectionsDetailViewController.close))
        view.addGestureRecognizer(gesture)
        backButton.set(title: "Cancelar") // Localize
        backButton.addTarget(self, action: #selector(DirectionsDetailViewController.close), for: .touchUpInside)
        backButton.isUserInteractionEnabled = true

        titleLabel.text = "¿Como llego a la estacion \(presenter.stationName.firstUppercased)?" // Localize

        for app in presenter.availableApps {
            let itemView = DirectionActionView(app: app, clousure: { [weak self] app in
                self?.presenter.openDirections(app: app)
            })
            bottonsContainer.addArrangedSubview(itemView)
        }
    }

    private func configureLayout() {
        view.addSubViews([titleLabel, containerView])
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: Theme.Offset.large, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)

        containerView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)

        containerView.addSubViews([backButton, bottonsContainer])

        backButton.anchor(left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)

        if let disclaimer = presenter.disclaimer, !disclaimer.isEmpty {
            containerView.addSubViews([disclaimerView])
            disclaimerView.configure(disclaimer: disclaimer)

            disclaimerView.anchor(left: containerView.leftAnchor, bottom: backButton.topAnchor, right: containerView.rightAnchor, bottomConstant: Theme.Offset.large)

            bottonsContainer.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: disclaimerView.topAnchor, right: containerView.rightAnchor, bottomConstant: Theme.Offset.large)

        } else {
            bottonsContainer.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: backButton.topAnchor, right: containerView.rightAnchor, bottomConstant: Theme.Offset.large)
        }
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
