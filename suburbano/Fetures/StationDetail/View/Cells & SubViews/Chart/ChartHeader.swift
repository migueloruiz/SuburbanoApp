//
//  ChartHeader.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ChartHeader: UIView {

    private let titleLabel = UILabel(fontStyle: .primary, alignment: .center, line: .oneLinne, color: .primary)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        backgroundColor = .red
    }

    private func configureLayout() {
        addSubViews([titleLabel])
        titleLabel.textAlignment = .center
        titleLabel.fill()
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
