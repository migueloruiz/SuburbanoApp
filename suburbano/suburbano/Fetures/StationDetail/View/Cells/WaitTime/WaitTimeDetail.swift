//
//  WaitTimeDetail.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/25/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

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

    private let fullIndicator = UIFactory.createImageView(image: UIImage(named: "people-full"), color: Theme.Pallete.softGray)
    private let midndicator = UIFactory.createImageView(image: UIImage(named: "people-mid"), color: Theme.Pallete.softGray)
    private let lowIndicator = UIFactory.createImageView(image: UIImage(named: "people-low"), color: Theme.Pallete.softGray)

    private var items = [WaitTimeDetailModel]()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: WaitTimeDetailCell.self)
    }

    private func configureLayout() {
        addSubViews([collectionView, fullIndicator, midndicator, lowIndicator])

        collectionView.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor)

        fullIndicator.anchor(top: topAnchor, left: leftAnchor, right: collectionView.leftAnchor, topConstant: Theme.Offset.extralarge, rightConstant: Theme.Offset.normal)
        fullIndicator.anchorSquare(size: Theme.IconSize.button)
        midndicator.center(x: fullIndicator.centerXAnchor, y: collectionView.centerYAnchor)
        lowIndicator.anchor(bottom: bottomAnchor, bottomConstant: Theme.Offset.large)
        lowIndicator.center(x: fullIndicator.centerXAnchor)
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
        guard let cell = collectionView.dequeueReusable(cell: WaitTimeDetailCell.self, for: indexPath) else { return UICollectionViewCell() }
        cell.configure(withModel: items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WaitTimeDetailCell.Constants.waitLabelSize, height: collectionView.frame.height)
    }
}
