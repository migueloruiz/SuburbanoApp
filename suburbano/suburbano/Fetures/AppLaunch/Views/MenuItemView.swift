//
//  MenuItemView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 14/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class MenuItemView: UICollectionViewCell, ReusableIdentifier {
    
    struct Constants {
        static let size: CGFloat = 29
    }
    
    private lazy var iconView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    private func configureLayout() {
        backgroundColor = .white
        addSubview(iconView)
        iconView.anchorCenterSuperview()
        iconView.anchor(widthConstant: Constants.size, heightConstant: Constants.size)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = Theme.Pallete.softGray
    }
    
    func configure(image: UIImage) {
        iconView.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    override var isSelected: Bool {
        didSet {
            iconView.tintColor = isSelected ? Theme.Pallete.softRed : Theme.Pallete.softGray
        }
    }
}
