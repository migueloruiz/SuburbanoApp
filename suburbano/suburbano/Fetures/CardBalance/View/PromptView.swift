//
//  PromptView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class PromptView: UIView {
    
    struct Constants {
        static let IconHeigth: CGFloat = Theme.IconSize.small
    }
    
    private lazy var icon = UIFactory.createImageView(image: nil, color: Theme.Pallete.softGray)
    private lazy var disclaimerLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    
    func configure(disclaimer: String, icon image: UIImage = #imageLiteral(resourceName: "exclamation")) {
        configureUI(disclaimer: disclaimer, icon: image)
        configureLayout()
    }
    
    private func configureUI(disclaimer: String, icon image: UIImage) {
        addSubViews([icon, disclaimerLabel])
        
        icon.image = image
        disclaimerLabel.text = disclaimer
    }
    
    private func configureLayout() {
        icon.anchor(left: leftAnchor)
        icon.center(x: nil, y: disclaimerLabel.centerYAnchor)
        icon.anchorSquare(size: Constants.IconHeigth)
        
        disclaimerLabel.anchor(top: topAnchor, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: Theme.Offset.normal)
    }

}
