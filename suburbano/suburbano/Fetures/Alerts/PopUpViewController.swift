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
    
    private let context: AlertContext
    private lazy var OKButton: UIButton = UIFactory.createButton(withTitle: "OK", theme: UIThemes.Button.OKPopupButton)
    private lazy var secondariButton: UIButton = UIFactory.createButton(withTitle: "", theme: UIThemes.Button.OKPopupButton)
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

        OKButton.layer.borderWidth = 2
        OKButton.layer.borderColor = Theme.Pallete.softGray.cgColor
        OKButton.layer.cornerRadius = 15
        OKButton.addTarget(self, action: #selector(PopUpViewController.close), for: UIControlEvents.touchUpInside)
        
        secondariButton.layer.borderWidth = 2
        secondariButton.layer.borderColor = Theme.Pallete.darkGray.cgColor
        secondariButton.layer.cornerRadius = 15
        secondariButton.setTitleColor(Theme.Pallete.darkGray, for: .normal)
        secondariButton.titleLabel?.textColor = Theme.Pallete.darkGray
        secondariButton.addTarget(self, action: #selector(PopUpViewController.openSetting), for: UIControlEvents.touchUpInside)
    
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
        
        imageView.anchor(top: messageContiner.topAnchor, topConstant: Theme.Offset.large, widthConstant: 100, heightConstant: 100)
        imageView.center(x: messageContiner.centerXAnchor, y: nil)
        titleLabel.anchor(top: imageView.bottomAnchor, left: messageContiner.leftAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.large, leftConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        descripcionLabel.anchor(top: titleLabel.bottomAnchor, left: messageContiner.leftAnchor, bottom: buttonsContainer.topAnchor, right: messageContiner.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
        
        buttonsContainer.anchor(left: titleLabel.leftAnchor, bottom: messageContiner.bottomAnchor, right: titleLabel.rightAnchor, bottomConstant: Theme.Offset.large)
        buttonsContainer.addArrangedSubview(OKButton)
        OKButton.anchor(heightConstant: 30)
        secondariButton.anchor(heightConstant: 30)
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
