//
//  ChartAnotation.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/1/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

struct ChartAnotationModel {
    let title: String
    let color: UIColor
}

class ChartAnotation: UIView {

    private let colorView = UIView()
    private let titleLabel = UILabel(fontStyle: .detail, alignment: .center, line: .oneLinne, color: .primary)

    init(model: ChartAnotationModel) {
        super.init(frame: .zero)
        configureUI(withModel: model)
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(withModel model: ChartAnotationModel) {
        colorView.backgroundColor = model.color
        colorView.roundCorners(withDiameter: Theme.IconSize.extraSmall)
        titleLabel.text = model.title
    }

    private func configureLayout() {
        addSubViews([colorView, titleLabel])

        colorView.center(y: colorView.centerYAnchor)
        colorView.anchor(left: leftAnchor, leftConstant: Theme.Offset.small)
        colorView.anchorSquare(size: Theme.IconSize.extraSmall)

        titleLabel.center(y: colorView.centerYAnchor)
        titleLabel.anchor(left: colorView.rightAnchor, right: rightAnchor, leftConstant: Theme.Offset.small, rightConstant: Theme.Offset.small)
    }
}
