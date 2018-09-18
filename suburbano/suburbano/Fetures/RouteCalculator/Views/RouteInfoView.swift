//
//  RouteInfoView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class RouteInfoItem: UIView {
    private let titleLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let amountLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)
    
    var title: String {
        get {
            return titleLabel.text ?? ""
        }
        
        set(newValue) {
            titleLabel.text = newValue
        }
    }
    
    var amount: String {
        get {
            return amountLabel.text ?? ""
        }
        
        set(newValue) {
            amountLabel.text = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        titleLabel.textColor = Theme.Pallete.softRed
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        amountLabel.textAlignment = .center
        amountLabel.backgroundColor = .clear
    }
    
    private func configureLayout() {
        addSubViews([titleLabel, amountLabel])
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: Theme.Offset.small)
        amountLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, bottomConstant: Theme.Offset.small)
    }
}

class RouteInfoView: UIView {
    
    private let timeItem = RouteInfoItem()
    private let distanceItem = RouteInfoItem()
    private let priceItem = RouteInfoItem()
    private let containerView = UIStackView.with(axis: .horizontal, distribution: .fillEqually, alignment: .fill, spacing: Theme.Offset.small)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        backgroundColor = Theme.Pallete.ligthGray
        timeItem.title = "Tiempo" // Localize
        distanceItem.title = "Distancia" // Localize
        priceItem.title = "Tarifa" // Localize
    }
    
    private func configureLayout() {
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addArranged(subViews: [timeItem, distanceItem, priceItem])
    }
    
    func update(with displayInfo: DisplayRouteInformation) {
        timeItem.amount = displayInfo.time
        distanceItem.amount = displayInfo.distance
        priceItem.amount = displayInfo.price
    }
}
