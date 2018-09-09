//
//  DeatilConectionsCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DeatilConectionsCell: UITableViewCell, DetailCell, ReusableIdentifier {
    
    private let stackView = UIStackView.with(distribution: UIStackViewDistribution.fillProportionally, alignment: UIStackViewAlignment.trailing)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    private func configure() {
        selectionStyle = .none
        accessibilityTraits = UIAccessibilityTraitNotEnabled
    }
    
    private func configureLayout() {
        addSubViews([stackView])
        stackView.fillSuperview()
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
