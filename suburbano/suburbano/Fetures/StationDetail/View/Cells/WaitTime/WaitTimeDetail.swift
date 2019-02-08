//
//  WaitTimeDetail.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/25/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct WaitTimeDetailModel {
    let concurrence: Int
    let waitTime: Int
    let displayTime: String
}

class WaitTimeDetailCell: UICollectionViewCell, ReusableIdentifier {
    private let timeLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardDetails)
    private let waitTimeLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardDetails)
    private let spaceView = UIView()
    private let barView = UIView()
    private var barHeigthConstraint: NSLayoutConstraint?
    private let peopleImage = UIImageView(image: UIImage(named: "people"))

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        timeLabel.textAlignment = .center
        waitTimeLabel.textAlignment = .center
        waitTimeLabel.backgroundColor = .clear
        waitTimeLabel.roundCorners(withRadius: 2)
        barView.backgroundColor = Theme.Pallete.blue
        barView.roundCorners(withRadius: 2)
        spaceView.roundCorners(withRadius: 2)
        spaceView.clipsToBounds = true
        spaceView.backgroundColor = Theme.Pallete.ligthGray
        peopleImage.tintColor = .white
        peopleImage.contentMode = .scaleAspectFit
    }

    private func configureLayout() {
        // TODO remove hardcoded numbers
        addSubViews([spaceView, timeLabel, waitTimeLabel, peopleImage])
        spaceView.addSubview(barView)

        waitTimeLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        waitTimeLabel.anchorSize(height: 35)
        spaceView.anchor(top: waitTimeLabel.bottomAnchor, left: leftAnchor, bottom: timeLabel.topAnchor, right: rightAnchor, topConstant: Theme.Offset.small, bottomConstant: Theme.Offset.small)
        barView.anchor(left: spaceView.leftAnchor, bottom: spaceView.bottomAnchor, right: spaceView.rightAnchor)
        barHeigthConstraint = barView.anchorSize(height: 1).first
        peopleImage.anchor(top: barView.topAnchor, topConstant: Theme.Offset.small)
        peopleImage.center(x: barView.centerXAnchor, y: nil)
        peopleImage.anchorSquare(size: 15)
        timeLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        timeLabel.anchorSize(height: 20)
    }

    func configure(withModel model: WaitTimeDetailModel) {
        timeLabel.text = model.displayTime
        waitTimeLabel.text = "\(model.waitTime) min"
        barHeigthConstraint?.constant = ((bounds.height - 35 - 20) / 10) * CGFloat(model.concurrence)
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.spaceView.backgroundColor = Theme.Pallete.ligthGray
            strongSelf.waitTimeLabel.backgroundColor = strongSelf.getColorFor(waitTime: model.waitTime)
        }
    }

    fileprivate func getColorFor(waitTime: Int) -> UIColor {
        switch waitTime {
        case 6: return UIColor(named: "wait-low") ?? Theme.Pallete.ligthGray
        case 8: return UIColor(named: "wait-mid") ?? Theme.Pallete.ligthGray
        case 10: return UIColor(named: "wait-high") ?? Theme.Pallete.ligthGray
        default: return UIColor(named: "wait-veryhigh") ?? Theme.Pallete.ligthGray
        }
    }
}

class WaitTimeDetail: UIView {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = Theme.Offset.selector
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    private let fullIndicator = UIImageView(image: UIImage(named: "people-full"))
    private let midndicator = UIImageView(image: UIImage(named: "people-mid"))
    private let lowIndicator = UIImageView(image: UIImage(named: "people-low"))

    private var items = [WaitTimeDetailModel]()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        fullIndicator.tintColor = Theme.Pallete.softGray
        midndicator.tintColor = Theme.Pallete.softGray
        lowIndicator.tintColor = Theme.Pallete.softGray

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaitTimeDetailCell.self, forCellWithReuseIdentifier: WaitTimeDetailCell.reuseIdentifier)
    }

    private func configureLayout() {
        addSubViews([collectionView, fullIndicator, midndicator, lowIndicator])
        collectionView.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor)

        fullIndicator.anchor(top: topAnchor, left: leftAnchor, right: collectionView.leftAnchor, topConstant: 35, rightConstant: Theme.Offset.normal)
        fullIndicator.anchorSquare(size: 20)
        midndicator.center(x: fullIndicator.centerXAnchor, y: collectionView.centerYAnchor)
        lowIndicator.anchor(bottom: bottomAnchor, bottomConstant: 20)
        lowIndicator.center(x: fullIndicator.centerXAnchor, y: nil)
    }

    func configure(items: [WaitTimeDetailModel]) {
        self.items = items
        collectionView.reloadData()
    }

    func reload() {
        collectionView.reloadData()
    }
}

extension WaitTimeDetail: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rawCell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitTimeDetailCell.reuseIdentifier, for: indexPath)
        guard let cell = rawCell as? WaitTimeDetailCell else { return rawCell }
        cell.configure(withModel: items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: collectionView.frame.height)
    }
}
