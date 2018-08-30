//
//  CardBalancePicker.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct CardBalancePikerConstas {
    static let collectionWidth: CGFloat = 200
    static let defaultAlpha: CGFloat = 0.3
    static let itemWidth: CGFloat = {
        return 120 + (Theme.Offset.small * 2)
    }()
    static let interSapace: CGFloat = {
        return (CardBalancePikerConstas.collectionWidth - CardBalancePikerConstas.itemWidth) / 2
    }()
}

protocol CardBalancePickerDelegate: class {
    func addCard()
    func open(card: Card)
}

class CardBalancePicker: UIView {
    
    struct Constants {
        static let addButtonDiameter: CGFloat = Theme.IconSize.normal
    }
    
    private let containerView = UIView()
    private let addButton = UIButton()
    private let cardsCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: FadingLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.contentInset = UIEdgeInsets(top: 0, left: CardBalancePikerConstas.interSapace, bottom: 0, right: CardBalancePikerConstas.interSapace)
        return collection
    }()
    
    private let emptyMessageView = BalanceEmptyMessageView()
    private weak var delegate: CardBalancePickerDelegate?
    private var cards: [Card] = []
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(delegate: CardBalancePickerDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        
        // TODO factory for circular buttons with icon
        addButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        addButton.setImage(#imageLiteral(resourceName: "plus"), for: .focused)
        addButton.imageView?.tintColor = .white
        addButton.imageView?.contentMode = .center
        addButton.backgroundColor = Theme.Pallete.softGray
        addButton.anchorSquare(size: Constants.addButtonDiameter)
        addButton.roundCorners(withRadius: Constants.addButtonDiameter / 2)
        addButton.addTarget(self, action: #selector(CardBalancePicker.addCard), for: UIControlEvents.touchUpInside)
        
        let addCardGesture = UITapGestureRecognizer(target: self, action: #selector(CardBalancePicker.addCard))
        emptyMessageView.addGestureRecognizer(addCardGesture)
        emptyMessageView.isUserInteractionEnabled = true
        
        addButton.isHidden = false
        emptyMessageView.isHidden = true
        
        configureCollection()
        containerView.clipsToBounds = false
    }
    
    private func configureLayout() {
        addSubViews([containerView, emptyMessageView])
        
        containerView.fillSuperview()
        emptyMessageView.fillSuperview()
        
        containerView.addSubViews([cardsCollection, addButton])
        addButton.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor)
        cardsCollection.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor)
        cardsCollection.anchorSize(width: CardBalancePikerConstas.collectionWidth)
        cardsCollection.anchorCenterSuperview()
    }
    
    func display(cards newCards: [Card]) {
        cards = newCards
        if cards.isEmpty {
            containerView.isHidden = true
            emptyMessageView.isHidden = false
            bringSubview(toFront: emptyMessageView)
        } else {
            containerView.isHidden = false
            emptyMessageView.isHidden = true
            bringSubview(toFront: containerView)
        }
        cardsCollection.reloadData()
    }
    
    @objc func addCard() {
        delegate?.addCard()
    }
}

extension CardBalancePicker: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    fileprivate func configureCollection() {
        cardsCollection.clipsToBounds = false
        cardsCollection.dataSource = self
        cardsCollection.delegate = self
        cardsCollection.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cardCell = cell as? CardCell else { return }
        cardCell.configure(withCard: cards[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.open(card: cards[indexPath.row])
    }
}

class CardCell: UICollectionViewCell, ReusableIdentifier {
    
    struct Constants {
        static let heigth: CGFloat = Theme.IconSize.normal
    }
    
    private let containerView = UIFactory.createCardView()
    private let iconView = UIFactory.createLable(withTheme: UIThemes.Label.IconPicker)
    private let balanceLabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        backgroundColor = .white
        addDropShadow()
        roundCorners(withRadius: Constants.heigth / 2)
        iconView.roundCorners(withRadius: Constants.heigth / 2)
        iconView.clipsToBounds = true
        iconView.textColor = .white
        
        balanceLabel.textAlignment = .right
        balanceLabel.backgroundColor = .clear
    }
    
    private func configureLayout() {
        addSubViews([iconView, balanceLabel])
        
        iconView.anchorSquare(size: Constants.heigth)
        iconView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
        balanceLabel.anchor(top: topAnchor, left: iconView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: Theme.Offset.small, rightConstant: Theme.Offset.small)
    }
    
    func configure(withCard card: Card) {
        iconView.backgroundColor = card.displayColor
        iconView.text = card.icon
        balanceLabel.text = card.balance
    }
}

class FadingLayout: UICollectionViewFlowLayout,UICollectionViewDelegateFlowLayout {
    
    private var previousOffset: CGFloat = 0
    private var currentPage = 0
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    override func prepare() {
        setupLayout()
        super.prepare()
    }
    
    func setupLayout() {
        itemSize = CGSize(width: CardBalancePikerConstas.itemWidth, height: Theme.IconSize.normal)
        minimumLineSpacing = 0
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesSuper: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: attributesSuper, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        var visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        for attrs in attributes {
            guard attrs.frame.intersects(rect) else { continue }
            let distance = abs(visibleRect.midX - attrs.center.x)
            attrs.alpha = distance >= CardBalancePikerConstas.itemWidth ? CardBalancePikerConstas.defaultAlpha : abs((0.00005 * distance * distance * -1) + 1)
        }
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: itemIndexPath)
        attributes?.alpha = CardBalancePikerConstas.defaultAlpha
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: itemIndexPath)
        attributes?.alpha = CardBalancePikerConstas.defaultAlpha
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView,
        let itemsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else { return .zero }
        
        if (previousOffset > collectionView.contentOffset.x) && (velocity.x < 0) {
            currentPage = max(currentPage - 1, 0)
        } else if (previousOffset < collectionView.contentOffset.x) && (velocity.x > 0.0) {
            currentPage = min(currentPage + 1, itemsCount - 1);
        }
        
        let itemEdgeOffset = (collectionView.frame.width - itemSize.width -  minimumLineSpacing * 2) / 2
        let updatedOffset = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage) - (itemEdgeOffset + minimumLineSpacing)
        previousOffset = updatedOffset
        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
}
