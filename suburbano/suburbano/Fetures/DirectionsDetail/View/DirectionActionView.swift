//
//  DirectionActionView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 05/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DirectionActionView: UIView {
    
    private let app: DirectionsApp
    private let icon = UIImageView()
    private let titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(app: DirectionsApp) {
        self.app = app
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        backgroundColor = .white
        roundCorners(withRadius: (Theme.IconSize.normal + (Theme.Offset.small * 2)) / 2)
        addDropShadow()
        icon.image = app.icon
        icon.contentMode = .scaleAspectFit
        titleLabel.text = app.title
        titleLabel.backgroundColor = .clear
    }
    
    private func configureLayout() {
        addSubViews([icon, titleLabel])
        
        icon.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.small, bottomConstant: Theme.Offset.small)
        icon.anchorSquare(size: Theme.IconSize.normal)
        titleLabel.anchor(top: topAnchor, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.small, rightConstant: Theme.Offset.small)
    }
}
