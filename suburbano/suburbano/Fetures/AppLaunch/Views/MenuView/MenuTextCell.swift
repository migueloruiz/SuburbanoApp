//
//  MenuTextCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/18/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class MenuTextCell: UICollectionViewCell, ReusableIdentifier, MenuCell {
    
    private let titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    private func configureLayout() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.fillSuperview()
        titleLabel.textAlignment = .center
        titleLabel.textColor = Theme.Pallete.softGray
    }
    
    func configure(withValue value: String) {
        titleLabel.text = value
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? Theme.Pallete.darkGray : Theme.Pallete.softGray
        }
    }
}
