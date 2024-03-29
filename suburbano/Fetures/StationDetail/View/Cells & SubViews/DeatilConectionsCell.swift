//
//  DeatilConectionsCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DeatilConectionsCell: UITableViewCell, DetailCell, ReusableView {

    private let stackView = UIStackView.with(distribution: UIStackView.Distribution.fillProportionally, alignment: UIStackView.Alignment.trailing)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }

    private func configure() {
        selectionStyle = .none
        accessibilityTraits = .notEnabled
    }

    private func configureLayout() {
        addSubViews([stackView])
        stackView.fill()
    }

    func configure(with item: DetailItem) {
        switch item {
        case .conactions(let images):
            stackView.removeAllArrangedViews()
            for image in images {
                let imageView = UIImageView(image: UIImage(named: image))
                imageView.contentMode = .scaleAspectFit
                stackView.addArrangedSubview(imageView)
            }
        default: break
        }
    }
}
