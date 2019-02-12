//
//  WaitTimeDetailCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/11/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

struct WaitTimeDetailModel {
    let concurrence: Int
    let waitTime: Int
    let displayTime: String
}

class WaitTimeDetailCell: UICollectionViewCell, ReusableView {

    struct Constants {
        static let labelRadius: CGFloat = 2
        static let waitLabelSize: CGFloat = 35
        static let barSteps: CGFloat = 10
    }

    private let timeLabel = UIFactory.createLable(withTheme: UIThemes.Label.WaitTime)
    private let waitTimeLabel = UIFactory.createLable(withTheme: UIThemes.Label.WaitTime)
    private let spaceView = UIView()
    private let barView = UIView()
    private var barHeigthConstraint: NSLayoutConstraint?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        waitTimeLabel.roundCorners(withRadius: Constants.labelRadius)
        barView.backgroundColor = Theme.Pallete.blue
        barView.roundCorners(withRadius: Constants.labelRadius)
        spaceView.roundCorners(withRadius: Constants.labelRadius)
        spaceView.clipsToBounds = true
        spaceView.backgroundColor = Theme.Pallete.ligthGray
    }

    private func configureLayout() {
        addSubViews([spaceView, timeLabel, waitTimeLabel])
        spaceView.addSubview(barView)

        waitTimeLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        waitTimeLabel.anchorSize(height: Constants.waitLabelSize)
        spaceView.anchor(top: waitTimeLabel.bottomAnchor, left: leftAnchor, bottom: timeLabel.topAnchor, right: rightAnchor, topConstant: Theme.Offset.small, bottomConstant: Theme.Offset.small)
        barView.anchor(left: spaceView.leftAnchor, bottom: spaceView.bottomAnchor, right: spaceView.rightAnchor)
        barHeigthConstraint = barView.anchorSize(height: Theme.Offset.separator).first
        timeLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }

    func configure(withModel model: WaitTimeDetailModel) {
        timeLabel.text = model.displayTime
        waitTimeLabel.text = "\(model.waitTime) min" // LOCALIZE
        barHeigthConstraint?.constant = ((bounds.height - Constants.waitLabelSize - timeLabel.bounds.height) / Constants.barSteps) * CGFloat(model.concurrence)
        UIView.animate(withDuration: Theme.Animation.defaultInterval) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.spaceView.backgroundColor = Theme.Pallete.ligthGray
            strongSelf.waitTimeLabel.backgroundColor = strongSelf.getColorFor(waitTime: model.waitTime)
        }
    }

    fileprivate func getColorFor(waitTime: Int) -> UIColor {
        switch waitTime {
        case 0...6: return Theme.Pallete.waitLow
        case 7...8: return Theme.Pallete.waitMid
        case 9...10: return Theme.Pallete.waitHigh
        default: return Theme.Pallete.waitMax
        }
    }
}
