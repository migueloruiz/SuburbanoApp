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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    private func configureUI() {
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
