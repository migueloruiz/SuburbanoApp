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
    private let titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.PopupTitle)
    private let backButton = UIFactory.createButton(withTheme: UIThemes.Button.SecondayButton)
    private let disclaimerView = PromptView()
    private let bottonsContainer = UIStackView.with(axis: .vertical,
                                                    distribution: .fill,
                                                    spacing: Theme.Offset.normal)
    
    var inTransition: UIViewControllerAnimatedTransitioning? { return StationDetailTransitionIn() }
    var outTransition: UIViewControllerAnimatedTransitioning? { return StationDetailTransitionOut() }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(presenter: DirectionsDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = Theme.Pallete.darkBackground
        backButton.set(title: "Cancelar")
        backButton.addTarget(self, action: #selector(DirectionsDetailViewController.close), for: .touchUpInside)
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        titleLabel.font = titleLabel.font.withSize(28)
        titleLabel.text = "¿Como llego a la estacion \(presenter.stationName.firstUppercased)?"
        titleLabel.addDropShadow()
        
        for app in presenter.availableAppsRedirectios {
            let itemView = DirectionActionView(app: app)
            bottonsContainer.addArrangedSubview(itemView)
        }
    }
    
    private func configureLayout() {
        view.addSubViews([titleLabel, backButton, bottonsContainer])
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: Theme.Offset.large, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        
        backButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
        
//        if let disclaimer = presenter.disclaimers.first, !disclaimer.isEmpty {
//            view.addSubViews([disclaimerView])
//            disclaimerView.configure(disclaimer: disclaimer)
//
//            disclaimerView.anchor(left: view.leftAnchor, bottom: backButton.topAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
//
//            bottonsContainer.anchor(left: view.leftAnchor, bottom: disclaimerView.topAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
//
//        } else {
            bottonsContainer.anchor(left: view.leftAnchor, bottom: backButton.topAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
//        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
