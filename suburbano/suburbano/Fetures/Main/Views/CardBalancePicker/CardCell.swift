//
//  CardCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell, ReusableView {

    struct Constants {
        static let heigth: CGFloat = Theme.IconSize.normal
    }

    private let containerView = UIFactory.createCardView()
    private let iconView = UIFactory.createLable(withTheme: UIThemes.Label.CardPickerIcon)
    private let balanceLabel = UIFactory.createLable(withTheme: UIThemes.Label.CardPickerTitle)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        iconView.roundCorners(withDiameter: Constants.heigth)
        iconView.clipsToBounds = true

        balanceLabel.textAlignment = .right
        balanceLabel.backgroundColor = .clear
        containerView.roundCorners(withDiameter: Constants.heigth)
    }

    private func configureLayout() {
        addSubViews([containerView])
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: Theme.Offset.small, rightConstant: Theme.Offset.small)

        containerView.addSubViews([iconView, balanceLabel])

        iconView.anchorSquare(size: Constants.heigth)
        iconView.anchor(left: containerView.leftAnchor)
        iconView.center(x: nil, y: containerView.centerYAnchor)

        balanceLabel.anchor(top: containerView.topAnchor, left: iconView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, rightConstant: Theme.Offset.small)
    }

    func configure(withCard card: Card) {
        iconView.backgroundColor = UIColor.from(data: card.color)
        iconView.text = card.icon
        balanceLabel.text = card.balance
    }
}
