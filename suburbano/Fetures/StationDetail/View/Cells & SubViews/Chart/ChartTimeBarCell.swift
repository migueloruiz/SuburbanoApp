//
//  WaitTimeDetailCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/11/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

struct ChartBarModel {
    let value: Int
    let label: String
}

class ChartTimeBarCell: UICollectionViewCell, ReusableView {

    private let timeLabel = UIFactory.createLable(withTheme: UIThemes.Label.WaitTime)
    private let barView = ChartBar()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        timeLabel.textColor = Theme.Pallete.darkGray
        timeLabel.font = FontStyle(size: .h2, largeFactor: Theme.FontFactor.large, name: .openSansCondensed, style: .bold).getScaledFont()

        configureLayout()
    }

    private func configureLayout() {
        addSubViews([barView, timeLabel])
        barView.anchor(top: topAnchor, left: leftAnchor, bottom: timeLabel.topAnchor, right: rightAnchor, bottomConstant: Theme.Offset.small)

        timeLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        timeLabel.anchorSize(height: 15)
    }

    func configure(withModel model: ChartBarModel, maxValue: Int, shouldDisplaytime: Bool, topColor: UIColor, bottomColor: UIColor) {
        timeLabel.text =  shouldDisplaytime ? model.label : "•"
        barView.configure(withModel: model, maxValue: maxValue, topColor: topColor, bottomColor: bottomColor)
        setNeedsLayout()
    }
}
