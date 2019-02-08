//
//  MenuView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum MenuSelectorStyle {
    case top
    case bottom
}

enum MenuItemCase {
    case image
    case text

    var cellClass: AnyClass? {
        switch self {
        case .image: return MenuIconCell.self
        case .text: return MenuTextCell.self
        }
    }

    var cellIdentifier: String {
        switch self {
        case .image: return MenuIconCell.reuseIdentifier
        case .text: return MenuTextCell.reuseIdentifier
        }
    }
}

protocol MenuDelegate: class {
    func itemSelected(at index: Int)
}

class MenuView: UIView {

    private let selectorStyle: MenuSelectorStyle
    private let menuItemCase: MenuItemCase
    private let itemHeigth: CGFloat

    private let menuSelector: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Pallete.softRed
        return view
    }()

    private let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
    }()

    private var selectorWidthConstraint: NSLayoutConstraint?
    private var selectorSideConstraint: NSLayoutConstraint?
    fileprivate var menuItemSize: CGSize?
    fileprivate var items: [String] = []
    weak var delegate: MenuDelegate?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(menuItemCase: MenuItemCase, selectorStyle: MenuSelectorStyle, itemHeigth: CGFloat) {
        self.selectorStyle = selectorStyle
        self.itemHeigth = itemHeigth
        self.menuItemCase = menuItemCase
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        backgroundColor = .white
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.isScrollEnabled = false
        menuCollectionView.register(menuItemCase.cellClass, forCellWithReuseIdentifier: menuItemCase.cellIdentifier)
        menuCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }

    private func configureLayout() {
        addSubViews([menuCollectionView, menuSelector])

        menuCollectionView.fillSuperview()
        menuCollectionView.anchorSize(height: itemHeigth)

        switch selectorStyle {
        case .top: menuSelector.anchor(top: topAnchor)
        case .bottom: menuSelector.anchor(bottom: bottomAnchor)
        }
        menuSelector.anchorSize(height: Theme.Offset.selector)
        selectorSideConstraint = menuSelector.anchor(left: leftAnchor).first
        selectorWidthConstraint = menuSelector.anchorSize(width: itemHeigth).first
    }

    func configure(items: [String], selected: Int = 0) {
        self.items = items
        menuItemSize = CGSize(width: Utils.screenWidth / CGFloat(items.count), height: itemHeigth)
        selectorWidthConstraint?.constant = menuItemSize?.width ?? 0
        selectorSideConstraint?.constant = CGFloat(selected) * (menuItemSize?.width ?? 0)
        menuCollectionView.reloadData()
        menuCollectionView.selectItem(at: IndexPath(row: selected, section: 0), animated: false, scrollPosition: .left)
    }

    fileprivate func animateSelector(to index: Int) {
        selectorSideConstraint?.constant = CGFloat(index) * (menuItemSize?.width ?? 0)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in // TODO
            guard let strongSelf = self else { return }
            strongSelf.layoutIfNeeded()
        }, completion: nil)
    }
}

extension MenuView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuItemCase.cellIdentifier, for: indexPath)
        if let menuCell = cell as? MenuCell {
            menuCell.configure(withValue: items[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return menuItemSize ?? CGSize(width: 0, height: itemHeigth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        animateSelector(to: indexPath.row)
        delegate?.itemSelected(at: indexPath.row)
    }
}
