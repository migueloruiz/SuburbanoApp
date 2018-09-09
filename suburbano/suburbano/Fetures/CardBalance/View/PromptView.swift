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
    
    private let labelTheme: LabelTheme
    private lazy var icon = UIFactory.createImageView(image: nil, color: Theme.Pallete.softGray)
    private lazy var disclaimerLabel = UIFactory.createLable(withTheme: labelTheme)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(labelTheme: LabelTheme = UIThemes.Label.ActivityCardBody) {
        self.labelTheme = labelTheme
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    func configure(disclaimer: String, icon image: UIImage = #imageLiteral(resourceName: "exclamation")) {
        icon.image = image
        disclaimerLabel.text = disclaimer
    }
    
    private func configureUI() {
        icon.contentMode = .scaleAspectFit
        icon.tintColor = labelTheme.textColor
        icon.backgroundColor = labelTheme.backgroundColor
    }
    
    private func configureLayout() {
        addSubViews([icon, disclaimerLabel])
        
        icon.anchor(left: leftAnchor)
        icon.center(x: nil, y: disclaimerLabel.centerYAnchor)
        icon.anchorSquare(size: Constants.IconHeigth)
        
        disclaimerLabel.anchor(top: topAnchor, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: Theme.Offset.normal)
    }
}
