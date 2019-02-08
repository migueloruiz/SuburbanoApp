//
//  IconCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell, ReusableView {

    private let iconView = UIFactory.createLable(withTheme: UIThemes.Label.IconPicker)

    override var isSelected: Bool {
        didSet { iconView.textColor = isSelected ? Theme.Pallete.darkGray : Theme.Pallete.softGray }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        iconView.roundCorners(withRadius: frame.height / 2)
        iconView.tintColor = Theme.Pallete.softGray
        iconView.contentMode = .scaleAspectFit
    }

    private func configureLayout() {
        addSubViews([iconView])
        iconView.anchorSquare(size: Theme.IconSize.large)
        iconView.anchorCenterSuperview()
    }

    func configure(withIcon iconCode: String) {
        iconView.text = iconCode
    }
}
