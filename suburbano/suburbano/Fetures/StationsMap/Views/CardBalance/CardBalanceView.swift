//
//  CardBalanceView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol CardBalancePickerDelegate: class {
    func addCard()
    func openCard(withId id: String)
}

class CardBalancePicker: UIView {
    
    struct Constants {
        static let addButtonDiameter: CGFloat = Theme.IconSize.normal
    }
    
    private let addButton = UIButton()
    private let emptyMessageView = BalanceEmptyMessageView()
    private weak var delegate: CardBalancePickerDelegate?
    
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
    }
    
    private func configureLayout() {
        addSubViews([emptyMessageView, addButton])
        addButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
        emptyMessageView.fillSuperview()
    }
    
    func display(elements: [Card]) {
        guard !elements.isEmpty else {
            addButton.isHidden = true
            emptyMessageView.isHidden = false
            return
        }
        
        addButton.isHidden = false
        emptyMessageView.isHidden = true
    }
    
    @objc func addCard() {
        delegate?.addCard()
    }
}
