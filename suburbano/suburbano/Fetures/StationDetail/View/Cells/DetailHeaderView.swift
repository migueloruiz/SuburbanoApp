//
//  DetailHeaderView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DetailHeaderView: UITableViewHeaderFooterView, ReusableIdentifier {
    
    private let addressLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = .white
        accessibilityTraits = UIAccessibilityTraitNotEnabled
        addressLabel.textColor = Theme.Pallete.darkGray // TODO: Add Theme
    }
    
    private func configureLayout() {
        addSubViews([addressLabel])
        addressLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Theme.Offset.small, bottomConstant: Theme.Offset.small)
    }
    
    func configure(with detail: DetailSection) {
        addressLabel.text = detail.title
    }
}
