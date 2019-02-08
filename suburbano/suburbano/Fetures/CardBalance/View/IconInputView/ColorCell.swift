//
//  ColorCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 26/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell, ReusableView {

    struct Constants {
        static let defaultBorder: CGFloat = 0
        static let selectedBorder: CGFloat = 3
    }

    private let colorView = UIView()
    override var isSelected: Bool {
        didSet { colorView.layer.borderWidth = isSelected ? Constants.selectedBorder : Constants.defaultBorder }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        colorView.roundCorners(withRadius: Theme.IconSize.small / 2)
        colorView.layer.borderColor = Theme.Pallete.darkGray.cgColor
    }

    private func configureLayout() {
        addSubViews([colorView])
        colorView.anchorSquare(size: Theme.IconSize.small)
        colorView.anchorCenterSuperview()
    }

    func configure(withColor color: UIColor) {
        colorView.backgroundColor = color
    }
}
