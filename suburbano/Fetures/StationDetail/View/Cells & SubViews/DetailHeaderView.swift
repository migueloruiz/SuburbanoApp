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

    private let titleLabel = UILabel(fontStyle: .primary, alignment: .left, line: .oneLinne, color: .detail)

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
        titleLabel.textColor = Theme.Pallete.darkGray
    }

    private func configureLayout() {
        addSubViews([titleLabel])
        titleLabel.fillVertically(offset: Theme.Offset.small)
        titleLabel.fillHorizontal(offset: Theme.Offset.large)
    }

    func configure(with detail: DetailSection) {
        titleLabel.text = detail.title
    }
}
