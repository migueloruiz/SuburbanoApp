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
    private let addButton = UIButton(circularStyle: .gray, image: #imageLiteral(resourceName: "plus"))

    private let cardsCollection = FadingCollectionView()
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
        addButton.addTarget(self, action: #selector(CardBalancePicker.addCard), for: .touchUpInside)
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

        containerView.fill()
        emptyMessageView.fill()

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
            bringSubviewToFront(emptyMessageView)
        } else {
            containerView.isHidden = false
            emptyMessageView.isHidden = true
            bringSubviewToFront(containerView)
        }
        cardsCollection.reloadData()
        cardsCollection.collectionViewLayout.finalizeCollectionViewUpdates()
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
        cardsCollection.register(cell: CardCell.self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cell: CardCell.self, for: indexPath)
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cardCell = cell as? CardCell else { return }
        cardCell.configure(withCard: cards[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.open(card: cards[indexPath.row])
    }
}
