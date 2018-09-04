//
//  DetailAddressCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DetailAddressCell: UITableViewCell, DetailCell, ReusableIdentifier {
    
    private let addressLable = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        addressLable.textColor = Theme.Pallete.darkGray
    }
    
    private func configureLayout() {
        addSubViews([addressLable])
        addressLable.fillSuperview()
    }
    
    func configure(with item: DetailItem) {
        switch item {
        case .location(let address):
            addressLable.text = address
        default: break
        }
    }
}
