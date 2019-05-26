//
//  CardIconSelctionView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol IconInputViewDelegate: class {
    func update(icon: CardBalanceIcon)
}

class IconInputView: UIInputView {

    struct Constants {
        static let iconsCollectionTag = 10
        static let defaultIcon = "\u{e91b}"
    }

    private let colors = [Theme.Pallete.concert, Theme.Pallete.workshop, Theme.Pallete.fair, Theme.Pallete.exhibition, Theme.Pallete.special, Theme.Pallete.softRed]
    private let icons = [
        ["\u{e901}", "\u{e902}", "\u{e904}", "\u{e905}", "\u{e906}", "\u{e900}", "\u{e903}", "\u{e907}", "\u{e908}", "\u{e909}"],
        ["\u{e90b}", "\u{e90a}", "\u{e90c}", "\u{e90d}", "\u{e90e}", "\u{e910}", "\u{e911}", "\u{e912}", "\u{e914}", "\u{e91a}"],
        ["\u{e90f}", "\u{e913}", "\u{e915}", "\u{e916}", "\u{e917}", "\u{e918}", "\u{e919}", "\u{e93f}", "\u{e941}", "\u{e985}"],
        ["\u{e999}", "\u{e99e}", "\u{e99f}", "\u{e9a0}", "\u{e9a2}", "\u{e9a9}", "\u{e9aa}", "\u{e9ae}", "\u{e9d9}", "\u{e9da}"],
        ["\u{e9db}", "\u{e9dc}", "\u{e9dd}", "\u{e9df}", "\u{e9e1}", "\u{e9e3}", "\u{e9e5}", "\u{e9e7}", "\u{e9e9}", "\u{e9eb}"],
        ["\u{e9ed}", "\u{e9ef}", "\u{e9f1}", "\u{e9f3}", "\u{e9f5}", "\u{e9f7}", "\u{e9f9}", "\u{e9fb}", "\u{e9fd}", "\u{e9ff}"]
    ]

    weak var delegate: IconInputViewDelegate?
    private var selectedColor: UIColor?
    private var selectedIcon: String?
    private let pageControl = UIPageControl()
    private let colorsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    private let iconsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.roundCorners(withRadius: Theme.Rounded.card)
        return collection
    }()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init() {
        super.init(frame: .zero, inputViewStyle: .keyboard)
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        configureMenu()
    }

    private func configureLayout() {
        anchorSize(width: UIDevice.screenWidth)
        addSubViews([colorsCollection, iconsCollection, pageControl])

        colorsCollection.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.small, rightConstant: Theme.Offset.small)
        colorsCollection.anchorSize(height: Theme.IconSize.normal)
        colorsCollection.roundCorners(withRadius: Theme.IconSize.normal / 2)

        iconsCollection.anchor(top: colorsCollection.bottomAnchor, left: colorsCollection.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: colorsCollection.rightAnchor, topConstant: Theme.Offset.normal, bottomConstant: Theme.Offset.small)

        pageControl.anchor(top: iconsCollection.bottomAnchor)
        pageControl.anchorSize(height: Theme.Offset.large)
        pageControl.anchorCenterXToSuperview()
        pageControl.pageIndicatorTintColor = Theme.Pallete.softGray
        pageControl.currentPageIndicatorTintColor = Theme.Pallete.darkGray
    }
}

extension IconInputView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    fileprivate func configureMenu() {
        iconsCollection.dataSource = self
        iconsCollection.delegate = self
        iconsCollection.register(cell: IconCell.self)
        iconsCollection.tag = Constants.iconsCollectionTag

        colorsCollection.dataSource = self
        colorsCollection.delegate = self
        colorsCollection.register(cell: ColorCell.self)
        colorsCollection.backgroundColor = .white

        iconsCollection.reloadData()
        colorsCollection.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView.tag {
        case Constants.iconsCollectionTag:
            pageControl.numberOfPages = icons.count
            return icons.count
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case Constants.iconsCollectionTag:
            return icons[section].count
        default:
            return colors.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case Constants.iconsCollectionTag:
            guard let cell = collectionView.dequeueReusable(cell: IconCell.self, for: indexPath) else { return UICollectionViewCell() }
            cell.configure(withIcon: icons[indexPath.section][indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusable(cell: ColorCell.self, for: indexPath) else { return UICollectionViewCell() }
            cell.configure(withColor: colors[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case Constants.iconsCollectionTag:
            return CGSize(width: collectionView.bounds.width / IconCell.Constant.expectedCellsInRow,
                          height: collectionView.frame.height / 2)
        default:
            return CGSize(width: collectionView.bounds.width / ColorCell.Constants.expectedCellsInRow,
                          height: Theme.IconSize.normal)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case Constants.iconsCollectionTag:
            selectedIcon = icons[indexPath.section][indexPath.row]
        default:
            selectedColor = colors[indexPath.row]
        }

        let icon = CardBalanceIcon.custome(iconCode: selectedIcon ?? Constants.defaultIcon,
                                           color: selectedColor ?? Theme.Pallete.softGray)
        delegate?.update(icon: icon)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard collectionView.tag == Constants.iconsCollectionTag else { return }
        pageControl.currentPage = indexPath.section
    }
}
