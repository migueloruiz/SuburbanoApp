//
//  DaySelectorView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/24/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DaySelectorCell: UICollectionViewCell, ReusableIdentifier {
    
    private let label = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        backgroundColor = .white
    }
    
    private func configureLayout() {
        addSubViews([label])
        label.textAlignment = .center
        label.fillSuperview()
    }
    
    func configure(title: String) {
        label.text = title
    }
}

protocol DaySelectorDelegate: class {
    func didChange(daySelected: Int)
}

class DaySelectorView: UIView {
    
    weak var delegate: DaySelectorDelegate?
    
    private let leftButton = UIFactory.createCircularButton(image: UIImage(named: "left-arrow"), tintColor: Theme.Pallete.darkGray, backgroundColor: .white, addShadow: false)
    private let rightButton = UIFactory.createCircularButton(image: UIImage(named: "rigth-arrow"), tintColor: Theme.Pallete.darkGray, backgroundColor: .white, addShadow: false)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.isPagingEnabled = true
        collection.isScrollEnabled = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private var items = [String]()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        leftButton.addTarget(self, action: #selector(DaySelectorView.moveLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(DaySelectorView.moveRight), for: .touchUpInside)
        configureCollection()
    }
    
    private func configureLayout() {
        addSubViews([collectionView, leftButton, rightButton])
        anchorSize(height: Theme.IconSize.large)
        collectionView.fillSuperview()
        leftButton.anchor(left: leftAnchor, leftConstant: Theme.Offset.normal)
        leftButton.center(x: nil, y: centerYAnchor)
        rightButton.anchor(right: rightAnchor, rightConstant: Theme.Offset.normal)
        rightButton.center(x: nil, y: centerYAnchor)
    }
    
    func configure(items: [String], selected: Int? = nil) {
        self.items = items
        collectionView.reloadData()
        guard let index = selected else { return }
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: false)
    }
    
    @objc func moveLeft() {
        guard let selectedIndex = collectionView.indexPathsForVisibleItems.first else { return }
        let next = (selectedIndex.row - 1) >= 0 ? (selectedIndex.row - 1) : (items.count - 1)
        delegate?.didChange(daySelected: next)
        collectionView.scrollToItem(at: IndexPath(row: next, section: 0), at: .left, animated: true)
        selectionFeedback.selectionChanged()
    }
    
    @objc func moveRight() {
        guard let selectedIndex = collectionView.indexPathsForVisibleItems.first else { return }
        let next = (selectedIndex.row + 1) < items.count ? (selectedIndex.row + 1) : 0
        delegate?.didChange(daySelected: next)
        collectionView.scrollToItem(at: IndexPath(row: next, section: 0), at: .left, animated: true)
        selectionFeedback.selectionChanged()
    }
}

extension DaySelectorView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    fileprivate func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DaySelectorCell.self, forCellWithReuseIdentifier: DaySelectorCell.reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rawCell = collectionView.dequeueReusableCell(withReuseIdentifier: DaySelectorCell.reuseIdentifier, for: indexPath)
        guard let cell = rawCell as? DaySelectorCell else { return rawCell }
        cell.configure(title: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
