//
//  ChartBarView.swift
//  suburbano-prod
//
//  Created by Miguel Ruiz on 5/1/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

class ChartBar: UIView {

    struct Constants {
        static let width: CGFloat = 12
    }

    var topColor: UIColor = Theme.Pallete.darkRed {
        didSet { updateGradientColors() }
    }

    var bottomColor: UIColor = Theme.Pallete.waitLow {
        didSet { updateGradientColors() }
    }

    private var value: Int = 0
    private var maxValue: Int = 0

    private let barView = UIView()
    private let valueView = UIView()
    private var gradientLayer = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureUI() {
        backgroundColor = Theme.Pallete.ligthGray
        roundCorners(withDiameter: Constants.width)
        clipsToBounds = true

        valueView.roundCorners(withDiameter: Constants.width)
        valueView.backgroundColor = .blue

        barView.mask = valueView
        updateGradientColors()
        gradientLayer.locations = [0.0, 0.8]
        barView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
    }

    private func configureLayout() {
        addSubview(barView)
        barView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    private func updateGradientColors() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }

    func configure(withModel model: ChartBarModel, maxValue: Int, topColor newTopColor: UIColor, bottomColor newBottomColor: UIColor) {
        self.value = model.value
        self.maxValue = maxValue
        topColor =!= newTopColor
        bottomColor =!= newBottomColor
        layoutSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = barView.bounds

        guard maxValue > 0 else { return }

        var barHeight = (barView.bounds.height / CGFloat(maxValue)) * CGFloat(value)
        barHeight = min(barView.bounds.height, barHeight)
        let barVerticalPosition = barView.bounds.height - barHeight
        let valueRect = CGRect(x: barView.bounds.origin.x,
                               y: barVerticalPosition,
                               width: barView.bounds.width,
                               height: barHeight)
        valueView.frame = valueRect
    }
}
