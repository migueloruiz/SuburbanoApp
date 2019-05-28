//
//  BalanceEmptyMessageView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class BalanceEmptyMessageView: UIView {

    struct Constants {
        static let addButtonDiameter: CGFloat = Theme.IconSize.normal
    }

    private let addIconView = UIImageView(image: #imageLiteral(resourceName: "plus"))
    private let messageLabel = UILabel(fontStyle: .primary, alignment: .center, line: .multiline, color: .clear)
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        clipsToBounds = true
        backgroundColor = Theme.Pallete.softGray.withAlphaComponent(0.7)
        roundCorners(withRadius: Constants.addButtonDiameter / 2)

        addIconView.tintColor = Theme.Pallete.white
        addIconView.contentMode = .center
        addIconView.backgroundColor = Theme.Pallete.softGray
        addIconView.anchorSquare(size: Constants.addButtonDiameter)
        addIconView.roundCorners(withRadius: Constants.addButtonDiameter / 2)

        messageLabel.text = "Agrega una tarjeta para consultar tu saldo" // Localize
    }

    private func configureLayout() {
        addSubViews([blurredEffectView, messageLabel, addIconView])
        blurredEffectView.fill()
        addIconView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
        messageLabel.anchor(top: topAnchor, left: addIconView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: Theme.Offset.normal, rightConstant: Theme.Offset.normal)
    }
}
