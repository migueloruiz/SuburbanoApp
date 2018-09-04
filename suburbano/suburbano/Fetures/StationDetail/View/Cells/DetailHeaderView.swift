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
        configureLayout()
    }
    
    private func configureLayout() {
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = .white
        addSubViews([addressLabel])
        addressLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        addressLabel.anchorSize(height: 30)
        addressLabel.textColor = Theme.Pallete.darkGray
    }
    
    func configure(with detail: DetailSection) {
        addressLabel.text = detail.title
    }
}
