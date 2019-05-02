//
//  ChartHeader.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ChartHeader: UIView {

    private let label = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        backgroundColor = .red
    }

    private func configureLayout() {
        addSubViews([label])
        label.textAlignment = .center
        label.fillSuperview()
    }

    func configure(title: String) {
        label.text = title
    }
}
