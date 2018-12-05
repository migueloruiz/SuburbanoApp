//
//  DetailScheduleCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DetailScheduleCell: UITableViewCell, DetailCell, ReusableIdentifier {
    
    private let daysLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let scheduleLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        selectionStyle = .none
        accessibilityTraits = UIAccessibilityTraits.notEnabled
        scheduleLabel.textColor = Theme.Pallete.darkGray
        scheduleLabel.textAlignment = .right
    }
    
    private func configureLayout() {
        addSubViews([daysLabel, scheduleLabel])
        daysLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
        scheduleLabel.anchorSize(height: 20)
        scheduleLabel.anchor(top: topAnchor, left: daysLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    func configure(with item: DetailItem) {
        switch item {
        case .schedule(let dia):
            daysLabel.text = dia.selectionText
            scheduleLabel.text = "\(dia.openTime) - \(dia.closeTime)"
        default: break
        }
    }
}
