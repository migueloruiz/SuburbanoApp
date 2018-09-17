//
//  DetailAddressCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol DetailAddressCellDelegate: class {
    func showLocation()
}

class DetailAddressCell: UITableViewCell, DetailCell, ReusableIdentifier {
    
    private let addressLable = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let addressButton = UIFactory.createCircularButton(image: #imageLiteral(resourceName: "cursor"), tintColor: .white, backgroundColor: Theme.Pallete.blue)
    weak var delegate: DetailAddressCellDelegate?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        selectionStyle = .none
        accessibilityTraits = UIAccessibilityTraits.notEnabled
        addressLable.textColor = Theme.Pallete.darkGray
        addressButton.addTarget(self, action: #selector(DetailAddressCell.showLocation), for: .touchUpInside)
    }
    
    private func configureLayout() {
        addSubViews([addressLable, addressButton])
        addressLable.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
        addressButton.anchor(left: addressLable.rightAnchor, right: rightAnchor, leftConstant: Theme.Offset.normal, rightConstant: Theme.Offset.small)
        addressButton.center(x: nil, y: centerYAnchor)
    }
    
    func configure(with item: DetailItem) {
        switch item {
        case .location(let address):
            addressLable.text = address
        default: break
        }
    }
    
    @objc func showLocation() {
        delegate?.showLocation()
    }
}
