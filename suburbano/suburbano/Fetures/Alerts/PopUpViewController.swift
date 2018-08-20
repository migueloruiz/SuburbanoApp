//
//  PopUpViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 15/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum AlertContext {
    case error(error: ErrorResponse)
}

class PopUpViewController: UIViewController {
    
    struct Constants {
        static let imageSize: CGFloat = Theme.IconSize.extraLarge
    }
    
    private let context: AlertContext
    private lazy var OKButton: UIButton = UIFactory.createButton(withTheme: UIThemes.Button.PrimaryButton)
    private lazy var secondariButton: UIButton = UIFactory.createButton(withTheme: UIThemes.Button.SecondayButton)
    private lazy var titleLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.PopupTitle)
    private lazy var descripcionLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.PopupBody)
    private var imageView = UIImageView()
    private lazy var buttonsContainer: UIStackView = UIStackView.with(distribution: .fillEqually, spacing: Theme.Offset.small)
    private(set) lazy var messageContiner: UIView = UIFactory.createCardView()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(context: AlertContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        configureLayout()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopUpViewController.close)))

        OKButton.set(title: "OK")
        OKButton.addTarget(self, action: #selector(PopUpViewController.close), for: .touchUpInside)
        secondariButton.addTarget(self, action: #selector(PopUpViewController.openSetting), for: .touchUpInside)
    
        switch context {
        case .error(let errorDatil):
            titleLabel.text = errorDatil.header
            descripcionLabel.text = errorDatil.body
            imageView.image = #imageLiteral(resourceName: "sad")
            secondariButton.set(title: "Ir a Ajustes")
            buttonsContainer.addArrangedSubview(secondariButton)
        }
    }
    
    private func configureLayout() {
        view.addSubview(messageContiner)
        
        messageContiner.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        messageContiner.addSubViews([imageView, titleLabel, descripcionLabel, buttonsContainer])
        
        imageView.anchor(top: messageContiner.topAnchor, topConstant: Theme.Offset.large)
        imageView.anchorSquare(size: Constants.imageSize)
        imageView.center(x: messageContiner.centerXAnchor, y: nil)
        titleLabel.anchor(top: imageView.bottomAnchor, left: messageContiner.leftAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.large, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        descripcionLabel.anchor(top: titleLabel.bottomAnchor, left: messageContiner.leftAnchor, bottom: buttonsContainer.topAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        
        buttonsContainer.anchor(left: titleLabel.leftAnchor, bottom: messageContiner.bottomAnchor, right: titleLabel.rightAnchor, bottomConstant: Theme.Offset.large)
        buttonsContainer.addArrangedSubview(OKButton)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openSetting() {
        // TODO: No llamar app delegate usar Notificaciones
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!),
            UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
        }
        close()
    }
}
