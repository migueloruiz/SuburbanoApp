//
//  DirectionActionView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 05/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

typealias DirectionsClousure = ((DirectionsApp) -> Void)

class DirectionActionView: UIView {

    struct Constants {
        static let heigth = Theme.IconSize.normal + (Theme.Offset.small * 2)
    }

    private let app: DirectionsApp
    private let clousure: DirectionsClousure
    private let icon = UIImageView()
    private let titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(app: DirectionsApp, clousure: @escaping DirectionsClousure) {
        self.app = app
        self.clousure = clousure
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        roundCorners(withRadius: Constants.heigth / 2)
        addDropShadow()
        icon.image = UIImage(named: app.icon)
        icon.contentMode = .scaleAspectFit
        icon.isUserInteractionEnabled = true
        titleLabel.text = app.title
        titleLabel.isUserInteractionEnabled = true
        backgroundColor = .white
        self.isUserInteractionEnabled = true
        let guesture = UITapGestureRecognizer(target: self, action: #selector(DirectionActionView.selected))
        addGestureRecognizer(guesture)
    }

    private func configureLayout() {
        addSubViews([icon, titleLabel])

        icon.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.small, bottomConstant: Theme.Offset.small)
        icon.anchorSquare(size: Theme.IconSize.normal)
        titleLabel.anchor(top: topAnchor, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.small, rightConstant: Constants.heigth / 2)
    }

    @objc func selected() {
        clousure(app)
    }
}
