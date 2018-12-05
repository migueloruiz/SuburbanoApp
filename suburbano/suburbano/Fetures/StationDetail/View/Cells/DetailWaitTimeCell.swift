//
//  DetailWaitTimeCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 12/5/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DetailWaitTimeCell: UITableViewCell, DetailCell, ReusableIdentifier {
    
    struct Constants {
        static let waitTimeDetailCarrouselHeigth: CGFloat = 200
    }
    
    private let daySelector = DaySelectorView()
    private let waitTimeDetail = WaitTimeDetail()
    
    private var selctedWaitDay: Int = 0
    private var waitDaysDetals: [Int: [WaitTimeDetailModel]] = [:]
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        selectionStyle = .none
        accessibilityTraits = .notEnabled
        daySelector.delegate = self
    }
    
    private func configureLayout() {
        addSubViews([daySelector, waitTimeDetail])
        daySelector.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        waitTimeDetail.anchor(top: daySelector.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Theme.Offset.small, bottomConstant: Theme.Offset.large)
        waitTimeDetail.anchorSize(height: Constants.waitTimeDetailCarrouselHeigth)
    }
    
    func configure(with item: DetailItem) {
        switch item {
        case .waitTime(let days, let waitTimes):
            daySelector.configure(items: days)
            waitDaysDetals = waitTimes
            waitTimeDetail.configure(items: waitDaysDetals[selctedWaitDay] ?? [])
        default: break
        }
    }
}

extension DetailWaitTimeCell: DaySelectorDelegate {
    func didChange(daySelected: Int) {
        selctedWaitDay = daySelected
        waitTimeDetail.configure(items: waitDaysDetals[selctedWaitDay] ?? [])
    }
}
