//
//  DetailHeaderView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DetailHeaderView: UITableViewHeaderFooterView, ReusableView {

    struct Constant {
        static let addressHeigth: CGFloat = 20
    }

//    static var cellHeight: CGFloat = Constant.addressHeigth + Theme.Offset.normal

    private let addressLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }

    private func configureUI() {
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = .white
        accessibilityTraits = UIAccessibilityTraits.notEnabled
        addressLabel.textColor = Theme.Pallete.darkGray
    }

    private func configureLayout() {
        addSubViews([addressLabel])
        addressLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Theme.Offset.small, bottomConstant: Theme.Offset.small)
        addressLabel.anchorSize(height: Constant.addressHeigth)
    }

    func configure(with detail: DetailSection) {
        addressLabel.text = detail.title
    }
}
